function varargout = DAP(varargin)
% DAP MATLAB code for DAP.fig
%      DAP, by itself, creates a new DAP or raises the existing
%      singleton*.
%
%      H = DAP returns the handle to a new DAP or the handle to
%      the existing singleton*.
%
%      DAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DAP.M with the given input arguments.
%
%      DAP('Property','Value',...) creates a new DAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DAP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DAP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DAP

% Last Modified by GUIDE v2.5 21-Jul-2016 21:30:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DAP_OpeningFcn, ...
                   'gui_OutputFcn',  @DAP_OutputFcn, ...
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


% --- Executes just before DAP is made visible.
function DAP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DAP (see VARARGIN)

% Choose default command line output for DAP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DAP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DAP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;

[fn pn] = uigetfile('*.jpg','select jpg file');
complete = strcat(pn,fn);
set(handles.edit1,'string',complete);
I = imread(complete);
%axes(handles.axes1);
imshow(I);
guidata(hObject, handles);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
R = get(handles.edit1, 'string')
S=imread(R);

H = fspecial('gaussian',100,2);
gauss = imfilter(S,H,'replicate');

L=[-1 -1 -1; -1 8 -1; -1 -1 -1]; 
k= imfilter(gauss,L);
final_img=k+gauss;
imshow(final_img);
imwrite(final_img,'C:\Users\sania\Downloads\Document-analysis-project\noiseremoved\NoiseRemoved.jpg');
% K = medfilt2(I);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)

R = get(handles.edit1, 'string')
delete('C:\Users\sania\Downloads\Document-analysis-project\Output_Images\*.jpg');
img1=imread(R);
[h w]=size(img1)

%Ratio
R=w/h;
newh=h*R;
img=imresize(img1,[newh 3075]);

%Dilation Function
[stats,Ibox,bwSub]=dilated(img);
imshow(bwSub);

for k=1:length(stats)
    c=imcrop(img,Ibox(:,k));
    c=imresize(c,[480 640]);
    filename=sprintf('C:\\Users\\sania\\Downloads\\Document-analysis-project\\Output_Images\\%02d.jpg',k);
    imwrite(c,filename,'jpg');
    rectangle('position',Ibox(:,k),'edgecolor','r');
end

function pushbutton4_Callback(hObject, eventdata, handles)
R = get(handles.edit1, 'string')
delete('C:\Users\sania\Downloads\Document-analysis-project\Output_Images\*.jpg');
img1=imread(R);
[h w]=size(img1);

%Ratio
R=w/h;
newh=h*R;
img=imresize(img1,[newh 3075]);

%Dilation function
[stats,Ibox,bwSub]=dilated(img);
LabelImg=img;

for k=1:length(stats)
    c=imcrop(LabelImg,Ibox(:,k));
    c=imresize(c,[480 640]);
    filename=sprintf('C:\\Users\\sania\\Desktop\\Output_Images\\%02d.jpg',k);
    imwrite(c,filename,'jpg');
    results=ocr(c);
    d=results.Text;
    thisBB = stats(k).BoundingBox ;
    if stats(k).BoundingBox(4) > 400
        if d~=0
            label = 'col';
        else
            label='image';            
        end
    elseif stats(k).BoundingBox(4) < 400
        label =  'head';  
    end
    LabelImg = insertObjectAnnotation(LabelImg,'rectangle',[thisBB(1),thisBB(2),thisBB(3),thisBB(4)]...
        ,label,'TextBoxOpacity',0.5,'FontSize',70);
end
imshow(LabelImg);

% --- Executes on button press in slider.
function slider_Callback(hObject, eventdata, handles)
Dir=fullfile('C:\Users\sania\Downloads\Document-analysis-project\Output_Images');
paper = imageSet(Dir);
for i=1:paper.Count
    imgCell{i} = read(paper,i);
end
img=cat(1,imgCell{:});
hFig = figure('Toolbar','none',...
              'Menubar','none');
hIm = imshow(img);
SP = imscrollpanel(hFig,hIm);