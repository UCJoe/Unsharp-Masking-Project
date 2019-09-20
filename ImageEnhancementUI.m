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

handles.OriginalImage = emptyImage;
axes(handles.axes1);
imshow(handles.OriginalImage);

handles.FilteredImage = emptyImage;
axes(handles.axes2);
imshow(handles.FilteredImage);

handles.Difference = emptyImage;
axes(handles.axes3);
imshow(handles.Difference);

handles.EnhancedImage = emptyImage;
axes(handles.axes4);
imshow(handles.EnhancedImage);

handles.tgroup = uitabgroup('Parent', handles.figure1, 'TabLocation', 'left');
handles.tab1 = uitab('Parent', handles.tgroup, 'Title', 'Main');
handles.tab2 = uitab('Parent', handles.tgroup, 'Title', 'View');

set(handles.P1, 'Parent', handles.tab1);
set(handles.P2, 'Parent', handles.tab2);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImageEnhancementUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ImageEnhancementUI_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
[file,path] = uigetfile('*.jpg');
if (file == 0)
    return;
end

if ( length( strfind(file,'.jpg') ) == 0)
    return;
end
handles.OriginalImage = imread([path file]);
axes(handles.axes1);
imshow(handles.OriginalImage);
set(handles.text10, 'String', file);

RenderAll(hObject, eventdata, handles)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
handles.FilterSize = round(handles.slider1.Value * 10) + 1;

filterLabel = sprintf('Lowpass Filter Size = %d x %d', handles.FilterSize, handles.FilterSize);
set(handles.text7, 'String', filterLabel);

RenderAll(hObject, eventdata, handles)


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
handles.k = handles.slider2.Value;

kLabel = sprintf('k = %.3f', handles.k);
set(handles.text8, 'String', kLabel);

RenderLast(hObject, eventdata, handles)

function slider1_CreateFcn(hObject, eventdata, handles)
function slider2_CreateFcn(hObject, eventdata, handles)

function RenderAll(hObject, eventdata, handles)
handles.FilteredImage = LowpassFilterImage(handles);
axes(handles.axes2);
imshow(handles.FilteredImage);

handles.Difference = ImageDifference(handles);
axes(handles.axes3);
imshow(handles.Difference);
RenderLast(hObject, eventdata, handles);
% Update handles structure
guidata(hObject, handles);

function RenderLast(hObject, eventdata, handles)
handles.EnhancedImage = AddDifference(handles);
axes(handles.axes4);
imshow(handles.EnhancedImage);
% Update handles structure
guidata(hObject, handles);

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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
