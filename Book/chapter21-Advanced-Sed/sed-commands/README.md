# Advanced Sed

## Looking at Multiline Commands
The sed editor includes three special commands that you can use to process multiline text:

- N adds the next line in the data stream to create a multiline group for processing.

- D deletes a single line in a multiline group.

- P prints a single line in a multiline group.

### Navigating the next command

#### Using the single-line next command
If you write a sed script to just remove blank lines, you remove both blank lines:

    sed '/^$/d' data1.txt # Ubuntu 20.04

    sed '/^[[:space:]]*$/d' data1.txt # Ubuntu 22.04, or probably above.

In this next example, the script looks for a unique line that contains the word "header". After the script identifies that line, the n command moves the sed editor to the next line of text, which is the empty line: (basicamente, o comando abaixo, identifica a linha que tem a palavra "header" e, em seguida, pela sigla "n", que identifica a proxima linha vazia, combinando com o "d", que deleta a tal linha vazia, faz com que identifique a linha preenchida com um texto cuja sua linha sucessora seja branco para ser removido)

    sed '/header/{n ; d}' data1.txt

#### Combining lines of text
Here’s a demonstration of how the N command operates:

    sed '/first/{ N ; s/\n/ / }' data2.txt # It works at the Ubuntu 20.04, but at the Ubuntu 22.04 not work...

This has a practical application if you’re searching for a text phrase that may be split between two lines in the data file. Here’s an example:

    sed 'N ; s/System Administrator/Desktop User/' data3.txt

But in the situation where the phrase is split between two lines, the substitution command doesn’t recognize the matching pattern.

The N command helps solve this problem:

    sed 'N ; s/System.Administrator/Desktop User/' data3.txt # Format that is explained in the book.

    sed 'N ; s/System[[:cntrl:]]*Administrator/Desktop User/' data3.txt # Format it worked.

To solve this problem, you can use two substitution commands in the sed editor script, one to match the multiline occurrence and one to match the single-line occurrence:

    sed 'N
    s/System\nAdministrator/Desktop\nUser/
    s/System Administrator/Desktop User/
    ' data3.txt # The format that was in the book.

    sed 'N
    s/System[[:cntrl:]]*Administrator/Desktop\nUser/
    s/System Administrator/Desktop User/
    ' data3.txt # The format that it worked.

There’s still one subtle problem with above script, however. The script always reads the next line of text into the pattern space before executing the sed editor commands. When it reaches the last line of text, there isn’t a next line of text to read, so the N command causes the sed editor to stop. If the matching text is on the last line in the data stream, the commands don’t catch the matching data:

    sed 'N
    s/System\nAdministrator/Desktop\nUser/
    s/System Administrator/Desktop User/
    ' data4.txt # The format that was in the book.

    sed 'N
    s/System[[:cntrl:]]*Administrator/Desktop\nUser/
    s/System Administrator/Desktop User/
    ' data4.txt # The format that it worked.

Because the System Administrator text appears in the last line in the data stream, the N command misses it, as there isn’t another line to read into the pattern space to combine. You can easily resolve this problem by moving your single-line commands before the N command and having only the multiline commands appear after the N command, like this:

    sed '
    s/System Administrator/Desktop User/
    N
    s/System\nAdministrator/Desktop\nUser/
    ' data4.txt # The format that was in the book.

    sed '
    s/System Administrator/Desktop User/
    N
    s/System[[:cntrl:]]*Administrator/Desktop\nUser/
    ' data4.txt # The format that it worked.

### Navigating the multiline delete command
If you’re working with the N command, however, you must be careful when using the single-line delete command:

    sed 'N ; /System\nAdministrator/d' data4.txt # The format that was in the book
    
    sed 'N ; /System[[:cntrl:]]*Administrator/d' data4.txt # The format that it worked

The sed editor provides the multiline delete command (D), which deletes only the first line in the pattern space. It removes all characters up to and including the newline character:

    sed 'N ; /System\nAdministrator/D' data4.txt # The format that was in the book

    sed 'N ; /System[[:cntrl:]]*Administrator/D' data4.txt # The format that it worked

Here’s an example of removing a blank line that appears before the first line in a data stream:

    sed '/^$/{N ; /header/D}' data5.txt # The format that was in the book

    sed '/^[[:space:]]*$/{N ; /header/D}' data5.txt  # The format that it worked

