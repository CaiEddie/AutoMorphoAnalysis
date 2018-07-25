# AutoMorphoAnalysis
Several scripts to help automate data analysis

1. Mature culture morphology: An image J program to detect clusters of cells in motor neuron cultures.
a) detect clusters in phase-contrast images
B) detect clusters from dapi images in a stitched image from the center of a 24 well plate
      -single cells will also be detected and counted, this is still under construction.
c) pythonsampler - measures distances between clusters in a radius and the nearest three clusters for
defined region of reference clusters.
d) Soon to be determined - summary statistics and modeling of the data

2. Cell detection at the start of motor neuron cultures (NPCs)
a) phase contrast images from time lapse
b) measure cells shape and size, count number of cells.  
    - still working on detection accuracy
    
3. Measuring  changes to cultures over time - not started.
The idea is to detect time thresholds for different stages of differentiation. 
We can then determine if various cell lines differentiate at the same stage.
This will need at least separate detection methods -
      1. Cell detection of NPCs (see script 2)
      2. Cell detection of differentiating neurons moving in and out of clusters and changing shape and size
      3. Detection of clusters small clusters still dynamic
      4. Detection of clusters that are no longer changing (script 1 a)
      
4. Quantify how much of MN culture is really motor neurons. 
    This could be done with stitched images but the files might be too big. We can run a batch of the separate images.
    a) Colocalization of motor neuron markers with cells and clusters
            Define clusters using dapi, mask MN marker and calculate 
                    i) the area of the cluster marked
                    ii) the number of clusters marked (I think this will be all of them)
            Define single cells with a region outside dapi or just the dapi area (if the MN is nuclear)
                    i) measure number of posistive single cells
   b) python script to compile meaurments calculate percent area of MN markers in clusters
      percent of single cells with MN staining.
                    
                    
5. Organoid measurer: 
      - renamer is for these files - the images can be aquired by folder and then renamed so that
      the experimenter doesn't have to constantly type in the line name.  This would be good for all EVOS
      files.
      a) phase images of organoids - simply detect sphere and measure diameter, roundness
      b) compile data creating a dataframe that will also include the day/age of the organoid
      c) summary data - average size per day of organoid by line - variation - There are usually 12 images
      per line per batch
      
      
      
      






