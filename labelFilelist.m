colors = [  0 0 0      ;...% Background     1
            128 64 128 ;...% Road           2
            128 0 0	   ;...% Building       3
            128 128 128;...% Sky            4
            128 128 0  ;...% Tree           5
            0 0 192	   ;...% Sidewalk       6
            64 0 128   ;...% Car            7
            192 192 128;...% Column_Pole    8
            192 128 128;...% SignSymbol     9   
            64 64 128  ;...% Fence          10
            64 64 0    ;...% Pedestrian     11
            0 128 192  ;...% Bicyclist      12
          ];

cd('/media/data1/datasets_sl/goPro')
modelDir = 'images_1280x720/';


filelist = getVideoNamesFromAsciiFile('filelist_1280x720.txt');
numImgs = size(filelist,1);


for i = 1:numImgs
    
    file = [modelDir filelist{i} ];
    
    % Check if labeling already exists
    
    
    im = imread(file);
    
    % Extract Superpixels --> Oversegment
    % Compute Segmentation Mask
    % Loop over centroids or over pixels inside a segment    
    regionSize = 40;
    regularizer = 5000;
    superPixels = getAllSuperpixels(im,regionSize,regularizer);
    
    
    imshow(superPixels.oversegImage)
    hold on;
    plot(superPixels.Centroid(:,1),superPixels.Centroid(:,2),'r+');
    
    %% Draw lines
    imshow(superPixels.oversegImage)
    overlay = ones(size(im,1),size(im,2));
    numLinesToDraw = 3;
    for j = 1:numLinesToDraw
        line = getline;
        inside = getSuperpixelsInPolygon(line,superPixels.Centroid);
        overlay = superPixels.overlay;
        overlayMask = paintSuperpixels(inside,overlay);


        % 
        imshow(superPixels.oversegImage)

        ind = input('Specify Color \n');
        overlay(overlayMask) = ind ;
        
        hold on
        overlay_final = ind2rgb(overlay,colors);
        overlay_final = uint8(overlay_final);
        h = imshow(overlay_final);
        alphaMask = double(overlayMask)*0.5;
        set(h,'AlphaData',alphaMask);   
        hold off
    end
    % Colorize with color map
    overlay_final = ind2rgb(overlay,colors);
end



%% Compute superpixels
regionSize = 40;
regularizer = 5000;
segments = vl_slic(single(im), regionSize, regularizer);

% Display segments
perim = true(size(im,1), size(im,2));
for k = 1 : max(segments(:))
    regionK = segments == k;
    perimK = bwperim(regionK, 8);
    perim(perimK) = false;
end

perim = uint8(cat(3,perim,perim,perim));
finalImage = im .* perim;

%% Plot overlay
overlay = zeros(size(im,1),size(im,2));
overlay(1:40,1:40,[1 2]) = 1;

imshow(finalImage);
hold on;
h = imshow(overlay);
set(h,'AlphaData',0.2);



%% Get connected components
% Get connected components
bw_normal = im2bw(im, graythresh(im));
regions = regionprops(bw_normal,'PixelIdxList','Centroid','Area','BoundingBox');

numComponents = size(regions,1);

areas = zeros(numComponents,1);
for j = 1:numComponents
    areas(j,1) = regions(j,1).Area;
end
[~,ind] = max(areas);



% Colorize the max of the regions
blankImage = false(size(im,1),size(im,2));

for j = 1:length(regions)
    if j == ind
        blankImage(regions(j).PixelIdxList) = true;
    end
end
im_new = blankImage;
BB = [regions(ind).BoundingBox(1), ...
      regions(ind).BoundingBox(2), ...
      regions(ind).BoundingBox(1)+regions(ind).BoundingBox(3), ...
      regions(ind).BoundingBox(2)+regions(ind).BoundingBox(4)];
  
  
%///////////////////////////////////////////////////////////////////////////////////
% Get regions inside polygon
% Colorize the some of the regions
blankImage = false(size(im,1),size(im,2));

for j = 1:length(regions)
    if j == isInPolygon(j)
        blankImage(regions(j).PixelIdxList) = true;
    end
end

imshow(finalImage);
h = imshow(overlay);
set(h,'AlphaData',0.2);

    
    
%% Toy Example
a = false(100,100);
imshow(a)  
disp('drawPolygon')
line = getline;


for y = 1:100
    for x = 1:100
        disp([num2str(y) ',' num2str(x)])
        if inpoly(line,x,y)
            a(y,x) = true;
        end
    end
end
imshow(a)
hold on
plot(line(:,1),line(:,2));
    
    