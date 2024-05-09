# Tkinter-Tk-Colour-Chart

My Implementation of the standard Tkinter / Tk Colour chart

This is my implementation of the standard Tkinter/Tk colour chart that can be found at http://www.science.smith.edu/dftwiki/index.php/Color_Charts_for_TKinter (original version).  I created this as an example for my ***Python GUI programming with Page*** book due which was published in March 2023.

![Tk-Tkinter Colour Chart](/home/greg/.config/marktext/images/6f5a0db8c8119ef533bae422bfa2aecd0604b6f2.png)

### NEW for version 2.1

- Reads from local **rgb.txt**     

- Demonstrates the use of the PAGE **ScrolledWindow** as a **ScrolledCanvas**** widget

- Added function to calculate proper light/dark colour for text

### NEW for version 2.21

- Changed font to 9 bold

- Changed toplevel size to 1423 x 995.  Should still work on most monitors.

- Decreased number of buttons in row from 12 to 10

- Modified **scrollregion** to limit x and y size

- Reworked **rgb.txt** file to remove duplicates

- Removed old code from support file

- Added **relief**='ridge' and **borderwidth** (bd) =1 to buttons

- Found **DebianRed** in **rgb.tx**t.  ***Tkinter*** doesn't support it  so neither will **PAGE**, but added support in code to allow  the program to not throw error and to move on.  This is in anticipation of more of these in the future and/or on various other Linux versions.