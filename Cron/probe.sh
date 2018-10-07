#!/bin/bash

HOST=$1
#ip адрес хоста, кторый мы будем проверять на доступность вводится в качестве аргумента при запуске скрипта

FILE="/var/log/health_cheack.log"
#переменая с именем файла лога

D=$(date +%Y-%m-%d)
T=$(date +%H:%M)
#формат времени для записи в лог

if( ! ping -c 1 -s 1 -W 1 $HOST ); then



wall "$HOST is not availiable"
    if [ -f $FILE ]; then
    echo "$HOST is not avalilable, $D $T " >> $FILE

    fi
fi
