# AutoMorphoAnalysis
Several scripts to help automate data analysis

1. Mature culture morphology: An image J macro to detect clusters of cells in motor neuron cultures.
      1. detect clusters in phase-contrast images (ClusterSearcher.ijm)
      2. detect clusters from dapi images in a stitched image from the center of a 24 well plate (StitchedDapiCellSearcher.ijm)
      -single cells will also be detected and counted, this is still under construction.
      3. pythonsampler - measures distances between clusters in a radius and the nearest three clusters for
defined region of reference clusters. (DataCompiler.py / DapiDataCompiler.py, automatically run from macros with jython)
      4. Soon to be determined - summary statistics and modeling of the data

2. Cell detection at the start of motor neuron cultures (NPCs)
      1. phase contrast images from time lapse
      2. measure cells shape and size, count number of cells.  
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
      1. Colocalization of motor neuron markers with cells and clusters (StitchedColocalization.ijm)
            - Define clusters using dapi, mask MN marker and calculate 
                  - the area of the cluster marked
                  - the number of clusters marked (I think this will be all of them)
            - Define single cells with a region outside dapi or just the dapi area (if the MN is nuclear)
                  - measure number of posistive single cells
      2. python script to compile meaurments calculate percent area of MN markers in clusters
      percent of single cells with MN staining. 
                    
                    
5. Organoid measurer: 
      - renamer is for these files - the images can be aquired by folder and then renamed so that
      the experimenter doesn't have to constantly type in the line name.  This would be good for all EVOS
      files. (file_renamer.py)
      1. phase images of organoids - simply detect sphere and measure diameter, roundness (OrganoidSearcher.ijm)
      2. compile data creating a dataframe that will also include the day/age of the organoid
      3. summary data - average size per day of organoid by line - variation - There are usually 12 images
      per line per batch
      
      
      
      






