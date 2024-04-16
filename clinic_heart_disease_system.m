%% This file is the main GUI file 
% some parameters are adjustable which are:
% 1- numofIter: you can change number of iteration of each ROI of the 16 frames (for each ROI you need to specify a value depending on its gray count)
% 2- numofIterRG: number of iteration for region growing X algorithm
% 3- XD and YD: change XD for the horizontal displacement and YD for the vertical displacement
% 4- SmoothFactor: Degree of smoothness or regularity of the boundaries of the segmented regions (Active contouring algorithm)
% 5- ContractionBias: Tendency of the contour to grow outwards or shrink inwards (Active contouring algorithm)
% 6- Method: active contouring method
% 7- MMWF_Kernel: kernel size of MMWF filter
function varargout = clinic_heart_disease_system(varargin)
% CLINIC_HEART_DISEASE_SYSTEM MATLAB code for clinic_heart_disease_system.fig
%      CLINIC_HEART_DISEASE_SYSTEM, by itself, creates a new CLINIC_HEART_DISEASE_SYSTEM or raises the existing
%      singleton*.
%
%      H = CLINIC_HEART_DISEASE_SYSTEM returns the handle to a new CLINIC_HEART_DISEASE_SYSTEM or the handle to
%      the existing singleton*.
%
%      CLINIC_HEART_DISEASE_SYSTEM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLINIC_HEART_DISEASE_SYSTEM.M with the given input arguments.
%
%      CLINIC_HEART_DISEASE_SYSTEM('Property','Value',...) creates a new CLINIC_HEART_DISEASE_SYSTEM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before clinic_heart_disease_system_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to clinic_heart_disease_system_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help clinic_heart_d isease_system

% Last Modified by GUIDE v2.5 13-Feb-2021 22:25:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @clinic_heart_disease_system_OpeningFcn, ...
                   'gui_OutputFcn',  @clinic_heart_disease_system_OutputFcn, ...
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


% --- Executes just before clinic_heart_disease_system is made visible.
function clinic_heart_disease_system_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to clinic_heart_disease_system (see VARARGIN)

% Choose default command line output for clinic_heart_disease_system
handles.output = hObject;
I=imread('logo.jpg');
axes(handles.axes7);
imagesc(I);
%numofIter=[13 12 11 10 9 9 9 9 10 10 10 11 11 12 13 13]; % you can change num of iteration of each ROI of the 16 frames
numofIter=[13 10]; % you can change num of iteration of each ROI of the 16 frames
numofIterRG=[550 350]; % for region growing X algorithm
XD=0; YD=0; % change XD for the horizontal displacement and YD for the vertical displacement
SmoothFactor=0.2; ContractionBias=0; 
method='Chan-Vese';
%method='edge';
MMWF_Kernel=5;
save AC SmoothFactor ContractionBias method
save maskallparam numofIter numofIterRG XD YD
save MMWF_Kernel MMWF_Kernel
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes clinic_heart_disease_system wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = clinic_heart_disease_system_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
%% Post Part %%
load info info;
tag11=1;
save prepost1 tag11
%get mask for the roi
%% Background Subtraction Post
for i=1:info.NumberOfFrames
    mean_val(i)=mean(mean(handles.imvol_2(:,:,i)));
end
%  mx_val=max(max(mean_val));
% ind_max=find(mx_val==mean_val);
% maxImg=handles.imvol(:,:,ind_max);
% handles.imvolmx=mean(handles.imvol,3);
%

%axes(handles.axes1)
%% max - min of ROI Post
[handles.All_masks1,handles.smoothedPoly11, handles.smoothedPoly12,handles.max_img1,handles.min_img1,handles.imvolmx1,handles.imvolmn1,handles.bw, handles.bwMin1, handles.area1Post, handles.area2Post, handles.ratePost,handles.minLongDIVmaxLPost, handles.minShortDIVmaxLPost,handles.AverageDivPost, handles.circularityMaxPost, handles.circularityMinPost,handles.ElongationMaxPost,handles.ElongationMinPost,sp_post]=max_min_MUGA(handles.imvol_2,0);
save sp_post sp_post;
% background
%mb=msgbox("Please draw the background region","Draw BKG")
%waitfor(mb);
axes(handles.axes2);axis tight;
imagesc(sum(handles.imvol_2,3)); colormap(jet),colorbar ;
NewImg1=imdilate(handles.bw,strel('disk',8))-imdilate(handles.bw,strel('disk',6));
NewImg2=imdilate(handles.bw,strel('disk',7))-imdilate(handles.bw,strel('disk',5));
NewImg3=imdilate(handles.bw,strel('disk',6))-imdilate(handles.bw,strel('disk',4));
NewImg4=imdilate(handles.bw,strel('disk',5))-imdilate(handles.bw,strel('disk',3));
NewImg5=imdilate(handles.bw,strel('disk',4))-imdilate(handles.bw,strel('disk',2));

S1=regionprops(bwlabel(NewImg1),'Centroid');
S2=regionprops(bwlabel(NewImg2),'Centroid');
S3=regionprops(bwlabel(NewImg3),'Centroid');
S4=regionprops(bwlabel(NewImg4),'Centroid');
S5=regionprops(bwlabel(NewImg5),'Centroid');

cc1=round([S1.Centroid]);
cc2=round([S2.Centroid]);
cc3=round([S3.Centroid]);
cc4=round([S4.Centroid]);
cc5=round([S5.Centroid]);

D1=sum(sum(handles.imvolmn1(cc1(2):end,cc1(1):end)));
D2=sum(sum(handles.imvolmn1(cc2(2):end,cc2(1):end)));
D3=sum(sum(handles.imvolmn1(cc3(2):end,cc3(1):end)));
D4=sum(sum(handles.imvolmn1(cc4(2):end,cc4(1):end)));
D5=sum(sum(handles.imvolmn1(cc5(2):end,cc5(1):end)));

NewImg1(1:cc1(2),1:cc1(1))=0;
NewImg1(1:cc1(2),cc1(1):end)=0;
NewImg1(cc1(2):end,1:cc1(1))=0;
NewImg2(1:cc2(2),1:cc2(1))=0;
NewImg2(1:cc2(2),cc2(1):end)=0;
NewImg2(cc2(2):end,1:cc2(1))=0;
NewImg3(1:cc3(2),1:cc3(1))=0;
NewImg3(1:cc3(2),cc3(1):end)=0;
NewImg3(cc3(2):end,1:cc3(1))=0;
NewImg4(1:cc4(2),1:cc4(1))=0;
NewImg4(1:cc4(2),cc4(1):end)=0;
NewImg4(cc4(2):end,1:cc4(1))=0;
NewImg5(1:cc5(2),1:cc5(1))=0;
NewImg5(1:cc5(2),cc5(1):end)=0;
NewImg5(cc5(2):end,1:cc5(1))=0;
% NewImg1(cc1(2)+15:end,:)=0;
% NewImg1(:,1:cc1(1)+5)=0;
% NewImg2(cc2(2)+15:end,:)=0;
% NewImg2(:,1:cc2(1)+5)=0;
% NewImg3(cc3(2)+15:end,:)=0;
% NewImg3(:,1:cc3(1)+5)=0;
% NewImg4(cc4(2)+15:end,:)=0;
% NewImg4(:,1:cc4(1)+5)=0;
% NewImg5(cc5(2)+15:end,:)=0;
% NewImg5(:,1:cc5(1)+5)=0;
NewImg6=NewImg1|NewImg2|NewImg3|NewImg4|NewImg5;

handles.imvolmn11=handles.min_img1;
handles.imvolmn11(NewImg6==0)=0;
handles.meanBG1=mean(mean(handles.min_img1(NewImg1==1)));
handles.meanBG2=mean(mean(handles.min_img1(NewImg2==1)));
handles.meanBG3=mean(mean(handles.min_img1(NewImg3==1)));
handles.meanBG4=mean(mean(handles.min_img1(NewImg4==1)));
handles.meanBG5=mean(mean(handles.min_img1(NewImg5==1)));

