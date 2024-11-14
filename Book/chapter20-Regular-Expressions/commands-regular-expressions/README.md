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
The dollar sign ($) special character defines the end anchor. Add this special character after a text pattern to indicate that the line of data must end with the text pattern:

    echo "This is a good book" | sed -n '/book$/p'

    echo "This book is good" | sed -n '/book$/p'

The problem with an ending text pattern is that you must be careful what you’re looking for:

    echo "There are a lot of good books" | sed -n '/book$/p'

    echo "There are a lot of good books" | sed -n '/books$/p'

### Combining anchors

    sed -n '/^this is a test$/p' data4.txt

    sed -n '/^[[:space:]]*this is a test[[:space:]]*$/p' data4.txt

    sed '/^$/d' data5.txt

    sed '/^[[:space:]]*[[:space:]]*$/d' data5.txt

## The dot character
The dot special character is used to match any single character except a newline character. The dot character must match a character, however; if there’s no character in the place of the dot, then the pattern fails.

    sed -n '/.at/p' data6.txt

## Character classes
You can define a class of characters that would match a position in a text pattern. If one of the characters from the character class is in the data stream, it matches the pattern.

    sed -n '/[ch]at/p' data6.txt

Character classes come in handy if you’re not sure which case a character is in:

    echo "Yes" | sed -n '/[Yy]es/p'

    echo "yes" | sed -n '/[Yy]es/p'

You can use more than one character class in a single expression:

    echo "Yes" | sed -n '/[Yy][Ee][Ss]/p'

    echo "yEs" | sed -n '/[Yy][Ee][Ss]/p'

    echo "yeS" | sed -n '/[Yy][Ee][Ss]/p'

Character classes don’t have to contain just letters; you can use numbers in them as well:

    sed -n '/[0123]/p' data7.txt

You can combine character classes to check for properly formatted numbers, such as phone numbers and ZIP codes. However, when you’re trying to match a speciﬁ c format, you must be careful. Here’s an example of a ZIP code match gone wrong:

    sed -n '
    /[0123456789][0123456789][0123456789][0123456789][0123456789]/p
    ' data8.txt

If you want to ensure that you match against only five numbers, you need to delineate them somehow, either with spaces, or as in this example, by showing that they’re at the start and end of the line:

    sed -n '
    /^[[:space:]]*[0123456789][0123456789][0123456789][0123456789][0123456789][[:space:]]*$/p
    ' data8.txt

One extremely popular use for character classes is parsing words that might be misspelled, such as data entered from a user form. You can easily create regular expressions that can accept common misspellings in data:

    sed -n '
    /maint[ea]n[ae]nce/p
    /sep[ea]r[ea]te/p
    ' data9.txt

## Negating character classes
In regular expression patterns, you can also reverse the effect of a character class. Instead of looking for a character contained in the class, you can look for any character that’s not in the class. To do that, just place a caret character at the beginning of the character class range:

    sed -n '/[^ch]at/p' data6.txt

## Using ranges
You can use a range of characters within a character class by using the dash symbol. Just specify the first character in the range, a dash, and then the last character in the range. The regular expression includes any character that’s within the specified character range, according to the character set used by the Linux system (see Chapter 2).

    sed -n '/^[[:space:]]*[0-9][0-9][0-9][0-9][0-9][[:space:]]*$/p' data8.txt

That saved lots of typing! Each character class matches any digit from 0 to 9. The pattern fails if a letter is present anywhere in the data:

    echo "a8392" | sed -n '/^[[:space:]]*[0-9][0-9][0-9][0-9][0-9][[:space:]]*$/p'

    echo "1839a" | sed -n '/^[[:space:]]*[0-9][0-9][0-9][0-9][0-9][[:space:]]*$/p'

    echo "18a92" | sed -n '/^[[:space:]]*[0-9][0-9][0-9][0-9][0-9][[:space:]]*$/p'

The same technique works with letters:

    sed -n '/[c-h]at/p' data6.txt

You can also specify multiple, non-continuous ranges in a single character class:

    sed -n '/[a-ch-m]at/p' data6.txt # [a-ch-m] <=> [a-c]U[h-m], where [a-c] and [h-m] are interval.

The character class allows the ranges a through c, and h through m to appear before the at text. This range would reject any letters between d and g:

    echo "I'm getting too fat." | sed -n '/[a-ch-m]at/p'

## Special character classes

    echo "abc" | sed -n '/[[:digit:]]/p'

    echo "abc" | sed -n '/[[:alpha:]]/p'

    echo "abc123" | sed -n '/[[:digit:]]/p'

    echo "This is, a test" | sed -n '/[[:punct:]]/p'

    echo "This is a test" | sed -n '/[[:punct:]]/p'

## The asterisk
Placing an asterisk after a character signifies that the character must appear zero or more times in the text to match the pattern:

    echo "ik" | sed -n '/ie*k/p'

    echo "iek" | sed -n '/ie*k/p'

    echo "ieek" | sed -n '/ie*k/p'

    echo "ieeek" | sed -n '/ie*k/p'echo "ieeeek" | sed -n '/ie*k/p'

This pattern symbol is commonly used for handling words that have a common misspelling or variations in language spellings

    echo "I'm getting a color TV" | sed -n '/colou*r/p'

    echo "I'm getting a colour TV" | sed -n '/colou*r/p'

If you know of a word that is commonly misspelled, you can accommodate it by using the asterisk:

    echo "I ate a potatoe with my lunch." | sed -n '/potatoe*/p'

    echo "I ate a potato with my lunch." | sed -n '/potatoe*/p'

Another handy feature is combining the dot special character with the asterisk special character. This combination provides a pattern to match any number of any characters. It’s often used between two text strings that may or may not appear next to each other in the data stream:

    echo "this is a regular pattern expression" | sed -n '
    /regular.*expression/p'

