function superPixels = getAllSuperpixels(im,regionSize,regularizer)

if nargin < 3
    regularizer = 5000;
end
if nargin < 2
    regionSize = 40;
end
    
segments = vl_slic(single(im), regionSize, regularizer);
segments = segments + 1;

% Display segments
counter = 0;
perim = true(size(im,1), size(im,2));
numSegments = max(segments(:));

% Containers
AllAreas = cell(numSegments,1);
AllCentroids = cell(numSegments,1);
AllPixelIdxList = cell(numSegments,1);

for k = 1:numSegments

    % Get BW image containing several segments
    regionK = (segments == k);
    perimK = bwperim(regionK, 8);
    perim(perimK) = false;

    % Get all connected components
    regions = regionprops(regionK,'PixelIdxList','Centroid','Area','BoundingBox');
    numComponents = size(regions,1);
    counter = counter + numComponents;
    
    areas = zeros(numComponents,1);
    centroids = zeros(numComponents,2);
    pixelIdxList = cell(numComponents,1);
    for j = 1:numComponents
        areas(j,1) = regions(j,1).Area;
        centroids(j,:) = regions(j,1).Centroid;
        pixelIdxList{j,1} = regions(j,1).PixelIdxList;
    end


    AllAreas{k,1} = areas;
    AllCentroids{k,1} = centroids;
    AllPixelIdxList{k,1} = pixelIdxList;
end

% Compute SuperpixelImage
perim = uint8(cat(3,perim,perim,perim));
oversegImage = im .* perim;

% Concatenate all super pixels
[superPixels.Areas,~] = convert3DCellArrayToMat(AllAreas);
[superPixels.Centroid,~] = convert3DCellArrayToMat(AllCentroids);
superPixels.PixelIdxList = convertCellArrayToLinearCellArray(AllPixelIdxList);
superPixels.perim = perim;
superPixels.oversegImage = oversegImage;


% Create Overlay with indices
numSuperPixels = counter;
superPixelImg = zeros(size(im,1),size(im,2));
for i = 1:numSuperPixels
    pixelList = superPixels.PixelIdxList{i};
    
    superPixelImg(pixelList) = i;
end

    
superPixels.superPixelImg = superPixelImg;
superPixels.labelImg = zeros(size(im,1),size(im,2));











