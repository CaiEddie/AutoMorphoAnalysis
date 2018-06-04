import csv
import os.path
import math
import sys
from Tkinter import Tk
from tkFileDialog import askdirectory


def findMiddleThree( image, particles ):
	"This locates the three clusters closest to the middle of the image"
	Cx = int(image['Width']) / 2 
	Cy = int(image['Height']) / 2


	first, second, third = {}, {}, {}

	for part in particles:
		part['centerDistance'] = math.sqrt((Cx - float(part['X']))**2 + (Cy - float(part['Y'])) **2)

		if part['centerDistance'] < (first.get('centerDistance') or sys.maxsize):
			third = second 
			second = first 
			first = part 
		elif part['centerDistance'] < (second.get('centerDistance') or sys.maxsize):
			third = second 
			second = part 
		elif part['centerDistance'] < (third.get('centerDistance') or sys.maxsize):
			third = part

	return first, second, third

def calculateDistance( ref, particles ):
	"This calculates the distance between the reference cluster and all others, returning a list of distances"

	distances = []
	for part in particles:
		distance =  math.sqrt((float(ref['X']) - float(part['X']))**2 + (float(ref['Y']) - float(part['Y'])) **2) 
		distances.append(distance)

	return distances


#  Asks for the directory of the data
Tk().withdraw() 
directory = askdirectory()

i = 0

#  Loops through the csv files (with precise naming) if they exist 
while os.path.isfile(directory + "/particle_data_" + str(i) + ".csv"):

	# opens the measurement data file and adds the information to the 'image' dictionary 
	#	'Mean' 'StdDev'	'Min' 'Max'	'Witdh'	'Height'

	with open(directory + "/measure_data_" + str(i) + ".csv") as mfile:
		reader = csv.DictReader(mfile, delimiter=',')
		for index in reader:
			image = index

	# opens the particle data file and adds the information to the 'particles' dictionary table  
	#	'Area' 'X' 'Y' 'Perim.'	'Circ' 'AR'	'Round'	'Solidity'
	
	with open(directory + "/particle_data_" + str(i) + ".csv", 'rb') as pfile:
		buf = csv.DictReader(pfile, delimiter=',')

		# writing all of the particle data into dictionary list "particles"

		particles = []
		count = 0
		for row in buf:
			particles.append(row)
			count += 1

		references = findMiddleThree(image, particles)

		for ref in references:
			print(calculateDistance(ref, particles))

	i += 1



