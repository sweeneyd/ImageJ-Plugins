#Leica_NCR ==============================================================================

ABOUT:
Leica_NCR is a plugin for imageJ (FIJI) that processes a series of Leica image files contained within a directory to estimate the nucleus-to-cytoplasm ration (NCR). Cell images in each channel are first binned by similar filename (Imagexxx_ch00.tif, Imagexxx_ch01.tif, Imagexxx_ch02.tif) and within each group, binary thresholds are calculated for each image and the area of the binary region of interest is calculated. The square-root of this area is then used to estimate the effective radius of binary region. This plugin is meant for batch-processing and will produce a .csv file summarizing the results (‘CellData.csv’)in a new directory called ‘processed’ within the target directory as well as binary overlays of the nucleus and cytoplasm bounding areas calculated by for each cell.

AUTHOR:
Dan Sweeney 
PhD Candidate
Virginia Tech BEAM 
BEMS Lab (Spring 2015)

=========================================================================================

NECESSARY FILES:
The following files must included in the folder containing the images to be processed:
-Bright field image called 	‘Imagexxx_ch00.tif’ 		(.tif)
-Cytoplasm-stain image called 	‘Imagexxx_ch01.tif’ 		(.tif)
-Nucleus-stain image called 	‘Imagexxx_ch02.tif’ 		(.tif)
-Properties file called		‘Imagexxx_Propterties.xml’ 	(.xml)


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
