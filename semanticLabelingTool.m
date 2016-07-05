function varargout = semanticLabelingTool(varargin)
% SEMANTICLABELINGTOOL MATLAB code for semanticLabelingTool.fig
%      SEMANTICLABELINGTOOL, by itself, creates a new SEMANTICLABELINGTOOL or raises the existing
%      singleton*.
%
%      H = SEMANTICLABELINGTOOL returns the handle to a new SEMANTICLABELINGTOOL or the handle to
%      the existing singleton*.
%
%      SEMANTICLABELINGTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEMANTICLABELINGTOOL.M with the given input arguments.
%
%      SEMANTICLABELINGTOOL('Property','Value',...) creates a new SEMANTICLABELINGTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before semanticLabelingTool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to semanticLabelingTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help semanticLabelingTool

% Last Modified by GUIDE v2.5 20-Jun-2016 17:15:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @semanticLabelingTool_OpeningFcn, ...
                   'gui_OutputFcn',  @semanticLabelingTool_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before semanticLabelingTool is made visible.
function semanticLabelingTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to semanticLabelingTool (see VARARGIN)
clc;

% Choose default command line output for semanticLabelingTool
handles.output = hObject;

% handles.filelistFile = '/home/garbade/datasets/goPro/filelist_1280x720.txt';
% handles.annoDir = '/home/garbade/datasets/goPro/annotations';
% handles.imgDir = '/home/garbade/datasets/goPro/images_1280x720';
handles.filelistFile = '/home/garbade/datasets/roemerstrasse/filelist.txt';
handles.annoDir = '/home/garbade/datasets/roemerstrasse/annotations';
handles.imgDir = '/home/garbade/datasets/roemerstrasse/images';
handles.imgName = '';
handles.imgId = '';
handles.img = [];
handles.imgIdx = [];
handles.filelist = [];
handles.numImgs = [];
handles.regionSize = get(handles.sliderRegionSize,'Value');
handles.regularizer = get(handles.sliderRegularizer,'Value');
handles.superPixels = [];
handles.readyToLabel = false;
handles.isSaved = false;
handles.myCanvas = [];

% handles.colors = [  255 255 255;...% Background     
%                     128 64 128 ;...% Road           
%                     128 0 0	   ;...% Building       
%                     0 0 192	   ;...% Sidewalk       
%                     64 0 128   ;...% Car            
%                     192 192 128;...% Column_Pole    
%                     192 128 128;...% Sign_Symbol       
%                     64 64 128  ;...% Fence          
%                     64 64 0    ;...% Pedestrian     
%                     0  128  192;...% Bicyclist      
%                     0    0    0;...% Water          
%                     255  0  255;...% Cliff          
%                     128 128 128;...% Sky            
%                     128 128 0  ;...% Tree                               
%                   ];
% handles.colorNames = {  'Background', ...
%                         'Road', ...
%                         'Building', ...
%                         'Sidewalk', ...
%                         'Car', ...
%                         'Column_Pole', ...
%                         'Sign_Symbol', ...
%                         'Fence', ...
%                         'Pedestrian', ...
%                         'Bicyclist',...
%                         'Water',...
%                         'Cliff',...
%                         'Sky', ...
%                         'Tree'};
if ~exist('colormap.mat')
    error('Please create a colormap file in the current folder')
end

colMap = load('colormap.mat');
handles.colorNames = colMap.colorNames;
handles.colors= colMap.colors;

set(handles.etRegionSize,'String',num2str(get(handles.sliderRegionSize,'Value')));
set(handles.etRegularizer,'String',num2str(get(handles.sliderRegularizer,'Value')));

% Get current selected label
indName = get(get(handles.Labels ,'SelectedObject'),'String'); 
ind = find(ismember(handles.colorNames,indName)); % Get ind corresponding to color / label
handles.selectedLabel = ind;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes semanticLabelingTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = semanticLabelingTool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnPrevious.
function btnPrevious_Callback(hObject, eventdata, handles)
% Load previous img
imgIdx = handles.imgIdx;
if imgIdx > 1
   
    imgIdx = imgIdx - 1;
    updateImg(imgIdx,hObject,handles)
    
