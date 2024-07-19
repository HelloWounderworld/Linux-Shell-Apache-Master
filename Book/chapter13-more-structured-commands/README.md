# More Structured Commands
Looping is an integral part of programming. The bash shell provides three looping commands that you can use in your scripts.

## Looping with the for statement and Iterating with the until statement
The for command allows you to iterate through a list of values, either supplied within the command line, contained in a variable, or obtained by using file globbing, to extract file and directory names from a wildcard character.

## Using the while statement
The while command provides a method to loop based on the condition of a command, using either ordinary commands or the test command, which allows you to test conditions of variables. As long as the command (or condition) produces a zero exit status, the while loop continues to iterate through the specifi ed set of commands.

## Combining loops
The until command also provides a method to iterate through commands, but it bases its iterations on a command (or condition) producing a non-zero exit status. This feature allows you to set a condition that must be met before the iteration stops.

You can combine loops in shell scripts, producing multiple layers of loops. The bash shell provides the continue and break commands, which allow you to alter the flow of the normal loop process based on different values within the loop.

## Redirecting loop output
The bash shell also allows you to use standard command redirection and piping to alter the output of a loop. You can use redirection to redirect the output of a loop to a fi le or piping to redirect the output of a loop to another command. This provides a wealth of features with which you can control your shell script execution.

## Finally
The next chapter discusses how to interact with your shell script user. Often, shell scripts aren’t completely self-contained. They require some sort of external data that must be supplied at the time you run them. The next chapter discusses different methods with which you can provide real-time data to your shell scripts for processing. 

### Reading a directory using wildcards (parei aqui!!!)