# Basic Script Building
The bash shell script allows you to string commands together into a script. The most basic way to create a script is to separate multiple commands on the command line using a semicolon. The shell executes each command in order, displaying the output of each command on the monitor.

You can also create a shell script fi le, placing multiple commands in the file for the shell to execute in order. The shell script fi le must defi ne the shell used to run the script. This is done in the first line of the script fi le, using the #! symbol, followed by the full path of the shell.

Within the shell script you can reference environment variable values by using a dollar sign in front of the variable. You can also defi ne your own variables for use within the script, and assign values and even the output of a command by using the backtick character or the $() format. The variable value can be used within the script by placing a dollar sign in front of the variable name.

The bash shell allows you to redirect both the input and output of a command from the standard behavior. You can redirect the output of any command from the monitor display to a fi le by using the greater-than symbol, followed by the name of the fi le to capture the output. You can append output data to an existing fi le by using two greater-than symbols. 

The less-than symbol is used to redirect input to a command. You can redirect input from a file to a command.

The Linux pipe command (the broken bar symbol) allows you to redirect the output of a command directly to the input of another command. The Linux system runs both commands at the same time, sending the output of the fi rst command to the input of the second command without using any redirect fi les.

The bash shell provides a couple of ways for you to perform mathematical operations in your shell scripts. The expr command is a simple way to perform integer math. In the bash shell, you can also perform basic math calculations by enclosing equations in square brackets, preceded by a dollar sign. To perform fl oating-point arithmetic, you need to utilize the bc calculator command, redirecting input from inline data and storing the output in a user variable.

Finally, the chapter discussed how to use the exit status in your shell script. Every command that runs in the shell produces an exit status. The exit status is an integer value between 0 and 255 that indicates if the command completed successfully, and if not, what the reason may have been. An exit status of 0 indicates that the command completed successfully. You can use the exit  command in your shell script to declare a specific exit status upon the completion of your script.

So far in your shell scripts, things have proceeded in an orderly fashion from one command to the next. In the next chapter, you’ll see how you can use some logic fl ow control to alter which commands are executed within the script.