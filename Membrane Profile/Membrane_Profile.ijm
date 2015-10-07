//Macro "Membrane Profile" An ImageJ Plugin by Suwan K Sinha
// This macro trace the contour from a selection and plots the radial intensity
// along the contour line for a user defined depth.
// This plots the radial intensity of selection over 0-360 degrees,
// integrating each user defined angular segment (5 degree default).
// Each plot y value is the sum of the pixels in one segment of the contour/selection for the defined thickness.
// This was written to plot the distribution of protein along the membrane.
//*****You must have ABsnake (for contour tracing) and Radial grid (to visualize segmentation) Plugin installed*********
//*****************Asign Key m for the keyboard shortcut*****************
macro "membrane Profile [m]"
{
 requires("1.33p");
 AB_GT=20;
 AB_iter=10;
 angleIncrement = 5; //degrees
 cortex_depth = 20; //pixel width inside the membrane
 title = getTitle();
 type = selectionType;
 discard_Img=1;
 err_msg2="A selection is required";

//*******************Generate Save file name **********************
 Fn1= getDirectory("current")+"MP-"+ substring(title, 0, (lengthOf(title)-4)) +".csv";
 File_exist_check=File.exists(Fn1);
// ************Message Box 1 to get parameters***************
 Dialog.create("Membrane profile of selection in "+title); 
 Dialog.addMessage("Membrane profile. Mesures the intensinty along outline /membrane for a particular depth");
 Dialog.addMessage("You must have the ABsnake plugin installed and have selected a region");
 Dialog.addMessage("It works with a 8 or 16 bit grey scale image. \n");
 Dialog.addMessage(" Select ABsnake parameter for selecting outline");
 Dialog.addNumber("Gradient Threshold:", AB_GT);
 Dialog.addNumber("No of Iterations:", AB_iter);
 Dialog.addMessage(" Select Cortex depth inside membrane (in pixels):");
 Dialog.addNumber("Cortex depth:",cortex_depth);

 Dialog.addNumber("Angle increment (in degrees):",angleIncrement);
 Dialog.addCheckbox("Keep my selection, do not run ABsnake", false);
 Dialog.addCheckbox("Display cortex width after contour selection", false);
 Dialog.addCheckbox("Save results in: ", true);
 Dialog.addString("",Fn1,40);
 if (File_exist_check==1)
 Dialog.addMessage("File already exist");
 Dialog.show();
 AB_GT = Dialog.getNumber();
 AB_iter = Dialog.getNumber();
 cortex_depth = Dialog.getNumber();
 angleIncrement= Dialog.getNumber();
 snake_Run= Dialog.getCheckbox();
 cortex_Menu= Dialog.getCheckbox();
 Save_result= Dialog.getCheckbox();
 Fn1=Dialog.getString();
//**********************ERROR CHECK************************
if (type<0) exit(error_msg2);
if (type>4) exit(error_msg2);
File_exist_check=File.exists(Fn1);
//**************Run ABsnake to get the contour************
 if (snake_Run==false) { 
 run("ABSnake", "gradient_threshold="+AB_GT+" number_of_iterations="+AB_iter+" step_result_show=1 draw_color=Red");
 close();
 selectWindow(title);
 }
 getSelectionBounds(a,b,width,height);
 if (width>height) length_=width;
 else length_=height;
//Cortex Menu selection: Estimate the size and cortex depth Plot.
 if (cortex_Menu==true) {
//************Drawing cortex*****************
 run("Duplicate...", "title=Cortex");
 run("Restore Selection");
 run("Enlarge...", "enlarge="+(0-cortex_depth));
 run("Make Band...", "band="+(cortex_depth));

//***********Selection of cortex width DIALOG******************
 Dialog.create("Membrane profile");
 Dialog.addMessage(" If you want to accept the Countour selection.");
 Dialog.addMessage(" Please select Cortex depth inside membrane (in pixels)");
 Dialog.addMessage(" and angle increment then press OK");
 Dialog.addMessage("Your total selection size in pixels: "+ width+" X "+height);
 Dialog.addNumber("Cortex depth:",cortex_depth);
 Dialog.addNumber("Angle increment (in degrees):",angleIncrement);
 Dialog.addMessage("\n Your current Cortex depth is shown in the image Cortex");
 Dialog.addCheckbox("Discard outline & grid image", true);
 Dialog.show();
 cortex_depth = Dialog.getNumber();
 angleIncrement= Dialog.getNumber();
 discard_Img= Dialog.getCheckbox();
 if (discard_Img==true)
 close();
 selectWindow(title);
 }
//************************CALCULATIONS************************** 
//**************Define cortex area and Radial Integrated intensity calculation.******************
 run("Duplicate...", "title=Temp");
 run("Restore Selection");
 run("Enlarge...", "enlarge="+(0-cortex_depth));
 setBackgroundColor(0,0,0);
 run("Clear");
 run("Enlarge...", "enlarge="+(cortex_depth));
 run("Clear Outside");
 sums = newArray(360/angleIncrement);
 angles = newArray(360/angleIncrement);
 for (i=0; i<angles.length; i++)
 angles[i] = i*angleIncrement;
 xcenter = width/2;
 ycenter = height/2;
 for (y=0; y<height; y++) {
 if (y%10==0) showProgress(y, height);
 for (x=0; x<width; x++) {
 value = getPixel(x, y);
 angle = atan2(height-y-ycenter-1, x-xcenter)*180/PI;
 if (angle<0) angle += 360;
 sums[floor(angle)/angleIncrement] += value;
 }
 }
//*****************OUTPUT DATA***********************
 Plot.create("Membrane Profile", "Angle", "Intensity", angles, sums);
//****SAVING DATA TO FILE****generating strings for output*******
if (Save_result==true) {
 File_exist_check=File.exists(Fn1);

 angle_str="Angle";
 sums_str=title;
 for (i=0; i<angles.length;i++) { 
 angles_S=toString(angles[i]);
 sums_S=toString(sums[i]);
 angle_str=angle_str+","+angles_S;
 sums_str=sums_str+","+sums_S;
 }
 if (File_exist_check==1)
 File.append(sums_str, Fn1);
 else {
 Fl1=File.open(Fn1);
 print(Fl1,angle_str);
 print(Fl1,sums_str);
 File.close(Fl1);
 }
}
 if (discard_Img==1) close();
 else {
 run("Radial Grid", "degrees="+angleIncrement+" red=0 green=0 blue=0"+" length="+length_+" x="+(width/2)+" y="+(height/2)+" degrees=90");
 }
}
//I acknowledge and thank to Thomas Boudier and Adam Baker for their wonderful plugins "Active contour" and "Radial Grid".
//I also thank Abhijit Bugde and Kate Phelps of UT southwestern medical center Dallas, TX, for their help. 