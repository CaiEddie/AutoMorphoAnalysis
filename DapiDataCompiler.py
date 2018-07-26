import csv
import os.path
import math
import sys

def findMiddleThree( image, particles ):
	"This locates the three clusters closest to the middle of the image"
	Cx = float(image['Width']) / 2 
	Cy = float(image['Height']) / 2


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

def circleCrop(image, particles, maxi ):
	Cx = float(image['Width']) / 2 
	Cy = float(image['Height']) / 2

	clusters = []

	for part in particles:
		part['centerDistance'] = math.sqrt((Cx - float(part['X']))**2 + (Cy - float(part['Y'])) **2)
		if part['centerDistance'] < maxi:
			clusters.append(part)
	return clusters


def findCroppedClusters( image, particles, width, height):
	"This locates all the clusters in a box cropped by width and height"

	clusters = []

	for part in particles:
		if (float(part['X']) > width and float(part['X']) < float(image['Width']) - width):
			if (float(part['Y']) > height and float(part['Y']) < float(image['Height']) - height):
				clusters.append(part)

	return clusters

def findSizeThreshold ( image, particles, mini, maxi):
	"This locates all the clusters under a certain size"

	clusters = [] 
	for part in particles:
		if float(part['Area']) > mini and float(part['Area']) < maxi: 
			clusters.append(part)
	return clusters

def threeClosest( ref, particles):
	"This calculates the distance between the reference cluster and the three closest ones, returning a list of distances"

	distances = []
	first = sys.maxsize
	second = sys.maxsize
	third = sys.maxsize
	for part in particles:
		if part != ref: 
			distance =  math.sqrt((float(ref['X']) - float(part['X']))**2 + (float(ref['Y']) - float(part['Y'])) **2) 
			if distances != 0:
				if distance < first:
					third = second
					second = first 
					first = distance
				elif distance < second:
					third = second
					second = distance 
				elif distance < third:
					third = distance 

	distances = [first, second, third]
	return distances

def calculateDistance( ref, particles, maxi):
	"This calculates the distance between the reference cluster and all others, returning a list of distances"

	distances = []
	for part in particles:
		if part != ref: 
			distance =  math.sqrt((float(ref['X']) - float(part['X']))**2 + (float(ref['Y']) - float(part['Y'])) **2) 
			if distance < maxi and distance != 0:
				distances.append(distance)

	return distances


#  Takes the directory from the macro 
directory = getArgument()
f = open(directory + "output.csv", 'w')
f.close()
i = 0
j = 0

#  Loops through the csv files (with precise naming) if they exist 

while os.path.isdir(directory):
	di = directory 
	while os.path.isfile(di+ "/particle_data_" + str(j) + ".csv"):


		# opens the measurement data file and adds the information to the 'image' dictionary 
		#	'Mean' 'StdDev'	'Min' 'Max'	'Witdh'	'Height'

		with open(di + "/measure_data_" + str(j) + ".csv") as mfile:
			reader = csv.DictReader(mfile, delimiter=',')
			for index in reader:
				image = index

#		os.remove(di+ "/measure_data_" + str(j) + ".csv")
		# opens the particle data file and adds the information to the 'particles' dictionary table  
		#	'Area' 'X' 'Y' 'Perim.'	'Circ' 'AR'	'Round'	'Solidity'
		
		with open(di + "/particle_data_" + str(j) + ".csv", 'rb') as pfile:
			buf = csv.DictReader(pfile, delimiter=',')

			# writing all of the particle data into dictionary list "particles"

			particles = []
			count = 0
			for row in buf:
				particles.append(row)
				count += 1

			for item in particles:
				item['Image'] = j
				item['Cell Line'] = chr(ord('A')+i)


			# marks the clusters that are near the edge

			edgeClusters = findCroppedClusters(image, particles, 50, 50)
			for item in edgeClusters:
				item['Include'] = True

			nuclei = findSizeThreshold(image, edgeClusters, 500, 150000)
			for item in nuclei:
				item['Cluster'] = True

			middleCLusters = circleCrop(image, nuclei, 0.35*float(image['Width']))
			for ref in middleCLusters:
				if ref:
					distances = calculateDistance(ref, nuclei, 300)
					if len(distances) > 0:
						ref['Distances'] = distances 
						ref['Average Distance'] = sum(distances) / len(distances)
						ref['# of other clusters in radius'] = len(distances)
					distances = threeClosest(ref, nuclei)
					if len(distances) > 0:
						ref['Distances (3 closest)'] = distances
						ref['Average Distance (3 closest)'] = sum(distances) / len(distances)

#		os.remove(di+ "/particle_data_" + str(j) + ".csv")

		with open(directory + "/output.csv", 'a') as csvfile:
			
			fieldnames = ['', 'Cell Line', 'Image', 'Area', 'X', 'Y', 'Solidity', 'Circ.', 'Round', 'Perim.', 'Include', 'Cluster','# of other clusters in radius', 'Distances', 'Average Distance', 'Distances (3 closest)', 'Average Distance (3 closest)']
			writer = csv.DictWriter(csvfile, fieldnames=fieldnames, extrasaction='ignore', lineterminator = '\n')
			if os.path.getsize(di + "/output.csv") < 1:
				writer.writeheader()
			for item in particles:
				writer.writerow(item)

		j += 1