%handles.meanBGMn2=(handles.meanBG1+handles.meanBG2+handles.meanBG3+handles.meanBG4+handles.meanBG5)/5
handles.meanBGMn2=min([handles.meanBG1,handles.meanBG2,handles.meanBG3,handles.meanBG4,handles.meanBG5]);
mtx=[handles.meanBG1,handles.meanBG2,handles.meanBG3,handles.meanBG4,handles.meanBG5];
indN=find(mtx==min(mtx));
indX=indN(1);
%meanBkgCount=mtx(indX)
if(indX==1)PixelsBkgMin=sum(sum(NewImg1));
elseif(indX==2)PixelsBkgMin=sum(sum(NewImg2));NewImg1=NewImg2;
elseif(indX==3)PixelsBkgMin=sum(sum(NewImg3));NewImg1=NewImg3;
elseif(indX==4)PixelsBkgMin=sum(sum(NewImg4));NewImg1=NewImg4;
else PixelsBkgMin=sum(sum(NewImg5));NewImg1=NewImg5;
end
meanBGMn2=handles.meanBGMn2;
save meanBGMn2 meanBGMn2
handles.PixelsBkgMinPost=PixelsBkgMin;
%h1 = imfreehand;
BG=NewImg1;
%handles.meanBG=mean(mean(mean(handles.imvol(NewImg1==1))));
ee=edge(NewImg1,'canny');
ee=NewImg1;

[xE yE]=find(ee==1);
waitfor(xE);
hold on
aaa=plot(yE,xE,'r');
hold off;
%%
NewImg1=imdilate(handles.bwMin1,strel('disk',8))-imdilate(handles.bwMin1,strel('disk',6));
NewImg2=imdilate(handles.bwMin1,strel('disk',7))-imdilate(handles.bwMin1,strel('disk',5));
NewImg3=imdilate(handles.bwMin1,strel('disk',6))-imdilate(handles.bwMin1,strel('disk',4));
NewImg4=imdilate(handles.bwMin1,strel('disk',5))-imdilate(handles.bwMin1,strel('disk',3));
NewImg5=imdilate(handles.bwMin1,strel('disk',4))-imdilate(handles.bwMin1,strel('disk',2));

S1=regionprops(bwlabel(NewImg1),'Centroid');
S2=regionprops(bwlabel(NewImg2),'Centroid');
S3=regionprops(bwlabel(NewImg3),'Centroid');
S4=regionprops(bwlabel(NewImg4),'Centroid');
S5=regionprops(bwlabel(NewImg5),'Centroid');

cc1=round([S1.Centroid]);
cc2=round([S2.Centroid]);
cc3=round([S3.Centroid]);
cc4=round([S4.Centroid]);
cc5=round([S5.Centroid]);

% A=sum(sum(handles.imvolmn1(1:cc(2),1:cc(1))));
% B=sum(sum(handles.imvolmn1(1:cc(2),cc(1):end)));
% C=sum(sum(handles.imvolmn1(cc(2):end,1:cc(1))));
D1=sum(sum(handles.imvolmn1(cc1(2):end,cc1(1):end)));
D2=sum(sum(handles.imvolmn1(cc2(2):end,cc2(1):end)));
D3=sum(sum(handles.imvolmn1(cc3(2):end,cc3(1):end)));
D4=sum(sum(handles.imvolmn1(cc4(2):end,cc4(1):end)));
D5=sum(sum(handles.imvolmn1(cc5(2):end,cc5(1):end)));

NewImg1(1:cc1(2),1:cc1(1))=0;
NewImg1(1:cc1(2),cc1(1):end)=0;
NewImg1(cc1(2):end,1:cc1(1))=0;
NewImg2(1:cc2(2),1:cc2(1))=0;
NewImg2(1:cc2(2),cc2(1):end)=0;
NewImg2(cc2(2):end,1:cc2(1))=0;
NewImg3(1:cc3(2),1:cc3(1))=0;
NewImg3(1:cc3(2),cc3(1):end)=0;
NewImg3(cc3(2):end,1:cc3(1))=0;
NewImg4(1:cc4(2),1:cc4(1))=0;
NewImg4(1:cc4(2),cc4(1):end)=0;
NewImg4(cc4(2):end,1:cc4(1))=0;
NewImg5(1:cc5(2),1:cc5(1))=0;
NewImg5(1:cc5(2),cc5(1):end)=0;
NewImg5(cc5(2):end,1:cc5(1))=0;
% NewImg1(cc1(2)+15:end,:)=0;
% NewImg1(:,1:cc1(1)+5)=0;
% NewImg2(cc2(2)+15:end,:)=0;
% NewImg2(:,1:cc2(1)+5)=0;
% NewImg3(cc3(2)+15:end,:)=0;
% NewImg3(:,1:cc3(1)+5)=0;
% NewImg4(cc4(2)+15:end,:)=0;
% NewImg4(:,1:cc4(1)+5)=0;
% NewImg5(cc5(2)+15:end,:)=0;
% NewImg5(:,1:cc5(1)+5)=0;
NewImg6=NewImg1|NewImg2|NewImg3|NewImg4|NewImg5;


handles.imvolmn11=handles.min_img1;
handles.imvolmn11(NewImg6==0)=0;
handles.meanBG1=mean(mean(handles.max_img1(NewImg1==1)));
handles.meanBG2=mean(mean(handles.max_img1(NewImg2==1)));
handles.meanBG3=mean(mean(handles.max_img1(NewImg3==1)));
handles.meanBG4=mean(mean(handles.max_img1(NewImg4==1)));
handles.meanBG5=mean(mean(handles.max_img1(NewImg5==1)));

%handles.meanBGMx2=(handles.meanBG1+handles.meanBG2+handles.meanBG3+handles.meanBG4+handles.meanBG5)/5
handles.meanBGMx2=min([handles.meanBG1,handles.meanBG2,handles.meanBG3,handles.meanBG4,handles.meanBG5]);
mtx=[handles.meanBG1,handles.meanBG2,handles.meanBG3,handles.meanBG4,handles.meanBG5];
indN=find(mtx==min(mtx));
indX=indN(1);
%meanBkgMaxCount=mtx(indX)
if(indX==1)PixelsBkgMax=sum(sum(NewImg1));
elseif(indX==2)PixelsBkgMax=sum(sum(NewImg2));
elseif(indX==3)PixelsBkgMax=sum(sum(NewImg3));
elseif(indX==4)PixelsBkgMax=sum(sum(NewImg4));
else PixelsBkgMax=sum(sum(NewImg5));
end
handles.PixelsBkgMaxPost=PixelsBkgMax;
%%
%handles.meanBG=max([handles.meanBG1+handles.meanBG2+handles.meanBG3+handles.meanBG4+handles.meanBG5]);
handles.imvolmn11=handles.min_img1;
handles.imvolmn11(NewImg1==0)=0;

%waitfor(aaa);
%
    %handles.max_img1=handles.max_img1-handles.meanBGMx;
    PixelNumMaxPost=sum(sum(handles.bw));
    %handles.min_img1=handles.min_img1-handles.meanBGMn;
    PixelNumMinPost=sum(sum(handles.bwMin1));
    TotalBGmaxPost=sum(sum(sum(handles.max_img1(handles.bw==1))));
    TotalBGminPost=sum(sum(sum(handles.min_img1(handles.bwMin1==1))));
   waitfor(handles.bw);

    handles.bw =uint16(handles.bw);
    % creat mask
    handles.max_mask=sum(handles.All_masks1,3);
    handles.max_mask=uint16(im2bw(handles.max_mask,0.1));
    for i=1:16
    handles.imvol1(:,:,i) = (handles.max_mask.*handles.imvol_2(:,:,i));
    end
    % calculate mean  count/pixel
     handles.mnzs = mean(nonzeros(handles.imvol1));
% calculate lung uptake
    mb=msgbox('Select Manually Lung ROI (Post)','select ROI') ;
    waitfor(mb);
    axes(handles.axes3);
    imagesc(sum(handles.imvol_2,3));colormap(jet),colorbar;
    % draw ROI
    hh = imrect;
    handles.bw11=createMask(hh);
    handles.bw11 =uint16(handles.bw11);
   %close Figure 4
    %close Figure 3
    %close Figure 31
    % creat mask
    for i=1:16
    handles.imvol11(:,:,i) = (handles.bw11.*handles.imvol_2(:,:,i));
    end

