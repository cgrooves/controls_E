function varargout = ball_sim(varargin)
% BALL_SIM MATLAB code for ball_sim.fig
%      BALL_SIM, by itself, creates a new BALL_SIM or raises the existing
%      singleton*.
%
%      H = BALL_SIM returns the handle to a new BALL_SIM or the handle to
%      the existing singleton*.
%
%      BALL_SIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BALL_SIM.M with the given input arguments.
%
%      BALL_SIM('Property','Value',...) creates a new BALL_SIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ball_sim_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ball_sim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ball_sim

% Last Modified by GUIDE v2.5 15-Sep-2017 23:34:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ball_sim_OpeningFcn, ...
                   'gui_OutputFcn',  @ball_sim_OutputFcn, ...
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


% --- Executes just before ball_sim is made visible.
function ball_sim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ball_sim (see VARARGIN)

% Choose default command line output for ball_sim
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ball_sim wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Other starting things
% set z_text and theta_slider min's and max's
ball_paramsHWA()
global theta_max;
global theta_min;
global z_min;
global z_max;
set(handles.z_slider,'Min',z_min,'Max',z_max)
set(handles.theta_slider,'Min',theta_min,'Max',theta_max)
draw_ball_beam(handles,'--i')
get(handles.z_slider,'Value')

% --- Outputs from this function are returned to the command line.
function varargout = ball_sim_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function theta_slider_Callback(hObject, eventdata, handles)
% hObject    handle to theta_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
draw_ball_beam(handles,'d');

% --- Executes during object creation, after setting all properties.
function theta_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function z_slider_Callback(hObject, eventdata, handles)
% hObject    handle to z_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
draw_ball_beam(handles,'d');

% --- Executes during object creation, after setting all properties.
function z_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
