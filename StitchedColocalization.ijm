// Written by Robert Oda & Vince Soubannier & Eddie Cai


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

		run("Set Measurements...", "area centroid perimeter shape redirect=None decimal=3");
		run("Analyze Particles...", "circularity=0.00-1.00 size=500-Infinity display clear summarize add in_situ");
			selectWindow("duplicate");
			close();

		selectWindow(filename);

		run("Enhance Contrast", "saturated=0.35");
		run("Apply LUT");
		setAutoThreshold("Default dark");
		run("Threshold...");
		setThreshold(14000, 65535);
		waitForUser("Pause","Adjust threshold");
		setOption("BlackBackground", true);
		run("Convert to Mask");


		//eventually loop through and resize each 
			for (m = 0; m < roiManager("count"); m++){ 

				selectWindow(filename); 
				roiManager("Select", m);
				run("Scale... ", "x=1.2 y=1.2 centered");
				setForegroundColor(0, 0, 0);
				run("Fill", "slice");
			} 
		roiManager("reset");
		run("Select All");
		run("Watershed");
		run("Set Measurements...", "area centroid perimeter shape redirect=None decimal=3");
		run("Analyze Particles...", "circularity=0.00-1.00 size=20-Infinity display clear summarize add in_situ");
		close();

		// Adds the Regions of Interest back into the other channel and measure the area difference

		filename2 = replace(filename, "d0", "d1");
		open(input + filename2);
		run("Properties...", "channels=1 slices=1 frames=1 unit=µm pixel_width=0.4318000 pixel_height=0.4318000 voxel_depth=25400.0510000");
			run("Threshold...");
			setThreshold(200, 65535);
			waitForUser("Pause","Adjust threshold");

			if (roiManager("count") > 0) {
				roiManager("Set Line Width", 1);
				run("From ROI Manager");
			}


			selectWindow("Results");
			run("Close");
			run("Set Measurements...", "area mean centroid perimeter shape feret's area_fraction redirect=None decimal=3");
			roiManager("Measure");
			saveAs("Jpeg", output + "output_" + i + ".jpg");
					
		// Closes everything and saves the particle data file
				
			run("Close All");
			selectWindow("Results");
			saveAs("Results", output + "particle_data_" + i + ".csv");
			run("Close");


		filename3 = replace(filename, "d0", "d2");
		open(input + filename3);
		run("Properties...", "channels=1 slices=1 frames=1 unit=µm pixel_width=0.4318000 pixel_height=0.4318000 voxel_depth=25400.0510000");
			run("Threshold...");
			setThreshold(300, 65535);
			waitForUser("Pause","Adjust threshold");

			if (roiManager("count") > 0) {
				roiManager("Set Line Width", 1);							//try multimeasure
				run("From ROI Manager");
			}
			run("Set Measurements...", "area mean centroid perimeter shape feret's area_fraction redirect=None decimal=3");
			roiManager("Measure");
			saveAs("Jpeg", output + "output2_" + i + ".jpg");
					
		// Closes everything and saves the particle data file
				
			run("Close All");
			selectWindow("Results");
			saveAs("Results", output + "particle_data2_" + i + ".csv");
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
i = 0;
for (j = 0; j < list.length; j++)
{
	if (endsWith(list[j], "d0.TIF"))
	{
		action(input, output, list[j]);
		i++;
	}

}


// runs the python script

jythonText = File.openAsString(File.getParent(getInfo("macro.filepath")) + "/ColocalizationDataCompiler.py"); 
call("ij.plugin.Macro_Runner.runPython", jythonText, output); 

waitForUser("Finished!", "Analysis Complete!");
