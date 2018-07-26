import sys
import os 
import Tkinter, tkFileDialog, tkSimpleDialog

i = 0

root = Tkinter.Tk()
directory = tkFileDialog.askdirectory(parent=root,initialdir="/",title='Please select a directory')
rename = tkSimpleDialog.askstring("example_1", "Please enter the new names")

for filename in os.listdir(directory): 
	os.rename(os.path.join(directory, filename), os.path.join(directory, rename + "_" + str(i))+ ".tif")
	i = i+1
