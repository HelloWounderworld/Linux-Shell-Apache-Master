# Writing Scripts for Graphical Desktops
Interactive shell scripts have a reputation for being dull and boring. You can change that by using a few different techniques and tools available on most Linux systems. First, you can create menu systems for your interactive scripts by using the case command and shell script functions.

The menu command allows you to paint a menu, using the standard echo command, and read a response from the user, using the read command. The case command then selects the appropriate shell script function based on the value entered.

The dialog program provides several prebuilt text widgets for creating Windows-like objects on a text-based terminal emulator. You can create dialog boxes for displaying text, entering text, and choosing files and dates by using the dialog program. This helps bring even more life to your shell script.

If you’re running your shell scripts in a graphical X Window environment, you can utilize even more tools in your interactive scripts. For the KDE desktop, there’s the kdialog program. This program provides simple commands to create windows widgets for all the basic windows functions. For the GNOME desktop, there are the gdialog and zenity programs. Each of these programs provides window widgets that blend into the GNOME desktop just like a real Windows application.

The next chapter dives into the subject of editing and manipulating text data files. Often the biggest use of shell scripts revolves around parsing and displaying data in text files such as log and error files. The Linux environment includes two very useful tools, sed and gawk , for working with text data in your shell scripts. The next chapter introduces you to these tools, and shows the basics of how to use them.

## Key point

### Doing Windows
The dialog package isn’t installed in all Linux distributions by default. If it’s not installed by default, because of its popularity it’s almost always included in the software repository. Check your specific Linux distribution documentation for how to load the dialog package. For the Ubuntu Linux distribution, the following is the command line command to install it:

    sudo apt-get install dialog

That package installs the dialog package plus the required libraries for your system.

### Getting Graphic

#### The KDE environment
Just because your Linux distribution uses the KDE desktop doesn’t necessarily mean it has the kdialog package installed by default. You may need to manually install it from the distribution repository.