handles.mnzs11 = mean(nonzeros(handles.imvol11));
handles.heart2lungpost = handles.mnzs11/handles.mnzs;
%estimates the area of the objects in binary image handles.bw and handles.bw1.
handles.A1 =bwarea(handles.bw);
handles.A2 =bwarea(handles.bw1);
% Max area ratio 
handles.TIDmax = handles.A1/handles.A2;
% Min area ratio
handles.A1 =bwarea(handles.bwMin1);
handles.A2 =bwarea(handles.bwMin2);
handles.TIDmin = handles.A1/handles.A2;
mb=msgbox('post part is done, show results now');
waitfor(mb);
guidata(hObject, handles);

% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
%% Pre Part %%
%read images (pre-chemo)
load info2 info2;
tag11=0;
save prepost1 tag11
%butterworth smoothing

     % view
    %figure (2), imshow(sum(handles.imvol2,3),[]);
    % draw ROI
%% Background Subtraction Pre
for i=1:info2.NumberOfFrames
    mean_val(i)=mean(mean(handles.imvol2(:,:,i)));
end
%mx_val=max(max(mean_val));
%ind_max=find(mx_val==mean_val);
%maxImg=handles.imvol2(:,:,ind_max);

 %handles.imvolmx=mean(handles.imvol2,3);
  %mb=msgbox("Please draw the background region","draw bkg");
  %waitfor(mb);
  %axes(handles.axes4);
  
  %imagesc(handles.imvolmx); colormap(jet),colorbar ;
  %  h1 = imfreehand;
  %  BG=createMask(h1);
  %  handles.meanBG=mean(mean(mean(handles.imvolmx(BG==1))));
  %  waitfor(BG);
    %close;
    clear BG h1 handles.imvolmx
  %% max - min of ROI Pre
%  axes(handles.axes4)
[handles.All_masks2,handles.smoothedPoly21, handles.smoothedPoly22, handles.max_img2,handles.min_img2,handles.imvolmx2,handles.imvolmn2,handles.bw1, handles.bwMin2, handles.area1Pre, handles.area2Pre, handles.ratePre,handles.minLongDIVmaxLPre, handles.minShortDIVmaxLPre,handles.AverageDivPre, handles.circularityMaxPre, handles.circularityMinPre,handles.ElongationMaxPre,handles.ElongationMinPre,sp_pre]=max_min_MUGA(handles.imvol2_2,0);
save sp_pre sp_pre;
   % handles.meanBGmax=mean(mean(mean(handles.max_img2(handles.bw1==1))));
   % handles.meanBGmin=mean(mean(mean(handles.min_img2(handles.bwMin2==1))));
axes(handles.axes5);axis tight;
imagesc(sum(handles.imvol2_2,3)); colormap(jet),colorbar ;


NewImg1=imdilate(handles.bw1,strel('disk',8))-imdilate(handles.bw1,strel('disk',6));
NewImg2=imdilate(handles.bw1,strel('disk',7))-imdilate(handles.bw1,strel('disk',5));
NewImg3=imdilate(handles.bw1,strel('disk',6))-imdilate(handles.bw1,strel('disk',4));
NewImg4=imdilate(handles.bw1,strel('disk',5))-imdilate(handles.bw1,strel('disk',3));
NewImg5=imdilate(handles.bw1,strel('disk',4))-imdilate(handles.bw1,strel('disk',2));

S1=regionprops(bwlabel(NewImg1),'Centroid');
S2=regionprops(bwlabel(NewImg2),'Centroid');
S3=regionprops(bwlabel(NewImg3),'Centroid');
S4=regionprops(bwlabel(NewImg4),'Centroid');
S5=regionprops(bwlabel(NewImg5),'Centroid');

cc1=round([S1.Centroid]);
cc2=round([S2.Centroid]);
cc3=round([S3.Centroid]);
cc4=round([S4.Centroid]);
cc5=round([S5.Centroid]);

D1=sum(sum(handles.imvolmn2(cc1(2):end,cc1(1):end)));
D2=sum(sum(handles.imvolmn2(cc2(2):end,cc2(1):end)));
D3=sum(sum(handles.imvolmn2(cc3(2):end,cc3(1):end)));
D4=sum(sum(handles.imvolmn2(cc4(2):end,cc4(1):end)));
D5=sum(sum(handles.imvolmn2(cc5(2):end,cc5(1):end)));

NewImg1(1:cc1(2),1:cc1(1))=0;
NewImg1(1:cc1(2),cc1(1):end)=0;
NewImg1(cc1(2):end,1:cc1(1))=0;
NewImg2(1:cc2(2),1:cc2(1))=0;
NewImg2(1:cc2(2),cc2(1):end)=0;
NewImg2(cc2(2):end,1:cc2(1))=0;
NewImg3(1:cc3(2),1:cc3(1))=0;
NewImg3(1:cc3(2),cc3(1):end)=0;
NewImg3(cc3(2):end,1:cc3(1))=0;
NewImg4(1:cc4(2),1:cc4(1))=0;
NewImg4(1:cc4(2),cc4(1):end)=0;
NewImg4(cc4(2):end,1:cc4(1))=0;
NewImg5(1:cc5(2),1:cc5(1))=0;
NewImg5(1:cc5(2),cc5(1):end)=0;
NewImg5(cc5(2):end,1:cc5(1))=0;
%NewImg1(cc1(2)+15:end,:)=0;
%NewImg1(:,1:cc1(1)+5)=0;
%NewImg2(cc2(2)+15:end,:)=0;
%NewImg2(:,1:cc2(1)+5)=0;
%NewImg3(cc3(2)+15:end,:)=0;
%NewImg3(:,1:cc3(1)+5)=0;
%NewImg4(cc4(2)+15:end,:)=0;
%NewImg4(:,1:cc4(1)+5)=0;
%NewImg5(cc5(2)+15:end,:)=0;
%NewImg5(:,1:cc5(1)+5)=0;
NewImg6=NewImg1|NewImg2|NewImg3|NewImg4|NewImg5;
% Vec=[D1 D2 D3 D4 D5];
% x=find(Vec==min(Vec)); 
% if(x(1)==1) 
%     NewImg1(1:cc1(2),1:cc1(1))=0;
%     NewImg1(1:cc1(2),cc1(1):end)=0;
%     NewImg1(cc1(2):end,1:cc1(1))=0;
% elseif(x(1)==2) 
%     NewImg1=NewImg2;
%     NewImg1(1:cc2(2),1:cc2(1))=0;
%     NewImg1(1:cc2(2),cc2(1):end)=0;
%     NewImg1(cc2(2):end,1:cc2(1))=0;
% elseif (x(1)==3) 
%     NewImg1=NewImg3;
%     NewImg1(1:cc3(2),1:cc3(1))=0;
%     NewImg1(1:cc3(2),cc3(1):end)=0;
%     NewImg1(cc3(2):end,1:cc3(1))=0;
% elseif (x(1)==4) 
%     NewImg1=NewImg4;
%     NewImg1(1:cc4(2),1:cc4(1))=0;
%     NewImg1(1:cc4(2),cc4(1):end)=0;
%     NewImg1(cc4(2):end,1:cc4(1))=0;
% else
%     NewImg1=NewImg5;
%     NewImg1(1:cc5(2),1:cc5(1))=0;
%     NewImg1(1:cc5(2),cc5(1):end)=0;
%     NewImg1(cc5(2):end,1:cc5(1))=0;
% end
handles.imvolmn11=handles.min_img2;
handles.imvolmn11(NewImg6==0)=0;

handles.meanBG1=mean(mean(handles.min_img2(NewImg1==1)));
handles.meanBG2=mean(mean(handles.min_img2(NewImg2==1)));
handles.meanBG3=mean(mean(handles.min_img2(NewImg3==1)));
handles.meanBG4=mean(mean(handles.min_img2(NewImg4==1)));
handles.meanBG5=mean(mean(handles.min_img2(NewImg5==1)));

