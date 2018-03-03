# semanticLabelingTool
Tool to create ground truth semantic segmentation masks using super pixels  
[Here](https://youtu.be/oycY0ZMMszI) is some demo video of the tool

Prerequisites:  
 - Download and extract [vl_feat library](http://www.vlfeat.org/) including the function to compute superpixels `vl_slic`
 - Add the all extracted folders to your Matlab path

You need the following Matlab functions:
 - regionprops
 - bwperim


TODOs:
 - Replace system [call to caffe-deeplab](https://github.com/mgarbade/semanticLabelingTool/blob/43cbde95bf7fbd802e0f25f773517d2a3956cb82/getSematicLabels.m#L1-L41) by some easier-to-install NN library, eg [tensorflow-deeplab](https://github.com/DrSleep/tensorflow-deeplab-resnet)
