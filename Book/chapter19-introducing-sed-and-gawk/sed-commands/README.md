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

### Substituting flags
Its structure

    s/pattern/replacement/flags

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

### Using Address
Its structure

    [address]command

    address {
        command1
        command2
        command3
    }

Addressing the numeric line

    sed '2s/dog/cat/' data1.txt

    sed '2,3s/dog/cat/' data1.txt

    sed '2,$s/dog/cat/' data1.txt

### Using text pattern filters
Its structure

    /pattern/command

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

    cat data7.txt
    sed '/1/,/3/d' data7.txt

    sed '/1/,/5/d' data7.txt

### Inserting and appending text
Here’s the format for doing this:

    sed '[address]command\
    new line'

    echo "Test Line 2" | sed 'i\Test Line 1'

    echo "Test Line 2" | sed 'a\Test Line 1'

    echo "Test Line 2" | sed 'i\
    Test Line 1'

    sed '3i\
    This is an inserted line.' data6.txt

    sed '3a\
    This is an appended line.' data6.txt

    sed '$a\
    This is a new line of text.' data6.txt

    sed '1i\
    This is one line of new text.\
    This is another line of new text.' data6.txt

### Changing lines

    sed '3c\
    This is a changed line of text.' data6.txt

    sed '/number 3/c\
    This is a changed line of text.' data6.txt

    cat data8.txt

    sed '/number 1/c\
    This is a changed line of text.' data8.txt

    sed '2,3c\
    This is a new line of text.' data6.txt

### Transforming characters
The transform command uses the format:

    [address]y/inchars/outchars/

    sed 'y/123/789/' data8.txt

    echo "This 1 is a test of 1 try." | sed 'y/123/456/'

### Printing revisited

#### Printing lines

    echo "this is a test" | sed 'p'

    cat data6.txt
    sed -n '/number 3/p' data6.txt

    sed -n '2,3p' data6.txt

    sed -n '/3/{
    p
    s/line/test/p
    }' data6.txt

#### Printing line numbers

    cat data1.txt
    sed '=' data1.txt

    sed -n '/number 4/{
    =
    p
    }' data6.txt

#### Listing lines

    cat data9.txt
    sed -n 'l' data9.txt

    cat data10.txt
    sed -n 'l' data10.txt

### Using files with sed

#### Writing to a file
Here’s the format for the w command:

    [address]w filename

The filename can be specified as either a relative or absolute pathname.

    sed '1,2w test.txt' data6.txt
    cat test.txt

    cat data11.txt
    sed -n '/Browncoat/w Browncoats.txt' data11.txt
    cat Browncoats.txt

#### Reading data from a file
Here’s the format of the read command:

    [address]r filename

The filename parameter specifies either an absolute or relative pathname for the file that contains the data.

    cat data12.txt

    sed '3r data12.txt' data6.txt

    sed '/number 2/r data12.txt' data6.txt

    sed '$r data12.txt' data6.txt

    sed '/LIST/{
    r data11.txt
    d
    }' notice.std

### If you want that the changes occurs directly at the file you have to use "-i"

    sed -i '/^[[:space:]]*$/d' data13.txt
