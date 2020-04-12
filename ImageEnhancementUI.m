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

function pipeline(hObject, eventdata, handles, stage)
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
handles.equalizedImage = handles.inputImage;
handles.equalizedImage = HistogramEqualizationTransform(handles);
if (stage.canApplyHistogramEqualization)
end

% Apply Power Law transform
handles.powerLawImage = handles.equalizedImage;
[handles.powerLawImage, power] = PowerLawTransformation(handles);
axes(handles.powerLawAxes);
powerLawXAxis = [0:.1:1];
powerLawYAxis = powerLawXAxis.^power;
plot(powerLawXAxis, powerLawYAxis);
set(gca, 'xtick', []);
set(gca, 'ytick', []);

if (stage.canApplyPowerLaw)
end

% Apply Unsharp Masking transform
handles.outputImage = handles.powerLawImage;
if (stage.canApplyUnsharpMasking)
end

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
guidata(hObject, handles);


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
pipeline(hObject, eventdata, handles, Stages.Import);


% --- Executes on button press in exportButton.
function exportButton_Callback(hObject, eventdata, handles)
% hObject    handle to exportButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on slider movement.
function histogramStretchLeftSlider_Callback(hObject, eventdata, handles)
pipeline(hObject, eventdata, handles, Stages.HistogramEqualization);
guidata(hObject, handles);

% --- Executes on slider movement.
function histogramStretchRightSlider_Callback(hObject, eventdata, handles)
pipeline(hObject, eventdata, handles, Stages.HistogramEqualization);
guidata(hObject, handles);

% --- Executes on slider movement.
function powerLawSlider_Callback(hObject, eventdata, handles)
pipeline(hObject, eventdata, handles, Stages.PowerLaw);
guidata(hObject, handles);

% --- Executes on slider movement.
function unsharpMaskBlurSlider_Callback(hObject, eventdata, handles)
pipeline(hObject, eventdata, handles, Stages.UnsharpMasking);
guidata(hObject, handles);

% --- Executes on slider movement.
function unsharpMaskKSlider_Callback(hObject, eventdata, handles)
pipeline(hObject, eventdata, handles, Stages.UnsharpMasking);
guidata(hObject, handles);


function equalizedImage = HistogramEqualizationTransform(handles)
[rows, columns, colorDimensions] = size(handles.inputImage);
equalizedImage = zeros(rows, columns, colorDimensions);

lowBrightness = get(handles.histogramStretchLeftSlider, 'Value') * 256;
highBrightness = 256 - get(handles.histogramStretchRightSlider, 'Value') * 256;
stretch = double(256/(highBrightness - lowBrightness));

for color = 1 : colorDimensions
    for y = 1 : rows
        for x = 1 : columns
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
    for y = 1 : rows
        for x = 1 : columns
            weightedBrightness = inputImage(x,y,color)/256;
            powerLawImage(x,y,color) = weightedBrightness ^ power *256;
        end
    end
end
powerLawImage = uint8(powerLawImage);

function FilteredImage = LowpassFilterImage(handles)
[rows, columns, colorDimensions] = size(handles.OriginalImage);
newRows = rows - handles.FilterSize + 1;
if (newRows < 1)
    newRows = 1;
end
newColumns = columns - handles.FilterSize + 1;
if (newColumns < 1)
    newColumns = 1;
end
FilteredImage = zeros(newRows, newColumns, colorDimensions);

if (rows > handles.FilterSize && columns > handles.FilterSize)
    for color = 1 : colorDimensions
        for y = 1 : newRows
            for x = 1 : newColumns
                sum = 0;
                for a = 0 : handles.FilterSize - 1
                    for b = 0 : handles.FilterSize - 1
                        sum = sum + double(handles.OriginalImage(y + a, x + b, color));
                    end
                end
                filterArea = handles.FilterSize ^ 2;
                brightness = round(sum / filterArea);
                FilteredImage(y, x, color) = brightness;
            end
        end
    end
end
FilteredImage = uint8(FilteredImage);

function Difference = ImageDifference(handles)
[rows, columns, colorDimensions] = size(handles.FilteredImage);
Difference = zeros(rows, columns, colorDimensions);

for color = 1 : colorDimensions
    for y = 1 :rows
        for x = 1 : columns
            Difference(y, x, color) = handles.OriginalImage(y, x, color) - handles.FilteredImage(y, x, color);
        end
    end
end

function EnhancedImage = AddDifference(handles)
[rows, columns, colorDimensions] = size(handles.FilteredImage);
OriginalImage = handles.OriginalImage([1 : rows],[1 : columns],[1 2 3]);
EnhancedImage = uint8(handles.Difference * handles.k) + OriginalImage;

function [inputHistogram, outputHistogram] = CalculateHistograms(handles)
inputHistogram = zeros(1, 256);
outputHistogram = zeros(1, 256);

[rows, columns, colorDimensions] = size(handles.inputImage);
for color = 1 : colorDimensions
    for y = 1 : rows
        for x = 1 : columns
            inputPixelBrightness = handles.inputImage(y, x, color) + 1;
            inputHistogram(inputPixelBrightness) = inputHistogram(inputPixelBrightness) + 1;
            
            outputPixelBrightness = handles.outputImage(y, x, color) + 1;
            outputHistogram(outputPixelBrightness) = outputHistogram(outputPixelBrightness) + 1;
            
        end
    end
end
