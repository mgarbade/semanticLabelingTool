function [dataMat,subMatIndices] = convert3DCellArrayToMat(cellArray)
% Allocates a matrix as output container and pastes the cellArray in it
% Input format has to be [numFrames x featureDim]

numVids = size(cellArray,1);

if nargin < 2
    totalNumFrames = 0;
    
    for i = 1:numVids
        totalNumFrames = totalNumFrames + size(cellArray{i},1);
    end
end
    
    

frameCounter = 0;
dim2 = size(cellArray{1},2);
dim3 = size(cellArray{1},3);
dataMat = zeros(totalNumFrames,dim2,dim3);
% dataMat = zeros(totalNumFrames,dim2-1,dim3);
subMatIndices = zeros(numVids,2);

for i =1:numVids
    if (mod(i,1000) == 0)
        disp(num2str(i));
    end
    
    numFrames = size(cellArray{i},1);
    subMatIndices(i,:) = [frameCounter+1 numFrames];
    
    dataMat(frameCounter+1:frameCounter + numFrames,:,:) = cellArray{i};
    frameCounter = frameCounter + numFrames;
end