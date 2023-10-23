#!/bin/bash
<<Documentation
Name:Muhammed Anas k
Date:
Description:
Sample i/p:
Sample o/p:
Documentation

main()
{
    echo -e "**********************************************************************************************************WELCOME************************************************************************"
    echo -e "1.SignUp\n2.SignIn\n3.exit"
    read -p "Enter your Option:" x

    case "$x" in
	1)
	    SignUp
	    ;;
	2)
	    SignIn
	    ;;
	3)
	    Back
	    exit
	    ;;
	*)
	    echo "INVALID OPTION , ENTER THE CORRECT OPTION"
	    main

	    ;;
    esac

}

SignUp()
{

    read -p "Enter username:" a
    userdata=(`cat username.csv`)
    flag=0
    for i in ${userdata[@]}

    do

	if [ $a = $i ]
	then
	    flag=1
	fi

    done

    if [ $flag -eq 0 ]
    then
	password
    else
	echo "USERNAME ALREADY EXIST, USE ANOTHER USERNAME"
	SignUp
    fi

}


password()
{
    echo -e "\nEnter password:"
    read -s password1
    echo -e "\nConfirm password"
    read -s password2

    if [ ${#password1} -ge 6 ]
    then

	if [ $password1 = $password2 ]
	then

	    `echo $username >> username.csv`
	    `echo $password >> password.csv`
	    
	    echo -e "\nSignup Successfull"
	    main
	else
	    echo -e "\nPassword is not watching"
	    password
	fi

    else
	echo -e "\nEnter atleast  6 characters"
	password
    fi


}

SignIn()

{
    clear 
    read -p "username:" Username
    userdata=(`cat username.csv`)
    password=(`cat password.csv`)
    length=${#userdata[@]}
    flag=0
    
    for i in `seq 0 $(($length-1))`
    do
	if [ ${userdata[$1]} = $username ]
	then
	    flag=1
	    index=$i
	fi
    done
    

    if [ $flag -eq 1 ]
    then


	signuppass()
	{

	    read -s -p "password:" Password1
	    echo

	    if [ $password1 = ${passworddata[$index]} ]
	    then

		echo -e "\nLogin Successfull"
		SignIn
	    else

		echo -e "\nIncorrect Password,Please try again"
	    fi

	    signuppass
	}

	signuppass
    else
	echo "Invlid Username and Password,Create a new account"
	SignIn
    
    fi
}

SignIn()
{

    echo -e "1.Test Start\n2.Back"
    read -p "Enter your choice:" y

    case "$y" in

	1)
	    TestStart
	    ;;
	2)
	   Back 
	   exit
	    ;;
	*)
	    echo "INVALID OPTION"
	    SignIn
	    ;;

	esac
}
    
TestStart()
{

	clear
	totalline=`wc -l qtnbank.txt |cut -d " " -f1`
	for i in `seq 5 5 $totalline`
	do

	    cat qtnbank.txt | head -$i | tail -5
	    echo

	    for i in `seq 9 -1 1`
	    do
		echo -e -n "\rEnter The Choice $i: \c"
		read -t 1 opt
		if [ $opt ]
		then
		    break
		    
		fi
	    done
	    if [ -z $opt ]
	    then
		opt='e'
		`echo "$opt" >> userans.txt`
	    else
		`echo "$opt" >> userans.txt`
	    fi
	done
	check
    }
	

    check()
{
    useranswer=(`cat userans.txt`)
    correctanswer=(`cat originalans.txt`)
    length=$((${#correctanswer[@]} - 1))
    count=0
    
    for i in `seq 0 $length`
    do

	if  [ ${useranswer[$i]} = ${correctanswer[$i]} ]
	    
	then
	    echo "correctanswer" >> result.txt
	    count=$(($count+1))

	elif [ ${useranswer[$i]} = 'e' ]
	then
	    echo "timeout" >> result.txt

	else

	    echo "Wronganswer" >> result.txt

	fi

    done
    resultdisplay

    
}

resultdisplay()

{
    clear
    totalline=`wc -l qtnbank.txt | cut -d " " -f1`
    grade=`wc -l result.txt | cut -d " " -f1`
    answer=(`cat originalans.txt`)

    num=1
    for i in `seq 5 5 $totalline`
    do
	cat qtnbank.txt | head -$i | tail -5

	echo 
	result=`sed -n "$num p" result.txt`

	if [ $result = "correctanswer" ]
	then 
	    echo -e "\e[38;5;11m$result \e[0m"
	else

	    if [ $result = "Wronganswer" ]
	    then

		echo -e "\e[38;5;166m$result"

		if [ "${answer[$(($num - 1))]}" = 'a' ]
		then
		    
		    echo -e "\e[38;5;166m `cat qtnbank.txt | head -$i | tail -4 | sed -n  '1p'` \e[0m is correctanswer\n"

		elif [ "${answer[$(($num - 1))]}" = 'b' ]
		then

		    echo -e "\e[38;5;166m `cat qtnbank.txt | head -$i | tail -4 | sed -n '2p'` \e[0m is correctanswer\n"
		
		elif [ "${answer[$(($num - 1))]}" = 'c' ]
		then 
		    echo -e "\e[38;5;166m `cat qtnbank.txt | head -$i | tail -4 | sed -n '3p'` \e[0m is correctanswer\n"

		elif [ "${answer[$(($num - 1))]}" = 'd' ]
		then

		    echo -e "\e[38;5;166m `cat qtnbank.txt | head $i | tail -4 | sed -n '4p'` \e[0m is correctanswer\n"
		fi
	    fi
	fi
	num=$(($num + 1))
    done

    echo -e "\nCORRECT ANSWER $count/$grade\n"

    `rm result.txt;rm userans.txt`

    exit
    
}

main



