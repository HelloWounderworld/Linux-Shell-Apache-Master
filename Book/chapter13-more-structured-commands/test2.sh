#!/bin/bash
# basic for command
# the for variable retains the last value
for test in Alabama Alaska Arizona Arkanas California Colorado
do
    echo The next state is $test
done
echo "The last state we visited was $test"
test=Connecticut
echo "Wait, now we're visiting $test"