### Navigating the multiline print command
It prints only the first line in a multiline pattern space. This includes all characters up to the newline character in the pattern space. It is used in much the same way as the single-line p command to display text when you use the -n option to suppress output from the script.

    sed -n 'N ; /System\nAdministrator/P' data3.txt # The format that was in the book

    sed -n 'N ; /System[[:cntrl:]]*Administrator/P' data3.txt # The format that it worked

## Holding Space
The sed editor utilizes another buffer area called the hold space. You can use the hold space to temporarily hold lines of text while working on other lines in the pattern space. The five commands associated with operating with the hold space are shown below:

- h: Copies pattern space to hold space

- H: Appends pattern space to hold space

- g: Copies hold space to pattern space

- G: Appends hold space to pattern space

- x: Exchanges contents of pattern and hold spaces

These commands let you copy text from the pattern space to the hold space. This frees up the pattern space to load another string for processing.

With two buffer areas, trying to determine what line of text is in which buffer area can sometimes get confusing. Here’s a short example that demonstrates how to use the h and g commands to move data back and forth between the sed editor buffer spaces:

    sed -n '/first/ {h ; p ; n ; p ; g ; p }' data2.txt

Look at the preceding code example step by step:

1. The sed script uses a regular expression in the address to filter the line containing the word first.

1. When the line containing the word first appears, the initial command in {}, the h command, places the line in the hold space.

1. The next command, the p command, prints the contents of the pattern space, which is still the first data line.

1. The n command retrieves the next line in the data stream (This is the second data line) and places it in the pattern space.

1. The p command prints the contents of the pattern space, which is now the second data line.

1. The g command places the contents of the hold space (This is the first data line) back into the pattern space, replacing the current text.

1. The p command prints the current contents of the pattern space, which is now back to the first data line.

After explanation above, you can understand what is going to happen the following command below

    sed -n '/first/ {h ; n ; p ; g ; p }' data2.txt

## Negating a Command
The exclamation mark command (!) is used to negate a command. This means in situations where the command would normally have been activated, it isn’t. Here’s an example demonstrating this feature:

    sed -n '/header/!p' data2.txt

    sed 'N;
    s/System\nAdministrator/Desktop\nUser/
    s/System Administrator/Desktop User/
    ' data4.txt

    sed '$!N;
    s/System\nAdministrator/Desktop\nUser/
    s/System Administrator/Desktop User/
    ' data4.txt

The pattern you need to work with goes like this:

1. Place a line in the pattern space.

1. Place the line from the pattern space to the hold space.

1. Put the next line of text in the pattern space.

1. Append the hold space to the pattern space.

1. Place everything in the pattern space into the hold space.

1. Repeat Steps 3 through 5 until you’ve put all the lines in reverse order in the hold space.

1. Retrieve the lines, and print them.

When using this technique, you do not want to print lines as they are processed. This means using the -n command line option for sed. The next thing to determine is how to append the hold space text to the pattern space text. This is done by using the G command. The only problem is that you don’t want to append the hold space to the ﬁ rst line of text processed. This is easily solved by using the exclamation mark command:

    1!G

The next step is to place the new pattern space (the text line with the appended reverse lines) into the hold space. This is simple enough; just use the h command.

When you’ve got the entire data stream in the pattern space in reverse order, you just need to print the results. You know you have the entire data stream in the pattern space when you’ve reached the last line in the data stream. To print the results, just use the following command:

    $p

    cat data2.txt

    sed -n '{1!G ; h ; $p }' data2.txt

In case you’re wondering, a bash shell command can perform the function of reversing a text file. The "tac" command displays a text file in reverse order. You probably noticed the clever name of the command because it performs the reverse function of the cat command.

## Changing the Flow

### Branching
Here’s the format of the branch command:

    [address]b [label]

The "address" parameter determines which line or lines of data trigger the "branch" command. The label parameter defines the location to branch to. If the "label" parameter is not present, the "branch" command proceeds to the end of the script.

    cat data2.txt

    sed '{2,3b ; s/This is/Is this/ ; s/line./test?/}' data2.txt

Instead of going to the end of the script, you can define a label for the branch command to jump to. Labels start with a colon and can be up to seven characters in length:

    :label2

    sed '{/first/b jump1 ; s/This is the/No jump on/
    :jump1
    s/This is the/Jump here on/}' data2.txt

    echo "This, is, a, test, to, remove, commas." | sed -n '{
    :start
    s/,//1p
    b start
    }'

