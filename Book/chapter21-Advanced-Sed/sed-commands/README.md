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
