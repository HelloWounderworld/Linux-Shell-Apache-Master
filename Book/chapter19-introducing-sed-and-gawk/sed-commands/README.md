# Sed Commands

## Its structure

    sed options script file

## Examples:
When we use the sed command, its structure is

    s/pattern/replacement/flags

### replace just first occurrence

    echo "This is a test" | sed 's/test/big test/'

    sed 's/dog/cat/' data1.txt

### Using multiple editor commands in the command line

    sed -e 's/brown/green/; s/dog/cat/' data1.txt

or

    sed -e '
    s/brown/green/
    s/fox/elephant/
    s/dog/cat/' data1.txt

### Reading editor commands from a file

    sed -f script1.sed data1.txt

    sed 's/test/trial/' data4.txt

### Specify which occurrence of the matching pattern the sed editor should substitute new text for

    sed 's/test/trial/2' data4.txt

### Indicating that new text should be substituted for all occurrences of the existing text

    sed 's/test/trial/g' data4.txt

### Indicating that the contents of the original line should be printed

    sed -n 's/test/trial/p' data5.txt

### File, which means to write the results of the substitution to a file

    sed 's/test/trial/w test.txt' data5.txt

    cat test.txt

### Replacing characters

    sed 's/\/bin\/bash/\/bin\/csh/' /etc/passwd

    sed 's!/bin/bash!/bin/csh!' /etc/passwd

### Addressing the numericline

    sed '2s/dog/cat/' data1.txt

    sed '2,3s/dog/cat/' data1.txt

    sed '2,$s/dog/cat/' data1.txt

### Using text pattern filters

    grep teramatsu /etc/passwd

    sed '/teramatsu/s/bash/csh/' /etc/passwd

### Grouping commands

    sed '2{
    s/fox/elephant/
    s/dog/cat/
    }' data1.txt

    sed '3,${
    s/brown/green/
    s/lazy/active/
    }' data1.txt

### Deleting lines
Be careful with the delete command, because if you forget to include an addressing scheme, all the lines are deleted from the stream

    cat data1.txt
    sed 'd' data1.txt

    cat data6.txt
    sed '3d' data6.txt

    sed '2,3d' data6.txt

    sed '3,$d' data6.txt

    sed '/number 1/d' data6.txt
