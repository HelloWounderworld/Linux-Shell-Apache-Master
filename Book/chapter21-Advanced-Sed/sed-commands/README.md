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

    sed 'N ; s/System.Administrator/Desktop User/' data3.txt
