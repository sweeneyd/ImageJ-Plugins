from ij import IJ
from ij.measure import Calibration
from ij.io import OpenDialog, Opener
import os

def getImgs():
	op = OpenDialog("Choose Filepath Data...")
	filepath = op.getDirectory()
	filelist = os.listdir(filepath)
	bf_imgs = []
	pi_imgs = []
	for i in filelist:
		# Find brightfield images and append to bf_imgs
		if 'bf' in i:
			bf_imgs.append(i)
			# Find corresponding PI images
			COMS = i.split('bf')
			# Add corresponding PI images to pi_imgs IFF the corresponding name exists in the directory
			test_name = COMS[0] + 'pi' + COMS[1]
			if test_name in filelist:
				pi_imgs.append(test_name)
	return bf_imgs, pi_imgs, filepath

def getCompositeImgs():
	BF, PI, filepath = getImgs()
	for i in range(len(BF)):
		IJ.open(filepath + '/' + PI[i])
		IJ.run('Auto Threshold', 'method=Yen ignore_black white')
		IJ.open(filepath + '/' + BF[i])
		IJ.run('8-bit')
		IJ.run('Merge Channels...', 'c1=%s c4=%s create'%(PI[i], BF[i]))
		IJ.run('Flatten')
		if 'processed' not in os.listdir(filepath):
			os.mkdir(filepath + '/processed/')
		name = BF[i].split('bf')
		IJ.saveAs('Tiff', filepath + '/processed/' + name[0] + '_COMPOSITE_' + name[1])
		IJ.run('Close')
		print '[+] Processed image: %s' %(name[0] + '_COMPOSITE_' + name[1])
	return 0
	
getCompositeImgs()	
	

		
