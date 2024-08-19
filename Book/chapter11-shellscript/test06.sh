#!/bin/bash
logvalue=$(date +%y%m%d)
date > log.$logvalue
who >> log.$logvalue

wc < "This command to test input"

username="Leonardo"
dateToEnter=$(date)
cat << END
$dateToEnter
Hello, Wounderworld!
You, $username, are an user.
Welcome to the this world.
Feel your insignificance and proof it!
After this you will have two choice, or you go always to the other world or you keep in this world for eternity!
Which of thesse choice will be a salvation to you?
END

dpkg -l | sort > packages.$logvalue

ls -l /home | sort > users.$logvalue
