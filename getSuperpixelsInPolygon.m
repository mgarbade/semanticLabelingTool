function inside = getSuperpixelsInPolygon(line,centroids)




% Loop through all centroids
numCentroids = size(centroids,1);
inside = false(numCentroids,1);

% Check if centroid is inside polygon 
for i = 1:numCentroids
    inside(i) = inpoly(line,centroids(i,1) ,centroids(i,2));
end

