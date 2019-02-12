#----------------------------
#Login para Termux em bash
#By Z4h4rd and @kuartz
#---------------------------

#!/bin/bash
database=db.txt #Banco de Dados 
array_nr=(`grep ^nr db.txt | cut -c 6- | grep .`)
array_sr=(`grep ^sr db.txt | cut -c 6- | grep .`)

RED=`tput setaf 1`
BOLD=`tput bold`
GREEN=`tput setaf 2`
OFF="\e[m"

clear
cadastro(){ #Funçao para realizar cadastro de UnicoUsuario
	#clear
	echo ".:Novo Usuario:."
	if [ ! -f $database ]; then #Cria o database se ele não existir
		touch db.txt
	fi
	if [[ ${#array_nr[@]} -eq 0 && ${#array_sr[@]} -eq 0 ]]; then
		echo -e $GREEN"Verificação Ok! Sem usuario cadastrado";tput sgr0
		while [[ i != 1 ]]; do
			echo "Digite seu nome de usuario: " 
			read nome_registro
			if [ "$(echo $nome_registro | grep "^[0-9A-Za-z]*$")" ]; then
				echo "Digite sua senha: "
				read senha_registro
				if [[ "$(echo $senha_registro | grep "^[0-9A-Za-z]*$")" ]]; then
					echo "Digite o numero de celular para recuperação: "
					read num_registro
					if [[ "$(echo $num_registro | grep "^[0-9\+]*$")" ]]; then
						echo -e $RED"		 Atenção";tput sgr0
						echo "Coloque uma pergunta que você possa se lembrar da resposta."
						echo "Digite sua pergunta de recuperação: "
						read pergun
						if [[ "$(echo $pergun | grep "^[0-9A-Za-z]*$")" ]]; then
							echo "Digite sua resposta: "
							read resp
							if [[ "$(echo $resp | grep "^[0-9A-Za-z]*$")" ]]; then
								i=1
								break
							else
								clear;
								echo -e $RED"Somente número ou letras, sem espaço e caracteres especias.";tput sgr0
							fi
						else
							clear;
							echo -e $RED"Somente número ou letras, sem espaço e caracteres especias.";tput sgr0
						fi
					else
						clear;
						echo -e $RED"Somente números.";tput sgr0
					fi
				else
					clear;
					echo -e $RED"Somente número ou letras, sem espaçoe e caracteres especias.";tput sgr0
				fi
			else
				clear;
				echo -e $RED"Somente número ou letras, sem espaço e caracteres especias.";tput sgr0
			fi
		done
		echo
		while [[ compara != $resp_registro ]]; do
			read -p "Salvar os Dados? (y/n): " resp_registro; #echo
			if [[ "$resp_registro" = "y" ]]; then
				echo "Salvando.."
				echo
				echo "nr = "$nome_registro >> "${database}"; #Coloca dados no db.txt, nr = nome_registro ;
				echo "sr = "$senha_registro >> "${database}"; #sr= senha_registro;
				echo "nu = "$num_registro >> "${database}"; #nu = numero do celular
				echo "pe = "$pergun >> "${database}"; #pe = pergunta de recuperação
				echo "re = "$resp >> "${database}"; #re = resposta de recuperação
				compara=$resp_registro
				break
			elif [[ "$resp_registro" = "n" ]]; then
				clear
				cadastro
			else
				clear;
				echo -e "Digite" $GREEN"y(salvar)"$OFF", "$RED"n(não salvar).";tput sgr0
			fi
		done #Fim do while
		sleep 2 
		clear
		echo -n "Tecle enter para voltar."
		read
		clear
		cd $HOME
	else
		#clear;
		echo -e $RED"Você já tem um Usuario cadastrado.";tput sgr0
		echo "Faça Login ou Recupe se esqueceu."
	fi
}
cadastro

mv $HOME/Login-Termux/login.sh /data/data/com.termux/files/home/
mv $HOME/Login-Termux/db.txt /data/data/com.termux/files/home/

echo "bash /data/data/com.termux/files/home/login.sh" >> /data/data/com.termux/files/usr/etc/zshrc
echo "bash /data/data/com.termux/files/home/login.sh" >> /data/data/com.termux/files/usr/etc/bash.bashrc

pkg install toilet -y
pkg install figlet -y
pkg install termux-api -y
