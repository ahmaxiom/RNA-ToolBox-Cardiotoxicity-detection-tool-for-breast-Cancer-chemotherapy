function varargout = Dialogue_box_pre_post(varargin)
% DIALOGUE_BOX_PRE_POST MATLAB code for Dialogue_box_pre_post.fig
%      DIALOGUE_BOX_PRE_POST, by itself, creates a new DIALOGUE_BOX_PRE_POST or raises the existing
%      singleton*.
%
%      H = DIALOGUE_BOX_PRE_POST returns the handle to a new DIALOGUE_BOX_PRE_POST or the handle to
%      the existing singleton*.
%
%      DIALOGUE_BOX_PRE_POST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIALOGUE_BOX_PRE_POST.M with the given input arguments.
%
%      DIALOGUE_BOX_PRE_POST('Property','Value',...) creates a new DIALOGUE_BOX_PRE_POST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Dialogue_box_pre_post_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Dialogue_box_pre_post_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Dialogue_box_pre_post

% Last Modified by GUIDE v2.5 02-Feb-2021 22:28:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Dialogue_box_pre_post_OpeningFcn, ...
                   'gui_OutputFcn',  @Dialogue_box_pre_post_OutputFcn, ...
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


% --- Executes just before Dialogue_box_pre_post is made visible.
function Dialogue_box_pre_post_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Dialogue_box_pre_post (see VARARGIN)

% Choose default command line output for Dialogue_box_pre_post
handles.output = hObject;
load deletedInfo max_img1 imvolmx1 min_img1 imvolmn1 max_img2 imvolmx2 min_img2 imvolmn2 smoothedPoly11 smoothedPoly12 smoothedPoly21 smoothedPoly22;
%% show results
% pre
axes(handles.axes1)
imshow(max_img2,[]);title('Pre Diastole Image'),colormap(jet);
hold on
h=impoly(gca,smoothedPoly21);
setColor(h,'black');
hold off
axes(handles.axes2)
imshow(imvolmx2,[]);title('Pre Diastole ROI Image'),colormap(jet);
axes(handles.axes3)
imshow(min_img2,[]);title('Pre Systole Image'),colormap(jet);
hold on
h=impoly(gca,smoothedPoly22);
setColor(h,'black');
hold off
axes(handles.axes4)
imshow(imvolmn2,[]);title('Pre Systole ROI Image'),colormap(jet);
% post
axes(handles.axes5)
 imshow(max_img1,[]);title('Post Diastole Image'),colormap(jet);
hold on
h=impoly(gca,smoothedPoly11);
setColor(h,'black');
hold off
axes(handles.axes6)
imshow(imvolmx1,[]);title('Post Diastole ROI Image'),colormap(jet);
axes(handles.axes7)
imshow(min_img1,[]);title('Post Systole Image'),colormap(jet);
hold on
h=impoly(gca,smoothedPoly12);
setColor(h,'black');
hold off
axes(handles.axes8)
imshow(imvolmn1,[]);title('Post Systole ROI Image'),colormap(jet);
% Update handles structure
% plot curves
load curvePre x y yy;
axes(handles.axes9);
%plot(x,y,'-*b');
yy = smooth(y);
%hold on;
plot(x,yy,'-*r');
title('Pre LV Time activity curve');
mx=max(y);
mn=min(y);
axis([x(1) x(end) 0 mx]);
xlabel('Time (msec)');
ylabel('Count (count)');
legend('Smoothed Curve',...
       'Location','SW');
axes(handles.axes9)
load curvePost x y yy;
axes(handles.axes10);
%plot(x,y,'-*b');
yy = smooth(y);
%hold on;
plot(x,yy,'-*r');
title('Post LV Time activity curve');
mx=max(y);
mn=min(y);
axis([x(1) x(end) 0 mx]);
xlabel('Time (msec)');
ylabel('Count (count)');
legend('Smoothed Curve',...
       'Location','SW');
