function semLabels = getSemanticLabels(im)



mDir = '/home/garbade/models/04_vw_dataset/';
predictSemSeg = '/home/garbade/libs/deeplab/deeplab-public-master/.build_release/tools/caffe.bin test ';
archPrototxt = [mDir '01_vw_dataset/config/01_deepLabFOV/test_val.prototxt'];
modelFile = [mDir '01_vw_dataset/model/01_deepLabFOV/train_iter_6000.caffemodel'];


% Set caffe mode
if exist('use_gpu', 'var') && use_gpu
  caffe.set_mode_gpu();
  gpu_id = 0;  % we will use the first gpu in this demo
  caffe.set_device(gpu_id);
else
  caffe.set_mode_cpu();
end


% Initialize the network using BVLC CaffeNet for image classification
% Weights (parameter) file needs to be downloaded from Model Zoo.
net_model = archPrototxt;
net_weights = modelFile;
phase = 'test'; % run with phase test (so that dropout isn't applied)
if ~exist(net_weights, 'file')
  error('Model file could not be found');
end


% Initialize a network
net = caffe.Net(net_model, net_weights, phase);

% do forward pass to get scores
% scores are now Channels x Num, where Channels == 1000
tic;
% The net forward function. It takes in a cell array of N-D arrays
% (where N == 4 here) containing data of input blob(s) and outputs a cell
% array containing data from output blob(s)
scores = net.forward(inputData);
toc;

