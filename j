#!/usr/bin/bash

file='/home/rahul/.jumps'
# file='.jumps'
jumpString=$1
temp='.jump_temp'

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
if [ "$1" == "" ];
then 
    while read -r line; 
    do 
        echo "$line"
    done < $file
    # if last line is empty, (only if empty)
    if [ "$line" != "" ];then
        echo $line
    fi

# if string is a command, ie starts with -, handle the commands
elif [[ "$1" == -* ]];
then

    # add a jumping position to saved list
    if [ "$1" == "--add" ] || [ "$1" == "-a" ]; then
        # if there is second and third string
        if [ "$#" -lt 3 ]; then 
            echo -e "Argument expected\nformat:\n\tj --add jumpString Directory"
        else
            # adding current directory using '.'
            if [ "$3" == "." ]; then
                $3=pwd
            fi

            # echo $2,$3
           echo "$2  $3" >> $file
           echo "jumpString added : $2"
        fi

    # delete a saved jumping position
    # implemented using another file to temporarily store the position
    elif [ "$1" == "--del" ] || [ "$1" == "-d" ]; then
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
        if [ "$flag" == "1" ];
        then
            echo "jump position successfully deleted"
        else
            echo "Invalid jump position"
            echo -e "format:\n\tj --del jumpString"
        fi
    fi

# adding last directory
elif [ "$1" == "." ]; then
    # if there is second string    
    # awk -v jumpString="$2" '{if($1!=jumpString){print $0;} else {flag="1";echo pritrse;} }' $file > temp && mv temp $file 
    str="-"
    while read -r line;
    do
      [[ ! $line =~ $str ]] && echo "$line"
    done < $file  > $temp
    echo "- `pwd`" >> $temp
    mv $temp $file

# string is a jumpString
else
    # find the directory of saved jumpString
    Dir=$(awk -v short="$jumpString" '{if($1==short)print $2;}' $file)
    # given string not found in saved list
    if [ "$Dir" == "" ];
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
