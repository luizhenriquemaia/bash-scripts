#!/bin/bash

helpFunction()
{
    echo ""
    echo "Usage: $0 -n cpf number"
    echo -e "\t-n cpf number"
    exit 1
}

while getopts ":n:?:" opt
do
    case "$opt" in
        n ) cpf_number=$(echo "$OPTARG" | sed -e 's/[^0-9]//g');;
        ? ) helpFunction;;
    esac
done

if [ -z $cpf_number ] || [ ${#cpf_number} != 11 ];
then
    echo -e "\nError: cpf number has to be 11 characters"
    echo $cpf_number
    helpFunction
fi

sum1=0
sum2=0
for ((i=0; i<${#cpf_number}; i++)); do
    if [ "$i" -gt 9 ]; then
        break
    fi
    if [ "$i" -lt 9 ]; then
        char="${cpf_number:$i:1}"
        sum1=$(($sum1+($char*(10-$i))))
    fi
    char="${cpf_number:$i:1}"
    sum2=$(($sum2+($char*(11-$i))))
done

digit1=$(printf "%d" "${cpf_number:9:1}")
digit2=$(printf "%d" "${cpf_number:10:1}")

digit1ShouldBe=$(((($sum1*10)%11)%10))
digit2ShouldBe=$(((($sum2*10)%11)%10))
if [ $digit1 != $digit1ShouldBe ] || [ $digit2 != $digit2ShouldBe ]; then
    echo "INVALID"
    exit 0
fi
echo "VALID"