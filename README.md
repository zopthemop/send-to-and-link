# What?
This is a tiny script that uses the Windows context menu entry "Send to" to enable you to right-click a folder and move it to another drive, while at the same time creating a junction (a directory symlink, or a "shortcut") so that you can still access the folder at its original location (as well as its new location).

# Why?
The primary use case is when you have a small SSD as a primary drive, and a large regular harddrive as a secondary drive. You install large applications or games on your SSD, and then migrate lesser used ones (e.g. games you aren't playing actively) to your harddrive when you run out of space. They will still be accessible at the original location because the script creates a directory junction pointing to the new location. If you start using it again, move it back to the SSD. This means you can have tons of stuff installed, while always having your actively used stuff be on your SSD.

# How do I install it?
1. If you don't have it installed already, you need to install Python 3.4 or higher. Python must also be in your %PATH%, or you need to edit the script and change "python" in the first line to the absolute path of your python.exe.
1. Open Windows Explorer and go to the special path "shell:sendto" (this resolves to something like C:/Users/YourUserName/AppData/Roaming/Microsoft/Windows/SendTo).
1. Put the .cmd file from this repository here.
1. (Optional) If you want to move folders between drives other than C: and D: (default), you need edit the script - open it, and change the PRIMARY\_DRIVE and SECONDARY\_DRIVE variables to whichever drive letters you want.

# How do I use it?
1. Right-click on a folder you want to move.
1. Open the "Send to" submenu. You should find the .cmd-script as an entry in this list.
1. Click the .cmd-script and a UAC prompt should appear that you need to accept.
1. After accepting the elevation, a command window will pop up and the copying will begin. The command window will tell you when the transfer is done, or if any errors occur.

**WARNING - USE AT YOUR OWN RISK!**

This is a tiny script I wrote for my own use, and while it does have some error handling and I've used it many times without issues in my own environment, it could always break and delete your shit. You have been warned. I accept no liability of any kind for any reason.
