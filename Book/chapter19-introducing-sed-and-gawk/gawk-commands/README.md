# Gawk Command

## Its structure

    gawk options program file

## Examples

### Reading the program script from the command line
Incorrect form

    gawk '(print "Hello World!"}'

The correct form

    gawk '{print "Hello World!"}'

### Using data field variables

    cat data2.txt

    gawk '{print $1}' data2.txt

    gawk -F: '{print $1}' /etc/passwd

### Using multiple commands in the program script

    echo "My name is Rich" | gawk '{$4="Christine"; print $0}'

    echo "My name is Rich" | gawk '{
    > $4="Christine"
    > print $0}'

### Reading the program from a file

    cat script2.gawk

    gawk -F: -f script2.gawk /etc/passwd

    cat script3.gawk

    gawk -F: -f script3.gawk /etc/passwd

### Running scripts before processing data

    gawk 'BEGIN {print "Hello World!"}'

    cat data3.txt

    gawk 'BEGIN {print "The data3 File Contents:"}
    > {print $0}' data3.txt

### Running scripts after processing data

    gawk 'BEGIN {print "The data3 File Contents:"}
    > {print $0}
