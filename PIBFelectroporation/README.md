#PIBFelectroporation

ABOUT:
PIBFelectroporation is a plugin for imageJ (FIJI) that processes a series of images (e.g. propidium iodide and brightfield image sequences) by thresholding the stained image using the built-in Yen auto-thresholding routine then overlaying it on the brightfield image and flattening then saving the images. The images are returned as 8-bit RGB images. This plugin is meant for batch-processing and will produce composite image files in a new directory called ‘processed’ within the target directory. 

AUTHOR: 
Dan Sweeney 

=========================================================================================

NECESSARY FILES:
The following files must included in the folder containing the images to be processed:
-Brightfield image where x is any character             ‘xxxxbfxxxx.tif’ 	(.tif)
-Propidium-stained image with other characters same     ‘xxxxpixxxx.tif’ 	(.tif)


INSTALLATION:
For MacOS (OSX):

1. Download and install Fiji (Fiji is just imageJ) from http://fiji.sc/Installation

2. In the ‘Applications’ directory, right-click on Fiji.app and click ‘Show Package Contents…

3. Navigate into the ‘plugins’ directory and paste the ‘Leica_NCR’ folder into it. The ‘Leica_NCR’ folder should contain 2 files: 
	- Leica_NCR.java
	- Leica_NCR.py

4. Open the Fiji application and under the ‘Plugins’ dropdown menu, click ‘Compile and Run…’

5. Navigate to ‘plugins’—>’Leica_NCR’ and highlight ‘Leica_NCR.java’ and click ‘Open’

6. A new file should be created called ‘Leica_NCR.class’ and the plugin should now be able to be run from the ‘Plugins’ dropdown menu.
