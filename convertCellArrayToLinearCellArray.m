function [newCellArray] = convertCellArrayToLinearCellArray(cellArray)
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
newCellArray = cell(totalNumFrames,1);

for i =1:numVids
    if (mod(i,1000) == 0)
        disp(num2str(i));
    end
    
    numFrames = size(cellArray{i},1);
    
    for j = 1:numFrames
        frameCounter = frameCounter + 1;
        newCellArray(frameCounter,1) = cellArray{i}(j,1);
    end
        
end