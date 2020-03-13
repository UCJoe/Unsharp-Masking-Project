function varargout = ImageEnhancementUI(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageEnhancementUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageEnhancementUI_OutputFcn, ...
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

% --- Executes just before ImageEnhancementUI is made visible.
function ImageEnhancementUI_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

handles.FilterSize = 1;
handles.k = 0;

emptyImage = uint8( zeros(1, 1, 3) );

handles.inputImage = emptyImage;
axes(handles.inputAxes);
imshow(handles.inputImage);

handles.equalizedImage = emptyImage;

handles.powerLawImage = emptyImage;

handles.outputImage = emptyImage;
axes(handles.outputAxes);
imshow(handles.outputImage);
%{
handles.tgroup = uitabgroup('Parent', handles.figure1, 'TabLocation', 'left');
handles.tab1 = uitab('Parent', handles.tgroup, 'Title', 'Main');
handles.tab2 = uitab('Parent', handles.tgroup, 'Title', 'View');

set(handles.mainPanel, 'Parent', handles.tab1);
set(handles.viewPanel, 'Parent', handles.tab2);
%}
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImageEnhancementUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Executes during object creation, after setting all properties.
function histogramStretchLeftSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function histogramStretchRightSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function powerLawSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function unsharpMaskBlurSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function unsharpMaskKSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function [equalizedImage, powerLawImage, outputImage] = pipeline(hObject, eventdata, handles, stage)
% Disable Controls and set loading text
%{
set(handles.loadingText, 'String', "Loading");
set(handles.importButton, 'Enable', 'off');
set(handles.exportButton, 'Enable', 'off');
set(handles.histogramStretchLeftSlider, 'Enable', 'off');
set(handles.histogramStretchRightSlider, 'Enable', 'off');
set(handles.powerLawSlider, 'Enable', 'off');
set(handles.unsharpMaskBlurSlider, 'Enable', 'off');
set(handles.unsharpMaskKSlider, 'Enable', 'off');
%}

% Apply Histogram Equalization transform
equalizedImage = HistogramEqualizationTransform(handles);
handles.equalizedImage = equalizedImage;

% Apply Power Law transform
[powerLawImage, power] = PowerLawTransformation(handles);
handles.powerLawImage = powerLawImage;

axes(handles.powerLawAxes);
powerLawXAxis = [0:.1:1];
powerLawYAxis = powerLawXAxis.^power;
plot(powerLawXAxis, powerLawYAxis);
set(gca, 'xtick', []);
set(gca, 'ytick', []);

% Apply Unsharp Masking transform
outputImage = UnsharpMaskingTransform(handles);
handles.outputImage = outputImage;

axes(handles.outputAxes);
imshow(handles.outputImage);
% Calculate Histogram
histogramXAxis = [1:1:256];
[inputHistogram, outputHistogram] = CalculateHistograms(handles);
axes(handles.histogramAxes);
cla(handles.histogramAxes);
set(handles.histogramAxes, 'YScale', 'log');
hold on;
stem(histogramXAxis, inputHistogram);
stem(histogramXAxis, outputHistogram);
hold off;

% Enable Controls and clear loading text
set(handles.importButton, 'Enable', 'on');
set(handles.exportButton, 'Enable', 'on');
set(handles.histogramStretchLeftSlider, 'Enable', 'on');
set(handles.histogramStretchRightSlider, 'Enable', 'on');
set(handles.powerLawSlider, 'Enable', 'on');
set(handles.unsharpMaskBlurSlider, 'Enable', 'on');
set(handles.unsharpMaskKSlider, 'Enable', 'on');
set(handles.loadingText, 'String', "");


% --- Outputs from this function are returned to the command line.
function varargout = ImageEnhancementUI_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes on button press in importButton.
function importButton_Callback(hObject, eventdata, handles)
[file,path] = uigetfile('*.jpg');
if (file == 0)
    return;
end

if ( length( strfind(file,'.jpg') ) == 0)
    return;
end
handles.inputImage = imread([path file]);
axes(handles.inputAxes);
imshow(handles.inputImage);
set(handles.imageNameText, 'String', file);
[handles.equalizedImage, handles.powerLawImage, handles.outputImage]...
    = pipeline(hObject, eventdata, handles, Stages.Import);
guidata(hObject, handles);



% --- Executes on button press in exportButton.
function exportButton_Callback(hObject, eventdata, handles)
[baseFileName, folder] = uiputfile('outputImage.jpg', 'Specify a file');
if (baseFileName == 0)
    return;
end
fullFileName = fullfile(folder, baseFileName);
imwrite(handles.outputImage, fullFileName);

% --- Executes on slider movement.
function histogramStretchLeftSlider_Callback(hObject, eventdata, handles)
[handles.equalizedImage, handles.powerLawImage, handles.outputImage]...
    = pipeline(hObject, eventdata, handles, Stages.HistogramEqualization);
guidata(hObject, handles);

% --- Executes on slider movement.
function histogramStretchRightSlider_Callback(hObject, eventdata, handles)
[handles.equalizedImage, handles.powerLawImage, handles.outputImage]...
    = pipeline(hObject, eventdata, handles, Stages.HistogramEqualization);
guidata(hObject, handles);

% --- Executes on slider movement.
function powerLawSlider_Callback(hObject, eventdata, handles)
[handles.equalizedImage, handles.powerLawImage, handles.outputImage]...
    = pipeline(hObject, eventdata, handles, Stages.PowerLaw);
guidata(hObject, handles);

% --- Executes on slider movement.
function unsharpMaskBlurSlider_Callback(hObject, eventdata, handles)
[handles.equalizedImage, handles.powerLawImage, handles.outputImage]...
    = pipeline(hObject, eventdata, handles, Stages.UnsharpMasking);
guidata(hObject, handles);

% --- Executes on slider movement.
function unsharpMaskKSlider_Callback(hObject, eventdata, handles)
[handles.equalizedImage, handles.powerLawImage, handles.outputImage]...
    = pipeline(hObject, eventdata, handles, Stages.UnsharpMasking);
guidata(hObject, handles);


function equalizedImage = HistogramEqualizationTransform(handles)
[rows, columns, colorDimensions] = size(handles.inputImage);
equalizedImage = zeros(rows, columns, colorDimensions);

lowBrightness = get(handles.histogramStretchLeftSlider, 'Value') * 256;
highBrightness = 256 - get(handles.histogramStretchRightSlider, 'Value') * 256;
stretch = double(256/(highBrightness - lowBrightness));

for color = 1 : colorDimensions
    for x = 1 : rows
        for y = 1 : columns
            if (handles.inputImage(x,y,color) <= lowBrightness)
                equalizedImage(x,y,color) = 0;
            elseif (handles.inputImage(x,y,color) >= highBrightness)
                equalizedImage(x,y,color) = 255;
            else
                
                equalizedImage(x,y,color) = (handles.inputImage(x,y,color)-lowBrightness)*stretch;
            end
        end
    end
end
equalizedImage = uint8(equalizedImage);

function [powerLawImage, power] = PowerLawTransformation(handles)
[rows, columns, colorDimensions] = size(handles.equalizedImage);
powerLawImage = zeros(rows, columns, colorDimensions);
inputImage = double(handles.equalizedImage);

value = round(get(handles.powerLawSlider, 'Value'), 2);

if (value <= .5)
    power = 1 + (value - .5) * 2;
elseif (value > .5)
    power = 1 + (value - .5) * 20;
end

for color = 1 : colorDimensions
    for x = 1 : rows
        for y = 1 : columns
            weightedBrightness = inputImage(x,y,color)/256;
            powerLawImage(x,y,color) = weightedBrightness ^ power *256;
        end
    end
end
powerLawImage = uint8(powerLawImage);

function unsharpMaskingImage = UnsharpMaskingTransform(handles)
[rows, columns, colorDimensions] = size(handles.powerLawImage);
inputImage = double(handles.powerLawImage);

blurValue = 1 + round(get(handles.unsharpMaskBlurSlider, 'Value'), 1) * 10;
blurredImage = imgaussfilt(inputImage, blurValue);

unsharpMask = inputImage - blurredImage;

kValue = get(handles.unsharpMaskKSlider, 'Value');

unsharpMaskingImage = inputImage + kValue .* unsharpMask;
unsharpMaskingImage = uint8(unsharpMaskingImage);


function [inputHistogram, outputHistogram] = CalculateHistograms(handles)
inputHistogram = zeros(1, 256);
outputHistogram = zeros(1, 256);

[rows, columns, colorDimensions] = size(handles.inputImage);
for color = 1 : colorDimensions
    for x = 1 : rows
        for y = 1 : columns
            inputPixelBrightness = handles.inputImage(x, y, color) + 1;
            inputHistogram(inputPixelBrightness) = inputHistogram(inputPixelBrightness) + 1;
            
            outputPixelBrightness = handles.outputImage(x, y, color) + 1;
            outputHistogram(outputPixelBrightness) = outputHistogram(outputPixelBrightness) + 1;
            
        end
    end
end