end



% --- Executes on button press in btnNext.
function btnNext_Callback(hObject, eventdata, handles)
% Next image
imgIdx = handles.imgIdx;
if imgIdx < handles.numImgs
   
    imgIdx = imgIdx + 1;

    updateImg(imgIdx,hObject,handles)
    
end


% --- Executes on button press in btnLoadAnnotation.
function btnLoadAnnotation_Callback(hObject, eventdata, handles)
% Check if Annotation exists
% If yes load it
% Else compute superPixels and save them
% Store superPixels along with Annotations

updateImg(handles.imgIdx,hObject,handles)


% --- Executes on slider movement.
function sliderRegionSize_Callback(hObject, eventdata, handles)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderRegionSizeValue = get(hObject,'Value');
set(handles.etRegionSize,'String',num2str(sliderRegionSizeValue));
handles.regionSize = sliderRegionSizeValue;
guidata(hObject, handles); 


% --- Executes during object creation, after setting all properties.
function sliderRegionSize_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderRegularizer_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderRegularizerValue = get(hObject,'Value');
set(handles.etRegularizer,'String',num2str(sliderRegularizerValue));
handles.regularizer = sliderRegularizerValue;
guidata(hObject, handles); 


% --- Executes during object creation, after setting all properties.
function sliderRegularizer_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in btnSaveAnnotation.
function btnSaveAnnotation_Callback(hObject, eventdata, handles)
anno = handles.superPixels;
save([handles.annoDir '/'  handles.imgId '.mat'], 'anno' );


% --- Executes on button press in btnCompute.
function btnCompute_Callback(hObject, eventdata, handles)



function etImagePath_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of etImagePath as text
%        str2double(get(hObject,'String')) returns contents of etImagePath as a double



% --- Executes during object creation, after setting all properties.
function etImagePath_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function etAnnotationsPath_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of etAnnotationsPath as text
%        str2double(get(hObject,'String')) returns contents of etAnnotationsPath as a double


% --- Executes during object creation, after setting all properties.
function etAnnotationsPath_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in btnImgPath.
function btnImgPath_Callback(hObject, eventdata, handles)
handles.imgDir = uigetdir;
set(handles.etImagePath,'String',handles.imgDir);



% --- Executes on button press in btnAnnPath.
function btnAnnPath_Callback(hObject, eventdata, handles)
handles.annoDir = uigetdir;
set(handles.etAnnotationsPath,'String',handles.annoDir);


% --- Executes on button press in btnLoadDatabase.
function btnLoadDatabase_Callback(hObject, eventdata, handles)
if (exist(handles.filelistFile,'file') && exist(handles.annoDir,'dir') && exist(handles.imgDir,'dir'))
    disp('All files exist --> Load imagelist.')
    set(handles.stStatusDatabase,'String','Loading successful');
    filelist = getVideoNamesFromAsciiFile(handles.filelistFile);
    handles.filelist = filelist;
    handles.numImgs = size(filelist,1);
    handles.imgIdx = 1;
    
    updateImg(handles.imgIdx,hObject,handles)
    
    set(handles.TableFilelist,'Data',filelist);
    set(handles.TableFilelist,'ColumnWidth',{200});
else
    set(handles.stStatusDatabase,'String','Could not load database');
end



function etFilelist_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of etFilelist as text
%        str2double(get(hObject,'String')) returns contents of etFilelist as a double


% --- Executes during object creation, after setting all properties.
function etFilelist_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnLoadImgFilelist.
function btnLoadImgFilelist_Callback(hObject, eventdata, handles)
filelistFile = uigetfile;
set(handles.etFilelist,'String',filelistFile);
handles.filelistFile = filelistFile;



% --- Executes when selected cell(s) is changed in TableFilelist.
function TableFilelist_CellSelectionCallback(hObject, eventdata, handles)
handles.imgIdx = eventdata.Indices(1);
guidata(hObject, handles);
updateImg(handles.imgIdx,hObject,handles)


 
% --- Executes on button press in btnComputeSegments.
function btnComputeSegments_Callback(hObject, eventdata, handles)
    computeSegments(hObject,eventdata,handles)


