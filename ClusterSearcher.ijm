// Written by Robert Oda & Vince Soubannier


function action(input, output, filename)
{	
		open(input + filename);
		setOption("BlackBackground", true);
		run("8-bit");

	// Creates a duplicate to work on to identify clusters

		run("Duplicate...", "title=duplicate");
		selectWindow("duplicate");

	// Measures the mean and standard deviation of the value and saves the general image data to a csv

		run("Set Measurements...", "mean standard min bounding redirect=None decimal=3");
		run("Measure");
		saveAs("Measurements", output + "measure_data_" + i + ".csv");

		mean = getResult("Mean", 0);
		std = getResult("StdDev", 0);


	// Figures out if the image is phase-light or phase-dark using the mean 

		if (mean > 155) { 		// if the image is phase-inverted or is early cells

			waitForUser("Wait", "Is this image phase-dark?");
		
			// Sets the threshold to keep only the top and bottom 15%

				setAutoThreshold("Default");
				//run("Threshold...");
				setThreshold(mean-2*std, mean+2*std, "black & white");
				run("Convert to Mask");
				run("Invert");

			// Smooths the image and fills the holes inside large shapes (values to test)

				run("Gray Morphology", "radius=3 type=circle operator=close");
				run("Fill Holes");
				run("Gray Morphology", "radius=5 type=circle operator=erode");
				run("Gray Morphology", "radius=2 type=circle operator=close");


		}	else {							// if the image is normal

			// Sets the threshold to keep only the top and bottom 15%

				setAutoThreshold("Default");
				//run("Threshold...");
				setThreshold(mean-2*std, mean+2*std, "black & white");
				run("Convert to Mask");
				run("Invert");

			// Smooths the image and fills the holes inside large shapes (values to test)

				run("Gray Morphology", "radius=3 type=circle operator=close");
				run("Fill Holes");
				run("Gray Morphology", "radius=5 type=circle operator=erode");
				run("Gray Morphology", "radius=2 type=circle operator=close");

		}

		// Finds very large shapes that are not too circular and displays it
			run("Set Measurements...", "area centroid perimeter shape redirect=None decimal=3");
			run("Analyze Particles...", "size=3000-Infinity circularity=0.00-0.70 show=Outlines display clear summarize add");
			selectWindow("duplicate");
			close();

		// Adds the Regions of Interest back into the original picture and saves it in new directory

			selectWindow(filename);
			roiManager("Set Line Width", 3);
			run("From ROI Manager");
			saveAs("Jpeg", output + "output_" + i + ".jpg");
					
		// Closes everything and saves the particle data file
				
			run("Close All");
			selectWindow("Results");
			saveAs("Results", output + "particle_data_" + i + ".csv");
			run("Close");
			selectWindow("Summary");
			run("Close");
}

input = getDirectory("Choose Input Directory");

output = File.getParent(getInfo("macro.filepath")) + "/results/"

setBatchMode(true);
list = getFileList(input);
for (i = 0; i < list.length; i++)
{
	action(input, output, list[i]);
}

setBatchMode(false);

// runs the python script

jythonText = File.openAsString(File.getParent(getInfo("macro.filepath")) + "/DataCompiler.py"); 
call("ij.plugin.Macro_Runner.runPython", jythonText, output); 

waitForUser("Finished!", "Analysis Complete!");
