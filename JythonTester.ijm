// Written by Robert Oda & Vince Soubannier


function action(input, output, filename)
{	
}


output = File.getParent(getInfo("macro.filepath")) + "/results/"


// runs the python script

jythonText = File.openAsString(File.getParent(getInfo("macro.filepath")) + "/DapiDataCompiler.py"); 
call("ij.plugin.Macro_Runner.runPython", jythonText, output); 

waitForUser("Finished!", "Analysis Complete!");
