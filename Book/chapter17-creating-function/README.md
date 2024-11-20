# Creating Functions
Shell script functions allow you to place script code that’s repeated throughout the script in a single place. Instead of having to rewrite blocks of code, you can create a function containing the code block and then just reference the function name in your script. The bash shell jumps to the function code block whenever it sees the function name used in the script.

You can even create script functions that return values. This allows you to create functions that interact with the script, returning both numeric and character data. Script functions can return numeric data by using the exit status of the last command in the function or using the return command. The return command allows you to programmatically set the exit status of your function to a specific value based on the results of the function.

Functions can also return values using the standard echo statement. You can capture the output data using the backtick character as you would any other shell command. This enables you to return any type of data from a function, including strings and ﬂoating-point numbers.

You can use shell variables within your functions, assigning values to variables and retrieving values from existing variables. This allows you to pass any type of data both into and out of a script function from the main script program. Functions also allow you to define local variables, which are accessible only from within the function code block. Local variables allow you to create self-contained functions, which don’t interfere with any variables or processes used in the main shell script.

Functions can also call other functions, including themselves. When a function calls itself, it is called recursion. A recursive function often has a base value that is the terminal value of the function. The function continues to call itself with a decreasing parameter value until the base value is reached.

If you use lots of functions in your shell scripts, you can create library files of script functions. The library files can be included in any shell script file by using the source command, or its alias, the dot operator. This is called sourcing the library file. The shell doesn’t run the library file but makes the functions available within the shell that runs the script. You can use this same technique to create functions that you can use on the normal shell command line. You can either define functions directly on the command line or you can add them to your .bashrc file so they are available for each new shell session you start. This is a handy way to create utilities that can be used no matter what your PATH environment variable is set to.

The next chapter discusses the use of text graphics in your scripts. In this day of modern graphical interfaces, sometimes a plain text interface just doesn’t cut it. The bash shell provides some easy ways for you to incorporate simple graphics features in your scripts to help spice things up.

## Key points:

### Using functions:
If you attempt to use a function before it’s defined, you’ll get an error message.

You also need to be careful about your function names. Remember, each function name must be unique, or you’ll have a problem. If you redefine a function, the new definition overrides the original function definition, without producing any error messages:

### Returning a Value:

#### Using the return command:
If you execute any other commands before retrieving the value of the function, using the $? variable, the return value from the function is lost. Remember that the $? variable returns the exit status of the last executed command.

The second problem defines a limitation for using this return value technique. Because an exit status must be less than 256, the result of your function must produce an integer value less than 256. Any value over that returns an error value:

### Using Variables in Functions:

#### Passing parameters to a function:
As mentioned earlier in the “Returning a Value” section, the bash shell treats functions just like mini-scripts.

### Using Functions on the Command Line

#### Creating functions on the command line
Be extremely careful when creating functions on the command line. If you use a function with the same name as a built-in command or another command, the function overrides the original command.