Each script iteration removes the ﬁ rst occurrence of a comma from the text string and prints the string. There’s one catch to this script: It never ends. This situation creates an endless loop, searching for commas until you manually stop it by sending a signal with the Ctrl+C key combination.

    echo "This, is, a, test, to, remove, commas." | sed -n '{
    :start
    s/,//1p
    /,/b start
    }'

### Testing
Similar to the branch command, the test command (t) is also used to modify the flow of the sed editor script. Instead of jumping to a label based on an address, the test command jumps to a label based on the outcome of a substitution command.

The test command uses the same format as the branch command:

    [address]t [label]

The test command provides a cheap way to perform a basic if-then statement on the text in the data stream. For example, if you don’t need to make a substitution if another substitution was made, the test command can help:

    sed '{
    s/first/matched/
    t
    s/This is the/No match on/
    }' data2.txt

Using the test command, you can clean up the loop you tried using the branch command:

    echo "This, is, a, test, to, remove, commas. " | sed -n '{
    :start
    s/,//1p
    t start
    }'

## Replacing via a Pattern
You’ve seen how to use patterns in the sed commands to replace text in the data stream. However, when using wildcard characters it’s not easy to know exactly what text will match the pattern.

    echo "The cat sleeps in his hat." | sed 's/cat/"cat"/'

But what if you use a wildcard character (.) in the pattern to match more than one word?

    echo "The cat sleeps in his hat." | sed 's/.at/".at"/g'

### Using the ampersand
This lets you manipulate whatever word matches the pattern defined:

    echo "The cat sleeps in his hat." | sed 's/.at/"&"/g'

When the pattern matches the word cat, “cat” appears in the substituted word. When it matches the word hat, “hat” appears in the substituted word.

### Replacing individual words
The ampersand symbol retrieves the entire string that matches the pattern you specify in the substitution command. Sometimes, you’ll only want to retrieve a subset of the string. You can do that, too, but it’s a little tricky.

The sed editor uses parentheses to deﬁ ne a substring component within the substitution pattern.

When you use parentheses in the substitution command, you must use the escape character to identify them as grouping characters and not normal parentheses. This is the reverse of when you escape other special characters.

    echo "The System Administrator manual" | sed '
    s/\(System\) Administrator/\1 User/'

This "substitution" command uses one set of parentheses around the word "System" identifying it as a substring component.

If you need to replace a phrase with just a single word, that’s a substring of the phrase, but that substring just happens to be using a wildcard character; using substring components is a lifesaver:

    echo "That furry cat is pretty" | sed 's/furry \(.at\)/\1/'

    echo "That furry hat is pretty" | sed 's/furry \(.at\)/\1/'

This feature can be especially helpful when you need to insert text between two or more substring components. Here’s a script that uses substring components to insert a comma in long numbers:

    echo "1234567" | sed '{
    :start
    s/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/
    t start
    }'

The script divides the matching pattern into two components:

    .*[0-9]
    [0-9]{3}

## Placing sed Commands in Scripts

### Using wrappers
Once inside the shell script, you can use normal shell variables and parameters with your sed editor scripts. Here’s an example of using the command line parameter variable as the input to a sed script:

    ./reverse.sh data2.txt

### Redirecting sed output
You can use dollar sign/parenthesis, $(), to redirect the output of your sed editor command to a variable for use later in the script. The following is an example of using the sed script to add commas to the result of a numeric computation:

    ./fact.sh 20

## Creating sed Utilities

### Spacing with double lines
To start things off, look at a simple sed script to insert a blank line between lines in a text file:

    sed 'G' data2.txt

You may have noticed that this script also adds a blank line to the last line in the data stream, producing a blank line at the end of the ﬁ le. If you want to get rid of this, you can use the negate symbol and the last line symbol to ensure that the script doesn’t add the blank line to the last line of the data stream

    sed '$!G' data2.txt

### Spacing files that may have blanks
To take double spacing one step further, what if the text file already has a few blank lines, but you want to double space all the lines? If you use the previous script, you’ll get some areas that have too many blank lines, because each existing blank line gets doubled:

    sed '$!G' data6.txt