load post AcquisitionDate area1Post area2Post AverageDivPost circularityMaxPost circularityMinPost ElongationMaxPost ...
    ElongationMinPost Entro_post ApEnPost FrameTime heart2lungpost HeartRate HighRRValue IntervalsAcquired IntervalsRejected LowRRValue...
    LVEFpost Manufacturer minLongDIVmaxLPost minShortDIVmaxLPost PatientAge PatientID PatientWeight PixelNumMaxPost PixelNumMinPost...
    post2pre ratePost Sync_post TIDmax TIDmin TotalBGmaxPost TotalBGmaxPost1 TotalBGminPost TotalBGminPost1 phasePost PixelsBkgMaxPost PixelsBkgMinPost meanBGMx2 meanBGMn2 BoundApEnPost epsilonPost LspsilonPost
post=[ {PatientID} {PatientAge} {PatientWeight} {AcquisitionDate} {area1Post} {area2Post} {AverageDivPost} {circularityMaxPost} {circularityMinPost} {ElongationMaxPost} ...
    {ElongationMinPost} {Entro_post} {ApEnPost} {FrameTime} {heart2lungpost} {HeartRate} {HighRRValue} {IntervalsAcquired} {IntervalsRejected} {LowRRValue}...
    {LVEFpost} {Manufacturer} {minLongDIVmaxLPost} {minShortDIVmaxLPost} {PixelNumMaxPost} {PixelNumMinPost}...
    {post2pre} {ratePost} {Sync_post} {TIDmax} {TIDmin} {TotalBGmaxPost} {TotalBGminPost} {TotalBGmaxPost1} {TotalBGminPost1} {PixelsBkgMaxPost} {PixelsBkgMinPost} {phasePost} {meanBGMx2} {meanBGMn2} {BoundApEnPost} {epsilonPost} {LspsilonPost}];
load pre AcquisitionDate2 area1Pre area2Pre AverageDivPre circularityMaxPre circularityMinPre ElongationMaxPre ...
    ElongationMinPre Entro_pre ApEnPre FrameTime2 heart2lungpre HeartRate2 HighRRValue2 IntervalsAcquired2 IntervalsRejected2 LowRRValue2...
    LVEFpre Manufacturer minLongDIVmaxLPre minShortDIVmaxLPre PatientAge2 PatientID PatientWeight2 PixelNumMaxPre PixelNumMinPre...
    post2pre ratePre Sync_pre TIDmax TIDmin TotalBGmaxPre TotalBGmaxPre1 TotalBGminPre TotalBGminPre1 phasePre PixelsBkgMaxPre PixelsBkgMinPre meanBGMx meanBGMn BoundApEnPre epsilonPre LspsilonPre
pre=[{PatientID} {PatientAge} {PatientWeight2} {AcquisitionDate2} {area1Pre} {area2Pre} {AverageDivPre} {circularityMaxPre} {circularityMinPre} {ElongationMaxPre} ...
    {ElongationMinPre} {Entro_pre} {ApEnPre} {FrameTime2} {heart2lungpre} {HeartRate2} {HighRRValue2} {IntervalsAcquired2} {IntervalsRejected2} {LowRRValue2}...
    {LVEFpre} {Manufacturer} {minLongDIVmaxLPre} {minShortDIVmaxLPre} {PixelNumMaxPre} {PixelNumMinPre}...
    {post2pre} {ratePre} {Sync_pre} {TIDmax} {TIDmin} {TotalBGmaxPre} {TotalBGminPre} {TotalBGmaxPre1} {TotalBGminPre1} {PixelsBkgMaxPre} {PixelsBkgMinPre} {phasePre} {meanBGMx} {meanBGMn} {BoundApEnPre} {epsilonPre} {LspsilonPre}];
post=post';
pre=pre';
set(handles.uitable3,'data',post);
set(handles.uitable1,'data',pre);

guidata(hObject, handles);

% UIWAIT makes Dialogue_box_pre_post wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Dialogue_box_pre_post_OutputFcn(hObject, eventdata, handles) 
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
exportInfo2Excel;
msgbox('data have been written to platform.xlsx');
%system('taskkill /F /IM EXCEL.EXE');
