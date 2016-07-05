function filelist = getVideoNamesFromAsciiFile(filename)

fileID = fopen(filename);
fData = textscan(fileID, '%s', 'Delimiter',' ', 'Headerlines', 0);
fclose(fileID);

numVids = size(fData{1},1);
filelist = cell(numVids,1);
for i = 1:numVids
    filelist{i} = fData{1}{i};
end

