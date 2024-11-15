# Advanced Sed

## Looking at Multiline Commands
The sed editor includes three special commands that you can use to process multiline text:

- N adds the next line in the data stream to create a multiline group for processing.

- D deletes a single line in a multiline group.

- P prints a single line in a multiline group.

### Navigating the next command

#### Using the single-line next command
If you write a sed script to just remove blank lines, you remove both blank lines:

    sed '/^[[:space:]]*$/d' data1.txt

    sed '/header/{n ; d}' data1.txt
