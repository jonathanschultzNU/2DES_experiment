MDS_EXP is a software package designed to process 1D and 2D data from Phasetech's
QuickControl outputs (phasetechspectroscopy.com/products/quickcontrol/)

The main code is AnalysisHub.mlx, which is written such that the user can navigate the hub 
section-by-section (rather than running the entire code from start to finish). 

The package comes with sample 2DES data that are loaded by default in the MDS code if the 
user does not change any of the user controls. However, the location of the data and 
dataworkup directories must be updated since they are specific to the user's computer.

Disclaimer: The MDS code has checkpoints where data can be saved for reloading at a 
later time (it takes a long time to load data that hasn't been processed before). If 
the sample data are processed without any changes to the controls, the total analysis 
will take up approximately 2 GB of memory.