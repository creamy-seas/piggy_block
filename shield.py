#this script will change the file with the blocked domains
import sys

#1) read variables from bash
block = (sys.argv[2]=="True")
blockFile = sys.argv[1]

#2) read and replace line in file
fileIn = open(blockFile).read()
if(block):
	modifiedString = fileIn.replace("#off\n#127.0.0.1 www.", "#on\n127.0.0.1 www.")
else:
	modifiedString = fileIn.replace("#on\n127.0.0.1 www.", "#off\n#127.0.0.1 www.")

#3) write new file and close
sys.exit(modifiedString)

