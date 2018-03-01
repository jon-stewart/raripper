#!/bin/bash

if [ $# -ne 2 ]
then
    echo "Usage $0 <rarfile> <wordlist>";
    exit;
fi

rarfile=$1
wordlist=$2
total=`wc -l $wordlist | awk '{print $1}'`
cnt=0

unrar l $rarfile

john --wordlist=$wordlist --rules --stdout | while read i
do
    cnt=$((cnt+1))
    echo -ne "$cnt/$total\r"
    unrar x -p$i $rarfile >/dev/null 2>/dev/null
    STATUS=$?
    if [ $STATUS -eq 0 ]; then
        echo -e "\nArchive password is: \"$i\"" 
        break
    fi
done
