#----------------------------
#Login for Termux in bash
#By Z4h4rd and @kuartz
#---------------------------

#!/bin/bash

trap '' 2
database=db.txt #Banco de Dados.
array_nr=(`grep ^nr db.txt | cut -c 6- | grep .`)
array_sr=(`grep ^sr db.txt | cut -c 6- | grep .`)
array_nu=(`grep ^nu db.txt | cut -c 6- | grep .`)
array_pe=(`grep ^pe db.txt | cut -c 6- | grep .`)
array_re=(`grep ^re db.txt | cut -c 6- | grep .`)
clear

RED=`tput setaf 1`
BOLD=`tput bold`
GREEN=`tput setaf 2`
OFF="\e[m"

menu(){ #Função de opções para o usuario
	echo ".:Não vai passar daqui se não for User:." #Talves substituir por um banner
	echo "01 - Login"
	echo "02 - Recuperar user&pass"
	echo "03 - Sair"
	read -p "Digite o numero da opção: " opcao
	case $opcao in
		01|1) login ;;
		02|2) clear ; recuperar ;;
		03|3) sleep 2 ; kill -9 -1 ;;
		*) clear ; echo -e $RED"Escolha uma opção valida..";tput sgr0 ; menu ;;
	esac
}

login(){ #Função para logar no usuario
	clear
	toilet -f smblock -F metal 'Login'; #Banner com o nome 'Usuario'
	if [[ ${#array_nr[@]} -eq 1 && ${#array_sr[@]} -eq 1 ]]; then
		while [[ i != 1 ]]; do
				read -p "Username: " uname
				if [ "$uname" = `grep ^nr db.txt | cut -c 6- | grep .` ]; then
					stty -echo
					read -p "Password: " passw; echo
					stty echo
					if [ "$passw" = `grep ^sr db.txt | cut -c 6- | grep .` ]; then
						i=1
						break
					else
						clear;
						echo -e $RED"Senha errada.";tput sgr0
					fi
				else
					clear;
					echo -e $RED"Nome de usuario errado.";tput sgr0
				fi
		done
	fi
	clear;
	echo "By Z4h4rd and @kuartz"
	toilet -f smblock -F metal ${array_nr[0]}
	echo "Welcome `grep ^nr db.txt | cut -c 6- | grep .`."
	cd $HOME
}
recuperar(){
	#clear
	echo ".:Recuperação:."
	echo
	echo "01 - Pergunta de Recuperação"
	echo "02 - SMS "
	echo "03 - Menu"
	read -p "Escolha o metodo de recuperação: " metodo
	case $metodo in
		01|1) pergunta ;;
		02|2) sms ;;
		03|3) clear ; menu ;;
		*) clear ; echo -e $RED"Escolha uma opção valida..";tput sgr0 ; recuperar ;;
	esac
	menu
}
sms(){
	num=(`grep ^nu db.txt | cut -c 6- | grep .`)
	termux-sms-send -n $num "Usuário: ${array_nr[@]} ; Senha: ${array_sr[@]} ; Pergunta: ${array_pe[@]} ; Resposta: ${array_re[@]}"
	echo "Aguarde.."
	sleep 5
	echo -e $GREEN"Dados de recuperação enviada.";tput sgr0
}
pergunta(){
	pergun=(`grep ^pe db.txt | cut -c 6- | grep .`)
	count=1
	for (( i = 0; i < 3; i++ )); do
		echo $pergun"?"
		read resp
		if [ "$resp" = `grep ^re db.txt | cut -c 6- | grep .` ];then
			clear;
			echo "Seus dados são: "
			echo "------------------------------"
			echo "User    : " `grep ^nr db.txt | cut -c 6- | grep .`
			echo "Password: " `grep ^sr db.txt | cut -c 6- | grep .`
			echo "Número  : " `grep ^nu db.txt | cut -c 6- | grep .`
			echo "Pergunta: " `grep ^pe db.txt | cut -c 6- | grep .`
			echo "Resposta: " `grep ^re db.txt | cut -c 6- | grep .`
			echo "------------------------------"
			echo
			count=0
			break
		else
			clear;
			echo -e $RED"Resposta errada.";tput sgr0
		fi

	done

	if [ $count -eq 1 ]; then
		clear;
		echo -e $RED"Foram feitas várias tentativas erradas, saindo..";tput sgr0
		sleep 3
		kill -9 -1
	fi
}

menu
trap 2

#--------------------------------------------------------------------------------
#if [[ trap '' SIGCONT || trap '' trap '' SIGTSTP SIGXCPU -eq $0 ]]; then
	#count=0
	#for (( i = 0; i < 5; i++ )); do
	#	trap ''  2
	#done
#fi

#while [[ `trap SIGTSTP` -eq $0 ]]; do
#	echo "lendo algo"
#	aux=0
#	if[ $aux -eq 5 ]; then
#		trap '' 2
#	else 
#		aux=$aux + 1
#	fi
#done
