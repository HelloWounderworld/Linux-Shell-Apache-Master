# Using Structured Commands
Structured commands allow you to alter the normal fl ow of shell script execution. The most basic structured command is the if-then statement. This statement provides a command evaluation and performs other commands based on the evaluated command’s output.

You can expand the if-then statement to include a set of commands the bash shell executes if the specifi ed command fails as well. The if-then-else statement executes commands only if the command being evaluated returns a non-zero exit status code.

You can also link if-then-else statements together, using the elif statement. The elif is equivalent to using an else if statement, providing for additional checking of whether the original command that was evaluated failed.

In most scripts, instead of evaluating a command, you’ll want to evaluate a condition, such as a numeric value, the contents of a string, or the status of a fi le or directory. The test command provides an easy way for you to evaluate all these conditions. If the condition evaluates to a TRUE condition, the test command produces a zero exit status code for the if-then statement. If the condition evaluates to a FALSE condition, the test command produces a non-zero exit status code for the if-then statement.

The square bracket is a special bash command that is a synonym for the test command. You can enclose a test condition in square brackets in the if-then statement to test for numeric, string, and fi le conditions.

The double parentheses command provides advanced mathematical evaluations using additional operators. The double square bracket command allows you to perform advanced string pattern-matching evaluations.

Finally, the chapter discussed the case command, which is a shorthand way of performing multiple if-then-else commands, checking the value of a single variable against a list of values.

The next chapter continues the discussion of structured commands by examining the shell looping commands. The for and while  commands let you create loops that iterate through commands for a given period of time.

## Key points:
