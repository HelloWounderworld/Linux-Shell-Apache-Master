# Defnition about Regular Expression
A regular expression is a pattern template you define that a Linux utility uses to filter text. A Linux utility (such as the sed editor or the gawk program) matches the regular expression pattern against data as that data flows into the utility. If the data matches the pattern, it’s accepted for processing. If the data doesn’t match the pattern, it’s rejected.

## Types of regular expressions
The asterisk wildcard character allows you to list only ﬁ les that match a certain criteria. For example:

    ls -al da*

    ll da*

## Defining BRE Patterns

### Plain text
Reviewing some sed text editor and gawk program commands:

    echo "This is a test" | sed -n '/test/p'

    echo "This is a test" | sed -n '/trial/p'

    echo "This is a test" | gawk '/test/{print $0}'

    echo "This is a test" | gawk '/trial/{print $0}'

The first rule to remember is that regular expression patterns are case sensitive:

    echo "This is a test" | sed -n '/this/p'

    echo "This is a test" | sed -n '/This/p'

If the defined text appears anywhere in the data stream, the regular expression matches the following:

    echo "The books are expensive" | sed -n '/book/p'

Of course, if you try the opposite, the regular expression fails:

    echo "The book is expensive" | sed -n '/books/p'

You also don’t have to limit yourself to single text words in the regular expression

    echo "This is line number 1" | sed -n '/ber 1/p'

Spaces are treated just like any other character in the regular expression:

    echo "This is line number1" | sed -n '/ber 1/p'

You can even create a regular expression pattern that matches multiple contiguous spaces:

    sed -n '/  /p' data1.txt

## Special characters
These special characters are recognized by regular expressions:

    .*[]^${}\+?|()

For example, if you want to search for a dollar sign in your text, just precede it with a backslash character:

    sed -n '/\$/p' data2.txt

    echo "\ is a special character" | sed -n '/\\/p'

    echo "3 / 2" | sed -n '///p' # You will get an error

    echo "3 / 2" | sed -n '/\//p'

## Anchor characters

### Starting at the beginning
To use the caret character, you must place it before the pattern specified in the regular expression:

    echo "The book store" | sed -n '/^book/p'

    echo "Books are great" | sed -n '/^Book/p'

The caret anchor character checks for the pattern at the beginning of each new line of data, as determined by the newline character:

    sed -n '/^this/p' data3.txt

If you position the caret character in any place other than at the beginning of the pattern, it acts like a normal character and not as a special character:

    echo "This ^ is a test" | sed -n '/s ^/p'

TIP: If you need to specify a regular expression pattern using only the caret character, you don’t need to escape it with a backslash. However, if you specify the caret character first, followed by additional text in the pattern, you need to use the escape character before the caret character.

### Looking for the ending

