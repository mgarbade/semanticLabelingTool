function newOverlay = paintSuperpixels(inside,overlay)



% Get indices of segments
numCentroids = size(inside,1);

idx = (1:numCentroids)';
idx_sel = idx(inside);


numSel = size(idx_sel,1);
newOverlay = false(size(overlay,1),size(overlay,2));


for i = 1:numSel
    newOverlay(overlay == idx_sel(i)) = true;
end




