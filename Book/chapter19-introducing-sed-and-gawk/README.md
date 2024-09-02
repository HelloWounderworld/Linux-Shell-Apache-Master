# Introducing sed and gawk
Shell scripts can do lots of work on their own, but it’s often difficult to manipulate data with just a shell script. Linux provides two handy utilities to help with handling text data. The sed editor is a stream editor that quickly processes data on the ﬂy as it reads it. You must provide the sed editor with a list of editing commands, which it applies to the data.

The gawk program is a utility from the GNU organization that mimics and expands on the functionality of the Unix awk program. The gawk program contains a built-in programming language that you can use to write scripts to handle and process data. You can use the gawk program to extract data elements from large data files and output them in just about any format you desire. This makes processing large log files a snap, as well as creating custom reports from data files.

A crucial element of using both the sed and gawk programs is knowing how to use regular expressions. Regular expressions are key to creating customized filters for extracting and manipulating data in text files. The next chapter dives into the often misunderstood world of regular expressions, showing you how to build regular expressions for manipulating all types of data.

## Key point

### Manipulating Text

#### Getting to know the sed editor

##### Reading editor commands from a file
It can be easy to confuse your sed editor script files with your bash shell script files. To eliminate confusion, use a .sed file extension on your sed script files.

#### Getting to know the gawk program
The gawk program is not installed by default on all distributions. If your Linux distribution does not have the gawk program, install the gawk package using Chapter 9 as a guide.