%handles.meanBGMn=(handles.meanBG1+handles.meanBG2+handles.meanBG3+handles.meanBG4+handles.meanBG5)/5
handles.meanBGMn=min([handles.meanBG1,handles.meanBG2,handles.meanBG3,handles.meanBG4,handles.meanBG5]);
meanBGMn=handles.meanBGMn;
save meanBGMn meanBGMn
handles.imvolmn11=handles.min_img2;
handles.imvolmn11(NewImg1==0)=0;
mtx=[handles.meanBG1,handles.meanBG2,handles.meanBG3,handles.meanBG4,handles.meanBG5];
indN=find(mtx==min(mtx));
indX=indN(1);
%meanBkgMaxCount=mtx(indX)
if(indX==1)PixelsBkgMin=sum(sum(NewImg1));
elseif(indX==2)PixelsBkgMin=sum(sum(NewImg2));NewImg1=NewImg2;
elseif(indX==3)PixelsBkgMin=sum(sum(NewImg3));NewImg1=NewImg3;
elseif(indX==4)PixelsBkgMin=sum(sum(NewImg4));NewImg1=NewImg4;
else PixelsBkgMin=sum(sum(NewImg5));NewImg1=NewImg5;
end
handles.PixelsBkgMinPre=PixelsBkgMin;
%h1 = imfreehand;
%handles.meanBG=mean(mean(mean(handles.imvol2(NewImg1==1))))
ee=edge(NewImg1,'canny');
ee=NewImg1;

[xE yE]=find(ee==1);
waitfor(xE);
hold on
aaa=plot(yE,xE,'r');
hold off;
%%
NewImg1=imdilate(handles.bwMin2,strel('disk',8))-imdilate(handles.bwMin2,strel('disk',6));
NewImg2=imdilate(handles.bwMin2,strel('disk',7))-imdilate(handles.bwMin2,strel('disk',5));
NewImg3=imdilate(handles.bwMin2,strel('disk',6))-imdilate(handles.bwMin2,strel('disk',4));
NewImg4=imdilate(handles.bwMin2,strel('disk',5))-imdilate(handles.bwMin2,strel('disk',3));
NewImg5=imdilate(handles.bwMin2,strel('disk',4))-imdilate(handles.bwMin2,strel('disk',2));

S1=regionprops(bwlabel(NewImg1),'Centroid');
S2=regionprops(bwlabel(NewImg2),'Centroid');
S3=regionprops(bwlabel(NewImg3),'Centroid');
S4=regionprops(bwlabel(NewImg4),'Centroid');
S5=regionprops(bwlabel(NewImg5),'Centroid');

cc1=round([S1.Centroid]);
cc2=round([S2.Centroid]);
cc3=round([S3.Centroid]);
cc4=round([S4.Centroid]);
cc5=round([S5.Centroid]);

D1=sum(sum(handles.imvolmn2(cc1(2):end,cc1(1):end)));
D2=sum(sum(handles.imvolmn2(cc2(2):end,cc2(1):end)));
D3=sum(sum(handles.imvolmn2(cc3(2):end,cc3(1):end)));
D4=sum(sum(handles.imvolmn2(cc4(2):end,cc4(1):end)));
D5=sum(sum(handles.imvolmn2(cc5(2):end,cc5(1):end)));

NewImg1(1:cc1(2),1:cc1(1))=0;
NewImg1(1:cc1(2),cc1(1):end)=0;
NewImg1(cc1(2):end,1:cc1(1))=0;
NewImg2(1:cc2(2),1:cc2(1))=0;
NewImg2(1:cc2(2),cc2(1):end)=0;
NewImg2(cc2(2):end,1:cc2(1))=0;
NewImg3(1:cc3(2),1:cc3(1))=0;
NewImg3(1:cc3(2),cc3(1):end)=0;
NewImg3(cc3(2):end,1:cc3(1))=0;
NewImg4(1:cc4(2),1:cc4(1))=0;
NewImg4(1:cc4(2),cc4(1):end)=0;
NewImg4(cc4(2):end,1:cc4(1))=0;
NewImg5(1:cc5(2),1:cc5(1))=0;
NewImg5(1:cc5(2),cc5(1):end)=0;
NewImg5(cc5(2):end,1:cc5(1))=0;
%NewImg1(cc1(2)+15:end,:)=0;
%NewImg1(:,1:cc1(1)+5)=0;
%NewImg2(cc2(2)+15:end,:)=0;
%NewImg2(:,1:cc2(1)+5)=0;
%NewImg3(cc3(2)+15:end,:)=0;
%NewImg3(:,1:cc3(1)+5)=0;
%NewImg4(cc4(2)+15:end,:)=0;
%NewImg4(:,1:cc4(1)+5)=0;
%NewImg5(cc5(2)+15:end,:)=0;
%NewImg5(:,1:cc5(1)+5)=0;
NewImg6=NewImg1|NewImg2|NewImg3|NewImg4|NewImg5;
handles.imvolmn11=handles.min_img2;
handles.imvolmn11(NewImg6==0)=0;

handles.meanBG1=mean(mean(handles.max_img2(NewImg1==1)));
handles.meanBG2=mean(mean(handles.max_img2(NewImg2==1)));
handles.meanBG3=mean(mean(handles.max_img2(NewImg3==1)));
handles.meanBG4=mean(mean(handles.max_img2(NewImg4==1)));
handles.meanBG5=mean(mean(handles.max_img2(NewImg5==1)));

%handles.meanBGMx=(handles.meanBG1+handles.meanBG2+handles.meanBG3+handles.meanBG4+handles.meanBG5)/5
handles.meanBGMx=min([handles.meanBG1,handles.meanBG2,handles.meanBG3,handles.meanBG4,handles.meanBG5]);
mtx=[handles.meanBG1,handles.meanBG2,handles.meanBG3,handles.meanBG4,handles.meanBG5];
indN=find(mtx==min(mtx));
indX=indN(1);
%meanBkgMaxCount=mtx(indX)
if(indX==1)PixelsBkgMax=sum(sum(NewImg1));
elseif(indX==2)PixelsBkgMax=sum(sum(NewImg2));
elseif(indX==3)PixelsBkgMax=sum(sum(NewImg3));
elseif(indX==4)PixelsBkgMax=sum(sum(NewImg4));
else PixelsBkgMax=sum(sum(NewImg5));
end
handles.PixelsBkgMaxPre=PixelsBkgMax;
%NewImg1(cc1(2)+15:end,:)=0;

    %handles.max_img2=handles.max_img2-handles.meanBGMx;
    PixelNumMaxPre=sum(sum(handles.bw1));
    %handles.min_img2=handles.min_img2-handles.meanBGMn;
    PixelNumMinPre=sum(sum(handles.bwMin2));
    TotalBGmaxPre=sum(sum(sum(handles.max_img2(handles.bw1==1))));
    TotalBGminPre=sum(sum(sum(handles.min_img2(handles.bwMin2==1))));
    %handles.meanBGmax=mean(mean(mean(handles.max_img1(handles.bw==1))));
    %handles.meanBGmin=mean(mean(mean(handles.min_img1(handles.bwMin1==1))));
    
    %LVEFpre=100*((TotalBGmaxPre-TotalBGminPre)/TotalBGmaxPre)
    
    %clear handles.meanBGmax handles.meanBGmin
    %handles.bw1 = ROI_semi_aut(handles.imvol2,2);
    waitfor(handles.bw1);
    %s11=regionprops(handles.bw1,'PixelList');
   %PixelList1=[s11.PixelList];
    handles.bw1 =uint16(handles.bw1);
    
    % creat mask
    handles.max_mask2=sum(handles.All_masks2,3);
    handles.max_mask2=uint16(im2bw(handles.max_mask2,0.1));
for i=1:16
handles.imvol3(:,:,i) = (handles.max_mask2.*handles.imvol2_2(:,:,i));
end
%% substraction of pre image
    %handles.imvol3=handles.imvol3-handles.meanBG;
    % calculate count/pixel 
    handles.mnzs1 = mean(nonzeros(handles.imvol3));
    % calculate mean  count/pixel ratio (post/pre), (to see wether increased TID is atributed to increased tc
%accomulqation.).
 % lung uptake
 mb=msgbox('Select Manually Lung ROI (Pre)','select roi');
 waitfor(mb);
 axes(handles.axes6);
 imagesc(sum(handles.imvol2_2,3));colormap(jet),colorbar ;
    % draw ROI
    hh = imrect;
    handles.bw22=createMask(hh);
    handles.bw22 =uint16(handles.bw22);
% close Figure 4
%     close Figure 3
%     close Figure 31
    % creat mask
    for i=1:16
    handles.imvol33(:,:,i) = (handles.bw22.*handles.imvol2_2(:,:,i));
    end
    %handles.imvol33=handles.imvol33-handles.meanBG;
    % calculate count/pixel 
    handles.mnzs22 = mean(nonzeros(handles.imvol33));
   
handles.heart2lungpre = handles.mnzs22/handles.mnzs1; %LHR in excel sheet
msgbox('pre part is done, go to post part');

guidata(hObject, handles);

% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function pushbutton3_Callback(hObject, eventdata, handles)
%Show Results
try
close 1
close 2
close 3
close 4
close Dialogue_box_pre_post
catch
end
% --- Executes on button press in pushbutton3.
%% Calculations
%% Median Filter %%
%sync and entro &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
load sp_post sp_post;
load sp_pre sp_pre;
hi=1; save hi hi;
tag11=1;
save prepost1 tag11
[handles.All_masksx,AA1,bb1,cc1,dd1,ee1,ff1,gg1,hh1,aa,bb,cc,dd,ee,ff,gg,hh2,II,JJ,spp]=max_min_MUGA3(handles.imvol_2,handles.meanBGMx,sp_post,[],[]);

tag11=0;
save prepost1 tag11
[handles.All_masksx2,AA1,bb1,cc1,dd1,ee1,ff1,gg1,hh1,aa,bb,cc,dd,ee,ff,gg,hh2,II,JJ,spp]=max_min_MUGA3(handles.imvol2_2,handles.meanBGMx,sp_pre,gg1,hh1);
hi=0; save hi hi;

%
    for i=1:16
     handles.imvol1x(:,:,i) = (handles.All_masks1(:,:,i).*handles.imvol_2(:,:,i));
     handles.imvol1xY(:,:,i) = (handles.All_masks2(:,:,i).*handles.imvol2_2(:,:,i));
    end
[TT, TT1,TT2,TT3,Weight1]=LVtimeActivityCurve(handles.imvol1x,2,0,[],1);
[TT, TT1,TT2,TT3,Weight2]=LVtimeActivityCurve(handles.imvol1xY,2,0,[],1);

%
for i=1:16
    if(Weight1>0)
        handles.All_masks1(:,:,i)=imdilate(handles.All_masks1(:,:,i),strel('disk',Weight1(i)));
        handles.All_masksx(:,:,i)=imdilate(handles.All_masksx(:,:,i),strel('disk',Weight1(i)))
    else
        handles.All_masks1(:,:,i)=imerode(handles.All_masks1(:,:,i),strel('disk',abs(Weight1(i))));
        handles.All_masksx(:,:,i)=imerode(handles.All_masksx(:,:,i),strel('disk',abs(Weight1(i))));
    end
    if(Weight2>0)
        handles.All_masks2(:,:,i)=imdilate(handles.All_masks2(:,:,i),strel('disk',Weight2(i)));
        handles.All_masksx2(:,:,i)=imdilate(handles.All_masksx2(:,:,i),strel('disk',Weight2(i)));
    else
        handles.All_masks2(:,:,i)=imerode(handles.All_masks2(:,:,i),strel('disk',abs(Weight2(i))));
        handles.All_masksx2(:,:,i)=imerode(handles.All_masksx2(:,:,i),strel('disk',abs(Weight2(i))));
    end
end
 handles.max_maskx=sum(handles.All_masksx,3);
 handles.max_maskx=uint16(im2bw(handles.max_maskx,0.1));
%
 handles.max_maskx2=sum(handles.All_masksx2,3);
 handles.max_maskx2=uint16(im2bw(handles.max_maskx2,0.1));
%
load MMWF_Kernel MMWF_Kernel
for i=1:16
    handles.imvol1E(:,:,i) = (handles.max_maskx.*handles.imvol_2(:,:,i));
    handles.imvol1m(:,:,i) = (handles.max_maskx.*handles.imvol(:,:,i));
    handles.imvol3E(:,:,i) = (handles.max_maskx2.*handles.imvol2_2(:,:,i));
    handles.imvol31(:,:,i) = (handles.max_maskx2.*handles.imvol2(:,:,i)); 
