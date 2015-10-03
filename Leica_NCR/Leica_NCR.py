from ij import IJ
from ij.io import OpenDialog, Opener
import os, math, csv

UNITS = {'cm': 1e-2, 'mm': 1e-3, 'um': 1e-6}

def getUniques(dataarray):
	array = []
	[array.append(i) for i in dataarray if i not in array]
	return array

def getRadius(image):
	IJ.run('8-bit')
	Img = IJ.getImage()
	IJ.run('Invert')
	IJ.setAutoThreshold(Img, 'Default')
	IJ.run('Convert to Mask')
	# Must change units to pixels --> 10px. minimum
	IJ.run(Img, 'Analyze Particles...', 'size=10-Infinity show=[Overlay Outlines] display clear')
	rt = IJ.getTextPanel()
	data = []
	for line in range(rt.getLineCount()):
		data.append(rt.getLine(line))
	return data

def getScale(filepath):
    f = open(filepath)
    fline = f.readlines()
    f.close()
    for line in fline:
        if 'DimID="X"' in line:
        	xNoE = float(line.split('NumberOfElements=')[-1].split('"')[1])
        	xLength = float(line.split('Length=')[-1].split('"')[1])
        	if line.split('Unit=')[-2].split('"')[1] not in UNITS.keys():
        		xUnits = 1.0e-6
        	else: 
        		xUnits = UNITS[line.split('Unit=')[-2].split('"')[1]]
        	xCalLength = xLength*xUnits
        	xScale = float(xCalLength)/float(xNoE)
    return xScale

def writeData(location_w_name, data):
	f = open(location_w_name, 'wt')
	try:
		writer = csv.writer(f)
		writer.writerow([';Cyto#,CytoLabel,CytoArea,CytoMea,CytoXM,CytoYM,CytoPerim.,CytoMajor,CytoMinor,CytoAngle,CytoCirc.,CytoAR,CytoRound,CytoSolidity,Nuc#,NucLabel,NucArea,NucMea,NucXM,NucYM,NucPerim.,NucMajor,NucMinor,NucAngle,NucCirc.,NucAR,NucRound,NucSolidity,Scale,CytoRadius,NucRadius,NCR'])
		for i in data:
			writer.writerow(i[0][0].split('\t') + i[1][0].split('\t') + [str(i[2])] + [str(i[3])] + [str(i[4])] + [str(i[5])])
	finally:
		f.close()
	return True

op = OpenDialog("Choose Filepath Data...")
filepath = op.getDirectory()
filelist = os.listdir(filepath)
metadata = []
imgsdata = []
for i in filelist:
	if i.split('_')[-1] == 'Properties.xml':
		metadata.append(i)
	if i.split('.')[-1] == 'tif':
		imgsdata.append(i.split('_')[0])

imgsdata = getUniques(imgsdata)
metadata = getUniques(metadata)
data = []

for i in imgsdata:
    scale = getScale(filepath + '/' + i + '_Properties.xml')
    img00 = IJ.open(filepath + '/' + i + '_ch00.tif')
    IJ.run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
    
    img01 = IJ.open(filepath + '/' + i + '_ch01.tif')
    IJ.run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
    data01 = getRadius(img01)
    cyto_r = scale * math.sqrt(float(data01[0].split('\t')[2])/math.pi)
    
    img02 = IJ.open(filepath + '/' + i + '_ch02.tif')
    IJ.run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel");
    data02 = getRadius(img02)
    nuc_r = scale * math.sqrt(float(data02[0].split('\t')[2])/math.pi)
    
    NCR = math.sqrt(nuc_r/cyto_r)**3
    data.append([data01, data02, scale, nuc_r, cyto_r, NCR])
    IJ.run('Close')
    IJ.run('Close')
    IJ.run('Close')
    IJ.run('Close')
#IJ.saveAs('Tiff', '%s' %(newpath + i + '_overlay.tif'))
newpath = filepath +'/processed/'
os.mkdir(newpath)
writeData('%s' %(newpath + 'CellData.csv'), data)