The asterisk can also be applied to a character class. This allows you to specify a group or range of characters that can appear more than once in the text:

    echo "bt" | sed -n '/b[ae]*t/p'

    echo "bat" | sed -n '/b[ae]*t/p'

    echo "bet" | sed -n '/b[ae]*t/p'

    echo "btt" | sed -n '/b[ae]*t/p'

    echo "baat" | sed -n '/b[ae]*t/p'

    echo "baaeeet" | sed -n '/b[ae]*t/p'

    echo "baeeaeeat" | sed -n '/b[ae]*t/p'

    echo "baakeeet" | sed -n '/b[ae]*t/p'

    echo "btaakeeet" | sed -n '/b[ae]*t/p'

## Extended Regular Expressions

CAUTION: Remember that the regular expression engines in the sed editor and the gawk program are different. The gawk program can use most of the extended regular expression pattern symbols, and it can provide some additional filtering capabilities that the sed editor doesn’t have. However, because of this, it is often slower in processing data streams.

### The question mark
The question mark is similar to the asterisk, but with a slight twist. The question mark indicates that the preceding character can appear zero or one time, but that’s all. It doesn’t match repeating occurrences of the character:

    echo "bt" | gawk '/be?t/{print $0}'

    echo "bet" | gawk '/be?t/{print $0}'

    echo "beet" | gawk '/be?t/{print $0}'

    echo "beeet" | gawk '/be?t/{print $0}'

As with the asterisk, you can use the question mark symbol along with a character class:

    echo "bt" | gawk '/b[ae]?t/{print $0}'

    echo "bat" | gawk '/b[ae]?t/{print $0}'

    echo "bot" | gawk '/b[ae]?t/{print $0}'

    echo "bet" | gawk '/b[ae]?t/{print $0}'

    echo "baet" | gawk '/b[ae]?t/{print $0}'

    echo "beat" | gawk '/b[ae]?t/{print $0}'

    echo "beet" | gawk '/b[ae]?t/{print $0}'

### The plus sign
The plus sign indicates that the preceding character can appear one or more times, but must be present at least once. The pattern doesn’t match if the character is not present:

    echo "beeet" | gawk '/be+t/{print $0}'

    echo "beet" | gawk '/be+t/{print $0}'

    echo "bet" | gawk '/be+t/{print $0}'

    echo "bt" | gawk '/be+t/{print $0}'

The plus sign also works with character classes, the same way as the asterisk and question mark do:

    echo "bt" | gawk '/b[ae]+t/{print $0}'

    echo "bat" | gawk '/b[ae]+t/{print $0}'

    echo "bot" | gawk '/b[ae]+t/{print $0}'

    echo "bet" | gawk '/b[ae]+t/{print $0}'

    echo "beat" | gawk '/b[ae]+t/{print $0}'

    echo "beet" | gawk '/b[ae]+t/{print $0}'

    echo "beeat" | gawk '/b[ae]+t/{print $0}'

### Using braces

CAUTION: By default, the gawk program doesn’t recognize regular expression intervals. You must specify the --re-interval command line option for the gawk program to recognize regular expression intervals.

Here’s an example of using a simple interval of one value:

    echo "bt" | gawk --re-interval '/be{1}t/{print $0}'

    echo "bet" | gawk --re-interval '/be{1}t/{print $0}'

    echo "beet" | gawk --re-interval '/be{1}t/{print $0}'

Often, specifying the lower and upper limit comes in handy:

    echo "bt" | gawk --re-interval '/be{1,2}t/{print $0}'

    echo "bet" | gawk --re-interval '/be{1,2}t/{print $0}'

    echo "beet" | gawk --re-interval '/be{1,2}t/{print $0}'

    echo "beet" | gawk --re-interval '/be{2,2}t/{print $0}'

    echo "beeet" | gawk --re-interval '/be{1,2}t/{print $0}'

The interval pattern match also applies to character classes:

    echo "bt" | gawk --re-interval '/b[ae]{1,2}t/{print $0}'

    echo "bat" | gawk --re-interval '/b[ae]{1,2}t/{print $0}'

    echo "bet" | gawk --re-interval '/b[ae]{1,2}t/{print $0}'

    echo "beat" | gawk --re-interval '/b[ae]{1,2}t/{print $0}'

    echo "beet" | gawk --re-interval '/b[ae]{1,2}t/{print $0}'

    echo "beeat" | gawk --re-interval '/b[ae]{1,2}t/{print $0}'

    echo "baeet" | gawk --re-interval '/b[ae]{1,2}t/{print $0}'
    
    echo "baeaet" | gawk --re-interval '/b[ae]{1,2}t/{print $0}'

### The pipe symbol
Here’s the format for using the pipe symbol:

    expr1|expr2|...

Here’s an example of this:

    echo "The cat is asleep" | gawk '/cat|dog/{print $0}'

    echo "The dog is asleep" | gawk '/cat|dog/{print $0}'

    echo "The sheep is asleep" | gawk '/cat|dog/{print $0}'

The regular expressions on either side of the pipe symbol can use any regular expression pattern, including character classes, to define the text:

    echo "He has a hat." | gawk '/[ch]at|dog/{print $0}'

### Grouping expressions
Regular expression patterns can also be grouped by using parentheses. When you group a regular expression pattern, the group is treated like a standard character. You can apply a special character to the group just as you would to a regular character:

    echo "Sat" | gawk '/Sat(urday)?/{print $0}'

    echo "Saturday" | gawk '/Sat(urday)?/{print $0}'

It’s common to use grouping along with the pipe symbol to create groups of possible pattern matches:
