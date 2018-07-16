// Written by Robert Oda & Vince Soubannier


function action(input, output, filename)
{	
		open(input + filename);
		setOption("BlackBackground", true);
		run("16-bit");
		run("Properties...", "channels=1 slices=1 frames=1 unit=µm pixel_width=0.4318000 pixel_height=0.4318000 voxel_depth=25400.0510000");
	// Creates a duplicate to work on to identify clusters

	// Measures the mean and standard deviation of the value and saves the general image data to a csv

		run("Set Measurements...", "mean standard min bounding redirect=None decimal=3");
		run("Measure");
		saveAs("Measurements", output + "measure_data_" + i + ".csv");


		mean = getResult("Mean", 0);
		std = getResult("StdDev", 0);
		run("Size...", "width="+ getResult("Width")/3 + " height=" + getResult("Height")/3 + " constrain average interpolation=Bilinear");
		run("Duplicate...", "title=duplicate");
		run("Enhance Contrast", "saturated=0.35");
		run("Apply LUT");
		selectWindow("duplicate");
		setAutoThreshold("Default dark");
		run("Threshold...");
		setThreshold(20000, 65535);
		waitForUser("Pause","Adjust threshold");
		setOption("BlackBackground", true);
		run("Convert to Mask");

		run("Fill Holes");
		run("Gray Morphology", "radius=2 type=circle operator=open");
		run("Gray Morphology", "radius=3 type=circle operator=close");

		run("Set Measurements...", "area centroid perimeter shape redirect=None decimal=3");
		run("Analyze Particles...", "circularity=0.00-1.00 size=500-Infinity display clear summarize add in_situ");
			selectWindow("duplicate");
			close();

		// Adds the Regions of Interest back into the original picture and saves it in new directory


			if (roiManager("count") > 0) {
				roiManager("Set Line Width", 1);
				run("From ROI Manager");
			}
			saveAs("Jpeg", output + "output_" + i + ".jpg");
					
		// Closes everything and saves the particle data file
				
			run("Close All");
			selectWindow("Results");
			saveAs("Results", output + "particle_data_" + i + ".csv");
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
	action(input, output, list[i]);
}


// runs the python script

jythonText = File.openAsString(File.getParent(getInfo("macro.filepath")) + "/DapiDataCompiler.py"); 
call("ij.plugin.Macro_Runner.runPython", jythonText, output); 

waitForUser("Finished!", "Analysis Complete!");
