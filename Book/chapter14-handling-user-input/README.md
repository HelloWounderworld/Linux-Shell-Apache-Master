# Handling User Input
This chapter showed three methods for retrieving data from the script user. Command line parameters allow users to enter data directly on the command line when they run the script. The script uses positional parameters to retrieve the command line parameters and assign them to variables.

## Passing parameters
The shift command allows you to manipulate the command line parameters by rotating them within the positional parameters. This command allows you to easily iterate through the parameters without knowing how many parameters are available.

## Tracking parameters
You can use three special variables when working with command line parameters. The shell sets the $# variable to the number of parameters entered on the command line. The $* variable contains all the parameters as a single string, and the $@ variable contains all the parameters as separate words. These variables come in handy when you’re trying to process long parameter lists.

## Being shifty

## Working with options

## Standardizing options

## Getting user input

The bash shell provides three ways to handle command line options.

The first way is to handle them just like command line parameters. You can iterate through the options using the positional parameter variables, processing each option as it appears 
on the command line.

Another way to handle command line options is with the getopt command. This command converts command line options and parameters into a standard format that you can process in your script. The getopt command allows you to specify which letters it recognizes as options and which options require an additional parameter value. The getopt command processes the standard command line parameters and outputs the options and parameters in the proper order.

The final method for handling command line options is via the getopts command (note that it’s plural). The getopts command provides more advanced processing of the command line parameters. It allows for multi-value parameters, along with identifying options not defi ned by the script.

An interactive method to obtain data from your script users is the read command. The read command allows your scripts to query users for information and wait. The read command places any data entered by the script user into one or more variables, which you can use within the script.

Several options are available for the read  command that allow you to customize the data input into your script, such as using hidden data entry, applying timed data entry, and requesting a specific number of input characters.

In the next chapter, we look further into how bash shell scripts output data. So far, you’ve seen how to display data on the monitor and redirect it to a fi le. Next, we explore a few other options that you have available not only to direct data to specifi c locations but also to direct specifi c types of data to specifi c locations. This will help make your shell scripts look professional!