% --- Executes on button press in btnDrawPolygon.
function btnDrawPolygon_Callback(hObject, eventdata, handles)
% Draw polygon
% Get Centroids in polygon
% Get Inliers

if (handles.readyToLabel);
    superPixels = handles.superPixels;
    labelImg = superPixels.labelImg;
    line = getline;
    inside = getSuperpixelsInPolygon(line,superPixels.Centroid);
    superPixelImg = superPixels.superPixelImg;
    overlayMask = paintSuperpixels(inside,superPixelImg);

    indName = get(get(handles.Labels ,'SelectedObject'),'String');
    ind = find(ismember(handles.colorNames,indName)); % Get ind corresponding to color / label
    handles.selectedLabel = ind;
    
    labelImg(overlayMask) = handles.selectedLabel ; % Colorize selected polygon
    handles.superPixels.labelImg = labelImg; % Update the overlay
    handles.isSaved = false; % Prompt user to save image
    
    guidata(hObject, handles); 
    drawOverlay(hObject,handles)
    msg = {'Please hit ''Save''' 'to store modifications'};
    set(handles.stStatus,'String',msg);
    
else 
    msg = {'Image not ready to' 'label yet. Compute' 'super pixels first'};
    set(handles.stStatus,'String',msg);
end

function drawOverlay(hObject,handles)
% Plot new Overlay
fullMask = im2bw(handles.superPixels.labelImg); % TODO: Check if image to bw is the right function here
handles.myCanvas = imshow(handles.superPixels.oversegImage);
hold on
overlay_final = ind2rgb(handles.superPixels.labelImg,handles.colors);
overlay_final = uint8(overlay_final);
handles.myCanvas = imshow(overlay_final);
alphaMask = double(fullMask)*0.7;
set(handles.myCanvas,'AlphaData',alphaMask);   
hold off
% guidata(handles.myCanvas, handles); 
guidata(hObject, handles); 



function computeSegments(hObject,eventdata,handles)
imgIdx = handles.imgIdx;
handles.imgName = handles.filelist{imgIdx};

fullImgPath = [handles.imgDir '/'  handles.imgName];
fullAnnoPath = [handles.annoDir '/'  handles.imgId '.mat'];

if exist(fullAnnoPath,'file')
    warning('Existing Annotation will be overwritten')
end
if exist(fullImgPath,'file')
    handles.img = imread(fullImgPath);
    
    % Compute superPixels
    set(handles.stStatus,'String','Wait...');
    drawnow;
    regionSize = handles.regionSize;
    regularizer = handles.regularizer;
    superPixels = getAllSuperpixels(handles.img,regionSize,regularizer);
    handles.myCanvas = imshow(superPixels.oversegImage);
    handles.superPixels = superPixels;
    set(handles.stStatus,'String','Done');
    handles.readyToLabel = true; % Set flag that image can be labels
    guidata(hObject, handles);  
else
    disp('No img found');

end


function updateImg(imgIdx,hObject,handles)
% if (~handles.isSaved) % Check if previous modifications have been saved
% %    selection = questdlg('Save new Annotations?',...
% %                         'Save new Annotations?',...
% %                         'Yes','No','Yes');
% 
% %    switch selection,
% %       case 'Yes',
% %          %...
% %       case 'No'
% %          %...
% %    end
% end

handles.imgIdx = imgIdx;
handles.imgName = handles.filelist{imgIdx};
[~, handles.imgId,~] = fileparts(handles.imgName);

set(handles.stImgName,'String',handles.imgId);
fullImgPath = [handles.imgDir '/'  handles.imgName];
fullAnnoPath = [handles.annoDir '/'  handles.imgId '.mat'];

if exist(fullAnnoPath,'file')
    a = load(fullAnnoPath,'anno');
    anno = a.anno;
    handles.superPixels = anno;
    handles.readyToLabel = true;
    guidata(hObject, handles);
    drawOverlay(hObject,handles)
    
