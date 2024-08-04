#!/bin/bash
# Test running in the background
#
# ./test4.sh &
#
# nice -n 10 ./test4.sh > test4.out &
# ps -p [PID] -o pid,ppid,ni,cmd
# nice -n -10 ./test4.sh > test4.out & # Como um usuario comum, ou seja, sem ser root
#
# nice -10 ./test4.sh > test4.out & # Voce pode ate utilizar o nice sem o "-n", mas isso poderia ficar confuso quando vc for colocar alguma priordade de numero negativo. O "-n", ela serve para evitar a confusao disso
# ps -p [PID] -o pid,ppid,ni,cmd
#
# 15 10 * * * /home/teramatsu/study/test4.sh >> /home/teramatsu/study/test4.out 2>&1
# crontab -l
# crontab -e
# ll /etc/cron.*ly
#
# cat /var/spool/anacron/cron.monthly
# ll /var/spool/anacron
# nano /etc/anacrontab
# 1       30        test4.daily         /home/leonardo/study/test4.sh >> /home/leonardo/study/test4.out 2>&1
# cat /var/log/syslog or cat /var/log/anacron | grep "anacron"
#
count=1 
while [ $count -le 10 ]; do
    sleep 1
    count=$[ $count + 1 ]
done
#