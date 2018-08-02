// Written by Robert Oda & Vince Soubannier


function action(input, output, filename)
{	
		open(input + filename);
		setOption("BlackBackground", true);
		run("8-bit");
		run("Properties...", "channels=1 slices=1 frames=1 unit=µm pixel_width=0.449 pixel_height=0.449 voxel_depth=25400.0510000");
	// Creates a duplicate to work on to identify clusters

	// Measures the mean and standard deviation of the value and saves the general image data to a csv

		run("Set Measurements...", "mean standard min bounding redirect=None decimal=3");
		run("Measure");
		saveAs("Measurements", output + "measure_data_" + j + ".csv");


		mean = getResult("Mean", 0);
		std = getResult("StdDev", 0);
		run("Duplicate...", "title=duplicate");
		selectWindow("duplicate");
		setAutoThreshold("Default dark");
		run("Threshold...");
		setThreshold(0.7*mean, 255);
		setOption("BlackBackground", true);
		run("Convert to Mask");

		run("Invert");

		run("Gray Morphology", "radius=5 type=circle operator=close");
		run("Fill Holes");
		run("Watershed");

		run("Set Measurements...", "area centroid perimeter shape feret's redirect=None decimal=3");
		run("Analyze Particles...", "circularity=0.00-1.00 size=30000-Infinity display clear summarize add in_situ");
			selectWindow("duplicate");
			close();

		// Adds the Regions of Interest back into the original picture and saves it in new directory


			if (roiManager("count") > 0) {
				roiManager("Set Line Width", 1);
				run("From ROI Manager");
			}


		// This macro draws the Feret diameter of the current selection.

		selectWindow("Results");
		x1 = getResult("FeretX");
		y1 = getResult("FeretY");
		length = getResult("Feret");
		degrees = getResult("FeretAngle");
		if (degrees>90) {
			degrees -= 180; 
		}
		angle = degrees*PI/180;
		x2 = x1 + cos(angle)*length;
		y2 = y1 - sin(angle)*length;
		setColor("red");
		Overlay.drawLine(x1*2.2272, y1*2.2272, x2*2.2272, y2*2.2272);
		Overlay.show();
		showStatus("angle="+degrees);

		selectWindow(filename);

			saveAs("Jpeg", output + "output_" + j + ".jpg");
					
		// Closes everything and saves the particle data file
				
			run("Close All");
			selectWindow("Results");
			saveAs("Results", output + "particle_data_" + j + ".csv");
			run("Close");
			selectWindow("Summary");
			run("Close");
			selectWindow("ROI Manager");
			run("Close");
			selectWindow("Threshold");
			run("Close");
}

input = getDirectory("Choose Input Directory");

output = File.getParent(getInfo("macro.filepath")) + "/results/"

//setBatchMode(true);
list = getFileList(input);
for (i = 0; i < list.length; i++)
{
	list2 = getFileList(input + list[i]);
	for (j = 0; j < list2.length; j++)
	{
		if ( !File.exists(output + list[i] + "/")) 
		{
			File.makeDirectory(output + list[i] + "/");
		}

		action(input + list[i] , output + list[i] + "/", list2[j]);
	}
}


// runs the python script

jythonText = File.openAsString(File.getParent(getInfo("macro.filepath")) + "/OrganoidDataCompiler.py"); 
call("ij.plugin.Macro_Runner.runPython", jythonText, output); 

waitForUser("Finished!", "Analysis Complete!");
