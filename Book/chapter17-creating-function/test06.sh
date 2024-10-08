#!/bin/bash
# passing parameters to a function

function addem {
    # echo "Amount of randoms: $#"

    if [ $# -eq 0 ] || [ $# -gt 2 ]
    then
        echo -1
    elif [ $# -eq 1 ]
    then
        echo $[ $1 + $1 ]
    else
        echo $[ $1 + $2 ]
    fi

}

echo -n "Adding 10 and 15: "
value=$(addem 10 15)
echo $value
echo
echo -n "Let's try adding just one number: "
value=$(addem 10)
echo $value
echo
echo -n "Now trying adding no numbers: "
value=$(addem)
echo $value
echo
echo -n "Finally, try adding three numbers: "
value=$(addem 10 15 20)
echo $value
