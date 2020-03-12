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


% --- Executes on button press in exportButton.
function exportButton_Callback(hObject, eventdata, handles)
% hObject    handle to exportButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function unsharpMaskBlurSlider_Callback(hObject, eventdata, handles)
% hObject    handle to unsharpMaskBlurSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function unsharpMaskBlurSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to unsharpMaskBlurSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function unsharpMaskKSlider_Callback(hObject, eventdata, handles)
% hObject    handle to unsharpMaskKSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function unsharpMaskKSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to unsharpMaskKSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function powerLawSlider_Callback(hObject, eventdata, handles)
% hObject    handle to powerLawSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function powerLawSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to powerLawSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function histogramStretchLeftSlider_Callback(hObject, eventdata, handles)
% hObject    handle to histogramStretchLeftSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function histogramStretchLeftSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to histogramStretchLeftSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function histogramStretchRightSlider_Callback(hObject, eventdata, handles)
% hObject    handle to histogramStretchRightSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function histogramStretchRightSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to histogramStretchRightSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

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
