#!/bin/bash
FILE_LIST="./server_list"
TMP_LIST="/tmp/server_list"
PORT="22"

cat /dev/null > $TMP_LIST

if [ -f $FILE_LIST ] 
    then 
        cat $FILE_LIST | xargs -I {} bash -c "nc -zw 1 {} $PORT 2&>1 > /dev/null && echo {} > $TMP_LIST" 
    else 
    echo "$FILE_LIST is not exist" 
fi 

if [ $(wc -l $TMP_LIST | awk '{print $1}') -ge 2  ]; 
then 
    case $1 in 
        cpu) 
            cat $TMP_LIST | xargs -I {} bash -c 'echo {} && ssh sko@{} 'bash' < ./cpu.sh' 
        ;;
        mem)
            cat $TMP_LIST | xargs -I {} bash -c 'echo {} && ssh sko@{} 'bash' < ./memory.sh' 
        ;;
        *) 
            echo "Wrong input, use mem or cpu"
        ;;
    esac

elif
 [ $(wc -l $TMP_LIST | awk '{print $1}') -eq 1  ]; then 
    case $1 in 
    cpu) 
    cat $TMP_LIST | xargs -I {} bash -c 'echo {} && ssh sko@{} 'bash' < ./cpu.sh' 
    ;;
    mem)
    cat $TMP_LIST | xargs -I {} bash -c 'echo {} && ssh sko@{} 'bash' < ./memory.sh' 
    ;;
    *) echo "Wrong input, use mem or cpu"
    ;;
    esac

else
echo "No valid hosts"
fi