elseif exist(fullImgPath,'file')
    handles.img = imread(fullImgPath);
    handles.myCanvas = imshow(handles.img);
    handles.readyToLabel = false;
    msg = {'No annotation found,' 'please compute segments'};
    set(handles.stStatus,'String',msg);
    guidata(hObject, handles);
else
    disp('No img found');
end
  


% --- Executes on button press in btnSelectSuperpixels.
function btnSelectSuperpixels_Callback(hObject, eventdata, handles)
% Select an arbitrary number of points
% After selecting a point, get the corresponding superpixel ID
% Paint superpixel with the color selected

h = handles.myCanvas;
if ~isempty(h)
    set(h,'ButtonDownFcn',@(src,eventdata)position_and_button(src,eventdata,hObject));
else
    msg = {'myCanvas handle' 'is empty'};
    set(handles.stStatus,'String',msg);
end





function position_and_button(src,eventdata,hObject)
Position = get( ancestor(src,'axes'), 'CurrentPoint' );
Button = get( ancestor(src,'figure'), 'SelectionType' );
% hObject
% src
hfig = ancestor(src, 'figure'); % Get the handle to the figure
handles = guidata(hfig); % Get the handles struct

% hold on 
Position = int32(Position);
Point = Position(end,:);
% plot(Point(1),Point(2),'r+');
% hold off

indName = get(get(handles.Labels ,'SelectedObject'),'String');
ind = find(ismember(handles.colorNames,indName)); % Get ind corresponding to color / label
handles.selectedLabel = ind;
Position = int32(Position);

if ~isempty(Position)

    Point = Position(end,:); % Only take first point ( not sure why output argument consists of 2 points)

    spImg = handles.superPixels.superPixelImg;
    superPixelId = spImg(Point(2),Point(1));
    labelImg = handles.superPixels.labelImg;
    overlayMask = (spImg == superPixelId);

    labelImg(overlayMask) = handles.selectedLabel; % Colorize selected polygon
    handles.superPixels.labelImg = labelImg; % Update the overlay
    handles.isSaved = false; % Prompt user to save image

%         guidata(src, handles) 
%         drawOverlay(hObject,handles)

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    % Plot new Overlay
    fullMask = im2bw(handles.superPixels.labelImg); % TODO: Check if image to bw is the right function here
    set(src,'CData',handles.superPixels.oversegImage);
    hold on
    overlay_final = ind2rgb(handles.superPixels.labelImg,handles.colors);
    overlay_final = uint8(overlay_final);
    set(src,'CData',overlay_final);
    alphaMask = double(fullMask)*0.7;
    set(handles.myCanvas,'AlphaData',alphaMask);   
    hold off
    guidata(hObject, handles); 
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        
    msg = {'Please hit ''Save''' 'to store modifications'};
    set(handles.stStatus,'String',msg);

else 
    msg = {'Point is empty' 'try again'};
    set(handles.stStatus,'String',msg);


end

   
   
% function superPixelId = paintSuperPixel(Position,label,hObject,handles)
% 
% Position = int32(Position);
% 
% if ~isempty(Position)
% 
%     Point = Position(end,:); % Only take first point ( not sure why output argument consists of 2 points)
% 
%     spImg = handles.superPixels.superPixelImg;
%     superPixelId = spImg(Point(2),Point(1));
%     labelImg = handles.superPixels.labelImg;
%     overlayMask = (spImg == superPixelId);
% 
% 
% 
%     labelImg(overlayMask) = label; % Colorize selected polygon
%     handles.superPixels.labelImg = labelImg; % Update the overlay
%     handles.isSaved = false; % Prompt user to save image
% 
%     guidata(hObject, handles); 
%     drawOverlay(hObject,handles)
%     msg = {'Please hit ''Save''' 'to store modifications'};
%     set(handles.stStatus,'String',msg);
% 
%     guidata(hObject, handles); 
% 
% else 
%     msg = {'Point is empty' 'try again'};
%     set(handles.stStatus,'String',msg);
%    
% 
% end
   
   
   
   
   
   
   
   
   
   
   
   
   
   
