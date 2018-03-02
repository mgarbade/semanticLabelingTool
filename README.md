# semanticLabelingTool
Tool to create ground truth semantic segmentation masks using super pixels  
[Here](https://youtu.be/oycY0ZMMszI) is some demo video of the tool

Prerequisites:  
 - Download and extract [vl_feat library](http://www.vlfeat.org/) including the function to compute superpixels `vl_slic`
 - Add the all extracted folders to your Matlab path

You need the following Matlab functions:
 - regionprops
 - bwperim
