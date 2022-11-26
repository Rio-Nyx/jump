#!/usr/bin/bash

file=$HOME/.jumps
temp='.jump_temp'
# file='.jumps'
jumpString=$1
dir_add=$3

# test if sourced properly
# echo "test 1"

if [[ ! -e "$file" ]]; then
    echo -n "" > $file
fi
# if [ ! pwd == "~" ]; then
#     ln -s $default $file
# fi

if [ ! -s $file ]; then
    echo "no saved jumpstring"
fi    
# if no string is given, then print all jumping positions
if [[ "$1" == "" ]];
then 
    while read -r line; 
    do 
        echo "$line"
    done < $file
    # if last line is empty, (only if empty)
    if [[ "$line" != "" ]];then
        echo $line
    fi

# if string is a command, ie starts with -, handle the commands
elif [[ "$1" == -* ]];
then

    # add a jumping position to saved list
    if [[ "$1" == "--add" ]] || [[ "$1" == "-a" ]]; then
        # if there is second and third string
        if [[ "$#" -lt 3 ]]; then 
            echo -e "Argument expected\nformat:\n\tj --add jumpString Directory"
        else
            # adding current directory using '.'
            if [[ "$dir_add" == "." ]]; then
                dir_add=`pwd`
            fi

            # echo $2,dir_add
           echo "$2  $dir_add" >> $file
           echo "jumpString added : $2"
        fi

    # delete a saved jumping position
    # implemented using another file to temporarily store the position
    elif [[ "$1" == "--del" ]] || [[ "$1" == "-d" ]]; then
        flag="0"
        # if there is second string
        if [[ ! $2 == "" ]]; then     
            # awk -v jumpString="$2" '{if($1!=jumpString){print $0;} else {flag="1";echo pritrse;} }' $file > temp && mv temp $file 
            while read -r line;
            do
              [[ ! $line =~ $2 ]] && echo "$line"
              # if jumping string is in saved list
              [[ $line =~ $2 ]] && flag="1"
            done < $file  > $temp
            mv $temp $file
        fi

        # if given deletion jumping string is in saved list
        if [[ "$flag" == "1" ]];
        then
            echo "jump position successfully deleted"
        else
            echo "Invalid jump position"
            echo -e "format:\n\tj --del jumpString"
        fi
        
    # list the contents of jump file
    elif [[ "$1" == "--list" ]] || [[ "$1" == "-l" ]];then
        while read -r line; 
        do 
            echo "$line"
        done < $file

    # list all the options
    elif [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo -e " j - a quick directory jumper program
-add/-a jumpWord directory : add a new jump word
    . for current directory
--del jumpWord             : delete existing jump word
--list/-l                  : list all jump words along with directory
--help/-h                  : show all options"
    else 
        echo -e "invalid option: $2\nj -h : to list the options"
    fi

# adding last directory
elif [[ "$1" == "." ]]; then
    # if there is second string    
    # awk -v jumpString="$2" '{if($1!=jumpString){print $0;} else {flag="1";echo pritrse;} }' $file > temp && mv temp $file 
    str=","
    while read -r line;
    do
      [[ ! $line =~ $str ]] && echo "$line"
    done < $file  > $temp
    echo ", `pwd`" >> $temp
    mv -f $temp $file

# string is a jumpString
else
    # find the directory of saved jumpString
    Dir=$(awk -v short="$jumpString" '{if($1==short)print $2;}' $file)
    # given string not found in saved list
    if [[ "$Dir" == "" ]];
    then
        echo "Invalid jumpString"
    # if given string is found
    else
        # if directory corresponding to jumpString is valid one
        if [[ -d "$Dir" ]]; then
            echo "$Dir"
            cd $Dir
        else
            echo "Invalid Directory: $Dir"
        fi
    fi
fi