end
%figure,imshow(sum(handles.imvol3E,3),[])
%max(handles.imvol3E(:))
%hf=figure;
load energyPost energy numofIter
%  for i=1:16
%      ax=handles.imvol_1(:,:,i);
%      ax(edge(handles.All_masks1(:,:,i))==1)=0;
%      ha(i)=subplot(4,4,i),imshow(ax,[]);colormap('jet');
%  end
%  pos = get(ha, 'position');
%  dim = cellfun(@(x) x.*[1 1 0.5 0.5], pos, 'uni',0);
 for i=1:16
     imvol_for_count(:,:,i)=handles.imvol_2(:,:,i).*uint16(handles.All_masks1(:,:,i));
     Gray_count(i)=sum(sum(imvol_for_count(:,:,i)));
     pixel_count(i)=sum(sum(handles.All_masks1(:,:,i)));
 %   txt=strcat('E= ',num2str(energy(i)),', Itr= ',num2str(numofIter(i)),', GC= ',num2str(Gray_count(i)),', PC= ',num2str(pixel_count(i)));
 %   annotation(hf, 'textbox', dim{i}-0.02, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FitBoxToText','off');
 end
% sgtitle('Post');
save postInf energy numofIter Gray_count pixel_count
%hf = figure;
load energyPre energy numofIter
% for i=1:16
%     ax=handles.imvol2_2(:,:,i);
%     ax(edge(handles.All_masks2(:,:,i))==1)=0;
%     ha(i)=subplot(4,4,i),imshow(ax,[]);colormap('jet');
     
 %end
 %pos = get(ha, 'position');
 %dim = cellfun(@(x) x.*[1 1 0.5 0.5], pos, 'uni',0);
 for i=1:16
     imvol_for_count(:,:,i)=handles.imvol2_2(:,:,i).*uint16(handles.All_masks2(:,:,i));
     Gray_count(i)=sum(sum(imvol_for_count(:,:,i)));
     pixel_count(i)=sum(sum(handles.All_masks2(:,:,i)));
 %   txt=strcat('E= ',num2str(energy(i)),', Itr= ',num2str(numofIter(i)),', GC= ',num2str(Gray_count(i)),', PC= ',num2str(pixel_count(i)));
 %   annotation(hf, 'textbox', dim{i}-0.02, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FitBoxToText','off');
 end
%sgtitle('Pre');
save preInf energy numofIter Gray_count pixel_count
energy_Pcount_Gcount_iteration_To_excel; % call script to insert data into excel sheet energy
handles.post2pre = handles.mnzs/handles.mnzs1
meanBG=(handles.meanBGMx2+handles.meanBGMn2)/2;
%meanBG=min([handles.meanBGMx2,handles.meanBGMn2]);
handles.imvol1m=uint16(double(handles.imvol1m)-double(meanBG));
handles.imvol1E=uint16(double(handles.imvol1E)-double(meanBG));
tag=1;
save prepost tag
[,Sync_post]=computeEntropySynchronyNo(handles.imvol1m,-1,-1,0);
[Entro_post,]=computeEntropySynchronyNo(handles.imvol1E,-1,-1,10);
xEn=sum(handles.imvol1E,3);
A=xEn(xEn~=0);
ApEnPost= ApEn_slow(A, 2,1*std(A));
save A A
[BoundApEnPost,epsilonPost,LspsilonPost]=BoundedProcess(A);
A1=rad2deg(angle(fft(A)));
A2=0;
for i=1:size(A1,1)
if (A1(i)<0) 
A2=A2+(180-A1(i));
end
if (A1(i)>0)
A2=A2+(A1(i));
end
end
phasePost=sum(A2)/size(A1,1);
tag=0;
save prepost tag
meanBG=(handles.meanBGMx2+handles.meanBGMn2)/2;
%meanBG=min([handles.meanBGMx,handles.meanBGMn]);
handles.imvol31=uint16(double(handles.imvol31)-double(meanBG));
handles.imvol3E=uint16(double(handles.imvol3E)-double(meanBG));
[,Sync_pre]=computeEntropySynchronyNo(handles.imvol31,-1,-1,0);
[Entro_pre,]=computeEntropySynchronyNo(handles.imvol3E,-1,-1,10);
xEn=sum(handles.imvol3E,3);
A=xEn(xEn~=0);
save xEn xEn 
ApEnPre= ApEn_slow(A, 2, 1*std(A));
[BoundApEnPre,epsilonPre,LspsilonPre]=BoundedProcess(A);
A1=rad2deg(angle(fft(A)));
A2=0;
for i=1:size(A1,1)
if (A1(i)<0) 
A2=A2+(180-A1(i));
end
if (A1(i)>0)
A2=A2+(A1(i));
end
end
phasePre=sum(A2)/size(A1,1);
% close all previous figures
%close all
%close Figure 4
%    close Figure 3
%    close Figure 31
%% LVEF Phase
%%
[phase] = PhaseBkgFn(handles.imvol_2,handles.bw,sp_post,1);
[TotalBGmaxPostMXMN, TotalBGminPostMXMN ,indMaxMXMN,indMinMXMN,nmn]=LVtimeActivityCurve(phase,0,2,[],1);
%figure
PixelNumMaxPostMXMN=sum(sum(handles.All_masks1(:,:,indMaxMXMN(1))));
PixelNumMinPostMXMN=sum(sum(handles.All_masks1(:,:,indMinMXMN(1))));

TotalBGmaxPostMXMN=TotalBGmaxPostMXMN-(PixelNumMaxPostMXMN*handles.meanBGMn2);
TotalBGminPostMXMN=TotalBGminPostMXMN-(PixelNumMinPostMXMN*handles.meanBGMn2);
LVEFpostPhase=100*(((TotalBGmaxPostMXMN)-(TotalBGminPostMXMN))/(TotalBGmaxPostMXMN));

[phase] = PhaseBkgFn(handles.imvol2_2,handles.bw1,sp_pre,0);
[TotalBGmaxPreMXMN, TotalBGminPreMXMN ,indMaxMXMN,indMinMXMN,nmn]=LVtimeActivityCurve(phase,0,2,[],1);
figure
PixelNumMaxPreMXMN=sum(sum(handles.All_masks1(:,:,indMaxMXMN(1))));
PixelNumMinPreMXMN=sum(sum(handles.All_masks1(:,:,indMinMXMN(1))));

TotalBGmaxPreMXMN=TotalBGmaxPreMXMN-(PixelNumMaxPreMXMN*handles.meanBGMn2);
TotalBGminPreMXMN=TotalBGminPreMXMN-(PixelNumMinPreMXMN*handles.meanBGMn2);
LVEFprePhase=100*(((TotalBGmaxPreMXMN)-(TotalBGminPreMXMN))/(TotalBGmaxPreMXMN));
%%
%% show results
%% draw LV time activity curve for post image
%figure
%subplot(1,2,1)
handles.max_mask=sum(handles.All_masks1,3);
handles.max_mask=uint16(im2bw(handles.max_mask,0.1));
handles.max_mask2=sum(handles.All_masks2,3);
handles.max_mask2=uint16(im2bw(handles.max_mask2,0.1));
% handles.imvolx=handles.imvol;
% handles.imvolx2=handles.imvol2;
handles.imvolxY=uint16(double(handles.imvol_2)-double(handles.meanBGMn2));
handles.imvolxY2=uint16(double(handles.imvol2_2)-double(handles.meanBGMn));
handles.imvolx=handles.imvol_2;
handles.imvolx2=handles.imvol2_2;
for i=1:16
    handles.imvol1x(:,:,i) = (handles.All_masks1(:,:,i).*handles.imvolx(:,:,i));
    handles.imvol3x(:,:,i) = (handles.All_masks2(:,:,i).*handles.imvolx2(:,:,i));
    handles.imvol1xY(:,:,i) = (handles.All_masks1(:,:,i).*handles.imvolxY(:,:,i));
    handles.imvol3xY(:,:,i) = (handles.All_masks2(:,:,i).*handles.imvolxY2(:,:,i));
 end
[TotalBGmaxPost1, TotalBGminPost1 ,indMax,indMin,nmn,yy]=LVtimeActivityCurve(handles.imvol1x,1,0,[],1);
%% compute RFV, RFT, LVER, LVFR post
load info2 info2
FrameTime=info2.GatedInformationSequence.Item_1.DataInformationSequence.Item_1.FrameTime;
xTime=FrameTime:FrameTime:16*FrameTime;
xTime=xTime/1000;
yy=yy-double(handles.meanBGMn2);
Apoint=yy(indMin-4);
Bpoint=yy(indMin);
Cpoint=yy(indMin+5);
T1=xTime(indMin-4);
T2=xTime(indMin);
T3=xTime(indMin+5);
RFT_Post=T3-T2;
RFV_Post=Cpoint-Bpoint;
LVFR_Post=((Cpoint-Bpoint)/(T3-T2))/Apoint;
LVER_Post=((Apoint-Bpoint)/(T2-T1))/Apoint;
%%
% compute entropy, apen and bounded entropy based on max and min images only
handles.imvol1E1(:,:,1)=handles.imvol1x(:,:,indMin);
handles.imvol1E1(:,:,2)=handles.imvol1x(:,:,indMax);
handles.imvol1m1(:,:,1)=handles.imvol1x(:,:,indMin);
handles.imvol1m1(:,:,2)=handles.imvol1x(:,:,indMax);

[Entro_PostMXMN,]=computeEntropySynchronyNo(handles.imvol1E1,indMax,indMin,0);
[,Synchrony_PostMXMN]=computeEntropySynchronyNo(handles.imvol1m1,indMax,indMin,0);
xEn=sum(handles.imvol1E1,3);
A=xEn(xEn~=0);
ApEnPostMXMN= ApEn_slow(A, 2,1*std(A));
[BoundApEnPostMXMN,epsilonPostMXMN,LspsilonPostMXMN]=BoundedProcess(A);

[TotalBGmaxPostY1, TotalBGminPostY1 ,indMaxY,indMinY,nmn]=LVtimeActivityCurve(handles.imvol1xY,1,handles.imvol1x,[],0);
%handles.All_masks1(:,:,indMax)=imdilate(handles.All_masks1(:,:,indMax),strel('disk',2));
%handles.All_masks1(:,:,indMin)=imdilate(handles.All_masks1(:,:,indMin),strel('disk',2));

PixelNumMaxPost=sum(sum(handles.All_masks1(:,:,indMax(1))));%max count in excel sheet
PixelNumMinPost=sum(sum(handles.All_masks1(:,:,indMin(1))));%min count in excel sheet
TotalBGmaxPost=TotalBGmaxPost1-(PixelNumMaxPost*handles.meanBGMn2); %max count in excel sheet
TotalBGminPost=TotalBGminPost1-(PixelNumMinPost*handles.meanBGMn2); %min count in excel sheet
%
PixelNumMaxPostY=sum(sum(handles.All_masks1(:,:,indMaxY(1))));
PixelNumMinPostY=sum(sum(handles.All_masks1(:,:,indMinY(1))));
TotalBGmaxPostY=TotalBGmaxPostY1-(PixelNumMaxPostY*handles.meanBGMn2);
TotalBGminPostY=TotalBGminPostY1-(PixelNumMinPostY*handles.meanBGMn2);

%compute LVEF based on max and min ROIs only
A1=uint16(zeros(size(handles.imvol1x)));A2=A1;
for i=1:16
    A1(:,:,i)=rad2deg(angle(fftshift(fft2(handles.imvol1x(:,:,i)))));
    if (A1(:,:,i)<0) 
        A2(:,:,i)=(180-A1(:,:,i));
    end
    if (A1(:,:,i)>0)
        A2(:,:,i)=(A1(:,:,i));
    end
end
%[TotalBGmaxPostMXMN, TotalBGminPostMXMN
%,indMaxMXMN,indMinMXMN,nmn]=LVtimeActivityCurve(A1,1,2,[],0);.

%%
%
%LVEFpost=100*(((TotalBGmaxPost-PixelNumMaxPost*handles.meanBG)-(TotalBGminPost-PixelNumMinPost*handles.meanBG))/(TotalBGmaxPost-PixelNumMaxPost*handles.meanBG))
LVEFpost=100*(((TotalBGmaxPost)-(TotalBGminPost))/(TotalBGmaxPost));
LVEFpost2=100*(((TotalBGmaxPostY)-(TotalBGminPostY))/(TotalBGmaxPostY));
%subplot(1,2,2)
[TotalBGmaxPre1, TotalBGminPre1,indMax,indMin,nmn,yy]=LVtimeActivityCurve(handles.imvol3x,2,0,[],1);
%% RFV_Pre, RFT_Pre, LVER_Pre,LVFR_Pre
load info info
FrameTime=info.GatedInformationSequence.Item_1.DataInformationSequence.Item_1.FrameTime;
xTime=FrameTime:FrameTime:16*FrameTime;
xTime=xTime/1000;
yy=yy-double(handles.meanBGMn2);
ApointPre=yy(indMin-4);
BpointPre=yy(indMin);
CpointPre=yy(indMin+5);
T1Pre=xTime(indMin-4);
T2Pre=xTime(indMin);
T3Pre=xTime(indMin+5);
RFT_Pre=T3Pre-T2Pre;
RFV_Pre=CpointPre-BpointPre;
LVFR_Pre=((CpointPre-BpointPre)/(T3Pre-T2Pre))/ApointPre
LVER_Pre=((ApointPre-BpointPre)/(T2Pre-T1Pre))/ApointPre
%%
% compute entropy, apen and bounded entropy based on max and min images only
handles.imvol3x1(:,:,1)=handles.imvol3x(:,:,indMin);
handles.imvol3x1(:,:,2)=handles.imvol3x(:,:,indMax);
handles.imvol311(:,:,1)=handles.imvol3x(:,:,indMin);
handles.imvol311(:,:,2)=handles.imvol3x(:,:,indMax);
[Entro_PreMXMN,]=computeEntropySynchronyNo(handles.imvol3x1,indMax,indMin,0);
[,Synchrony_PreMXMN]=computeEntropySynchronyNo(handles.imvol311,indMax,indMin,0);

xEn=sum(handles.imvol1E1,3);
A=xEn(xEn~=0);
ApEnPreMXMN= ApEn_slow(A, 2,1*std(A));
[BoundApEnPreMXMN,epsilonPreMXMN,LspsilonPreMXMN]=BoundedProcess(A);

[TotalBGmaxPreY1, TotalBGminPreY1,indMaxY,indMinY,nmn]=LVtimeActivityCurve(handles.imvol3xY,2,handles.imvol3x,[],0);
%handles.All_masks1(:,:,indMax)=imdilate(handles.All_masks1(:,:,indMax),strel('disk',2));
%handles.All_masks1(:,:,indMin)=imdilate(handles.All_masks1(:,:,indMin),strel('disk',2));
PixelNumMaxPre=sum(sum(handles.All_masks2(:,:,indMax(1))));% max pixel num in excel sheet
% indMax
% indMin
PixelNumMinPre=sum(sum(handles.All_masks2(:,:,indMin(1)))) ;% min pixel num in excel sheet
TotalBGmaxPre=TotalBGmaxPre1-(PixelNumMaxPre*handles.meanBGMn);%max count in excel sheet
TotalBGminPre=TotalBGminPre1-(PixelNumMinPre*handles.meanBGMn);%min count in excel sheet

PixelNumMaxPreY=sum(sum(handles.All_masks2(:,:,indMaxY(1))));
PixelNumMinPreY=sum(sum(handles.All_masks2(:,:,indMinY(1))));
TotalBGmaxPreY=TotalBGmaxPreY1-(PixelNumMaxPreY*handles.meanBGMn);
TotalBGminPreY=TotalBGminPreY1-(PixelNumMinPreY*handles.meanBGMn);
%LVEFpre=100*(((TotalBGmaxPre-PixelNumMaxPre*handles.meanBG)-(TotalBGminPre-PixelNumMinPre*handles.meanBG))/(TotalBGmaxPre-PixelNumMaxPre*handles.meanBG))
LVEFpre=100*(((TotalBGmaxPre-TotalBGminPre))/(TotalBGmaxPre));
LVEFpre2=100*(((TotalBGmaxPreY-TotalBGminPreY))/(TotalBGmaxPreY));
%compute LVEF based on phase image only
A1=uint16(zeros(size(handles.imvol3x)));A2=A1;
for i=1:16
    A1(:,:,i)=rad2deg(angle(fftshift(fft2(handles.imvol3x(:,:,i)))));
    if (A1(:,:,i)<0) 
        A2(:,:,i)=(180+A1(:,:,i));
    end
    if (A1(:,:,i)>0)
        A2(:,:,i)=(A1(:,:,i));
    end
end
%[TotalBGmaxPreMXMN, TotalBGminPreMXMN ,indMaxMXMN,indMinMXMN,nmn]=LVtimeActivityCurve(A1,2,2,[],0);


close;
%% save
%Extract some information from post image into workspace
load info info;
PatientID=info.PatientID; 
PatientAge=info.PatientAge;
 PatientWeight=info.PatientWeight;
 AcquisitionDate=info.AcquisitionDate;
 Manufacturer=info.Manufacturer;
 HeartRate=info.HeartRate;
 FrameTime=info.GatedInformationSequence.Item_1.DataInformationSequence.Item_1.FrameTime;
 LowRRValue=info.GatedInformationSequence.Item_1.DataInformationSequence.Item_1.LowRRValue;
 HighRRValue=info.GatedInformationSequence.Item_1.DataInformationSequence.Item_1.HighRRValue;%(mean RR duration) in excel sheet
 IntervalsAcquired=info.GatedInformationSequence.Item_1.DataInformationSequence.Item_1.IntervalsAcquired;% Accepted beats in excel sheet
 IntervalsRejected=info.GatedInformationSequence.Item_1.DataInformationSequence.Item_1.IntervalsRejected; %  rejected beats in excel sheet
% info of pre image
load info2 info2;
PatientAge2=info2.PatientAge;

 PatientWeight2=info2.PatientWeight;
 AcquisitionDate2=info2.AcquisitionDate;
 HeartRate2=info2.HeartRate;
 FrameTime2=info2.GatedInformationSequence.Item_1.DataInformationSequence.Item_1.FrameTime;
 LowRRValue2=info2.GatedInformationSequence.Item_1.DataInformationSequence.Item_1.LowRRValue;
 HighRRValue2=info2.GatedInformationSequence.Item_1.DataInformationSequence.Item_1.HighRRValue; % (mean RR duration) in excel sheet
 IntervalsAcquired2=info2.GatedInformationSequence.Item_1.DataInformationSequence.Item_1.IntervalsAcquired; %  Accepted beats in excel sheet
 IntervalsRejected2=info2.GatedInformationSequence.Item_1.DataInformationSequence.Item_1.IntervalsRejected; %  rejected beats in excel sheet
area1Post=handles.area1Post;area2Post=handles.area2Post; 
AverageDivPost=handles.AverageDivPost; circularityMaxPost=handles.circularityMaxPost;
circularityMinPost=handles.circularityMinPost; ElongationMaxPost=handles.ElongationMaxPost;
ElongationMinPost=handles.ElongationMinPost; heart2lungpost=handles.heart2lungpost;
minLongDIVmaxLPost=handles.minLongDIVmaxLPost; minShortDIVmaxLPost=handles.minShortDIVmaxLPost;
post2pre=handles.post2pre; ratePost=handles.ratePost;TIDmax=handles.TIDmax; TIDmin=handles.TIDmin;
PixelsBkgMaxPost=handles.PixelsBkgMaxPost;
PixelsBkgMinPost=handles.PixelsBkgMinPost;
meanBGMx2=handles.meanBGMx2; meanBGMn2=handles.meanBGMn2;

save post AcquisitionDate area1Post area2Post AverageDivPost circularityMaxPost circularityMinPost ElongationMaxPost ...
    ElongationMinPost Entro_post ApEnPost FrameTime heart2lungpost HeartRate HighRRValue IntervalsAcquired IntervalsRejected LowRRValue...
    LVEFpost Manufacturer minLongDIVmaxLPost minShortDIVmaxLPost PatientAge PatientID PatientWeight PixelNumMaxPost PixelNumMinPost...
    post2pre ratePost Sync_post TIDmax TIDmin TotalBGmaxPost TotalBGmaxPost1 TotalBGminPost TotalBGminPost1 phasePost PixelsBkgMaxPost...
    PixelsBkgMinPost meanBGMx2 meanBGMn2 BoundApEnPost epsilonPost LspsilonPost ApEnPostMXMN Entro_PostMXMN BoundApEnPostMXMN...
    LVEFpostPhase Synchrony_PostMXMN RFT_Post RFV_Post LVFR_Post LVER_Post

area1Pre=handles.area1Pre; area2Pre=handles.area2Pre; AverageDivPre=handles.AverageDivPre;
circularityMaxPre=handles.circularityMaxPre; circularityMinPre=handles.circularityMinPre;
ElongationMaxPre=handles.ElongationMaxPre; ElongationMinPre=handles.ElongationMinPre;
heart2lungpre=handles.heart2lungpre; minLongDIVmaxLPre=handles.minLongDIVmaxLPre; minShortDIVmaxLPre=handles.minShortDIVmaxLPre; 
post2pre=handles.post2pre; ratePre=handles.ratePre; TIDmax=handles.TIDmax; TIDmin=handles.TIDmin;

PixelsBkgMaxPre=handles.PixelsBkgMaxPre;
PixelsBkgMinPre=handles.PixelsBkgMinPre;
meanBGMx=handles.meanBGMx; meanBGMn=handles.meanBGMn;

save pre AcquisitionDate2 area1Pre area2Pre AverageDivPre circularityMaxPre circularityMinPre ElongationMaxPre ...
    ElongationMinPre Entro_pre ApEnPre FrameTime2 heart2lungpre HeartRate2 HighRRValue2 IntervalsAcquired2 IntervalsRejected2 LowRRValue2...
    LVEFpre Manufacturer minLongDIVmaxLPre minShortDIVmaxLPre PatientAge2 PatientID PatientWeight2 PixelNumMaxPre PixelNumMinPre...
    post2pre ratePre Sync_pre TIDmax TIDmin TotalBGmaxPre TotalBGmaxPre1 TotalBGminPre TotalBGminPre1 phasePre PixelsBkgMaxPre PixelsBkgMinPre...
    meanBGMx meanBGMn BoundApEnPre epsilonPre LspsilonPre ApEnPreMXMN Entro_PreMXMN BoundApEnPreMXMN LVEFprePhase Synchrony_PreMXMN...
    RFT_Pre RFV_Pre LVFR_Pre LVER_Pre
max_img1=handles.max_img1;imvolmx1=handles.imvolmx1;min_img1=handles.min_img1;
imvolmn1=handles.imvolmn1;max_img2=handles.max_img2;imvolmx2=handles.imvolmx2;
min_img2=handles.min_img2;imvolmn2=handles.imvolmn2;smoothedPoly11=handles.smoothedPoly11;
smoothedPoly12=handles.smoothedPoly12; smoothedPoly21=handles.smoothedPoly21; smoothedPoly22=handles.smoothedPoly22;
save deletedInfo max_img1 imvolmx1 min_img1 imvolmn1 max_img2 imvolmx2 min_img2 imvolmn2 smoothedPoly11 smoothedPoly12 smoothedPoly21 smoothedPoly22;
Dialogue_box_pre_post
guidata(hObject, handles);
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I=imread('help.png');
figure
imagesc(I);


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
imvolx=sum(handles.imvol_2,3);
L1=get(handles.slider1,'value');
L2=get(handles.slider2,'value');
imshow(im2uint8(mat2gray(imvolx))) , hold all,colormap(jet),colorbar;
try
caxis([L1 L2]);
catch
   b=msgbox('Wrong scale, right bar must be greater than left one');
    set(handles.slider1,'value',0);
    set(handles.slider2,'value',255);
end
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
axes(handles.axes1)
imvolx=sum(handles.imvol_2,3);
L1=get(handles.slider1,'value');
L2=get(handles.slider2,'value');
imshow(im2uint8(mat2gray(imvolx))) , hold all,colormap(jet),colorbar;
try
caxis([L1 L2]);
catch
   b=msgbox('Wrong scale, right bar must be greater than left one');
    set(handles.slider1,'value',0);
    set(handles.slider2,'value',255);
end
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
axes(handles.axes4)
imvolx=sum(handles.imvol2_2,3);
L1=get(handles.slider3,'value');
L2=get(handles.slider4,'value');
imshow(im2uint8(mat2gray(imvolx))) , hold all,colormap(jet),colorbar;
try
caxis([L1 L2]);
catch
   b=msgbox('Wrong scale, right bar must be greater than left one');
    set(handles.slider3,'value',0);
    set(handles.slider4,'value',255);
end
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
axes(handles.axes4)
imvolx=sum(handles.imvol2_2,3);
L1=get(handles.slider3,'value');
L2=get(handles.slider4,'value');
imshow(im2uint8(mat2gray(imvolx))) , hold all,colormap(jet),colorbar;
try
    caxis([L1 L2]);
catch
   b=msgbox('Wrong scale, right bar must be greater than left one');
    set(handles.slider3,'value',0);
    set(handles.slider4,'value',255);
end
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


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
try
close 1
close 2
close 3
close 4
close Dialogue_box_pre_post
catch
end
x2 = inputdlg('Pick Pre image:',...
              'Define Image', [1]);
 handles.name2= (x2{:}); % image number
handles.imvol2 = squeeze(dicomread(handles.name2));
info2 = dicominfo(handles.name2);
save info2 info2;
load MMWF_Kernel MMWF_Kernel
 for i=1:1:info2.NumberOfFrames
    %[x_mean,x_median,x_min,x_wiener,x_mmwf,x_mmwf_star]=MMWF_2D(handles.imvol2(:,:,i),MMWF_Kernel);
   % handles.imvol2_1(:,:,i)=uint16(x_mmwf);h=ones(5)/25;
    handles.imvol2_2(:,:,i)=medfilt2(handles.imvol2(:,:,i),[5 5]);
   % handles.imvol2_3(:,:,i)=wiener2(handles.imvol2(:,:,i),[5 5]);
  %  handles.imvol2_4(:,:,i)=filter2(h,handles.imvol2(:,:,i));
 end
 %handles.imvol2_1=uint16(handles.imvol2_1);
 handles.imvol2_2=uint16(handles.imvol2_2);
% handles.imvol2_3=uint16(handles.imvol2_3);
% handles.imvol2_4=uint16(handles.imvol2_4);

axes(handles.axes4)
imvolx=sum(handles.imvol2_2,3);
L1=get(handles.slider3,'value');
L2=get(handles.slider4,'value');
imshow(im2uint8(mat2gray(imvolx))) , hold all,colormap(jet),colorbar;
try
caxis([L1 L2]);
catch
   b=msgbox('Wrong scale, right bar must be greater than left one');
    set(handles.slider3,'value',0);
    set(handles.slider4,'value',255);
end
b=msgbox('slide right and left bars for colors');
waitfor(b);
guidata(hObject, handles);


% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
try
close 1
close 2
close 3
close 4
close Dialogue_box_pre_post
catch
end
% read images (post-chemo).
x = inputdlg('Pick Post image:',...
              'Define Image', [1]);
handles.name= (x{:}); % image number
handles.imvol = squeeze(dicomread(handles.name));
info = dicominfo(handles.name);
save info info;load MMWF_Kernel MMWF_Kernel
for i=1:1:info.NumberOfFrames
  %[x_mean,x_median,x_min,x_wiener,x_mmwf,x_mmwf_star]=MMWF_2D(handles.imvol(:,:,i),MMWF_Kernel);
   % handles.imvol_1(:,:,i)=(x_mmwf);h=ones(5)/25;
    handles.imvol_2(:,:,i)=medfilt2(handles.imvol(:,:,i),[5 5]);
  %  handles.imvol_3(:,:,i)=wiener2(handles.imvol(:,:,i),[5 5]);
  %  handles.imvol_4(:,:,i)=filter2(h,handles.imvol(:,:,i));
end
%handles.imvol_1=uint16(handles.imvol_1);
handles.imvol_2=uint16(handles.imvol_2);
%handles.imvol_3=uint16(handles.imvol_3);
%handles.imvol_4=uint16(handles.imvol_4);
axes(handles.axes1);
imvolx=sum(handles.imvol_2,3);
L1=get(handles.slider1,'value');
L2=get(handles.slider2,'value');
imshow(im2uint8(mat2gray(imvolx))) , hold all,colormap(jet),colorbar;
try
caxis([L1 L2]);
catch
   b=msgbox('Wrong scale, right bar must be greater than left one');
    set(handles.slider1,'value',0);
    set(handles.slider2,'value',255);
end
b=msgbox('slide right and left bars for colors');
waitfor(b);
guidata(hObject, handles);

% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
