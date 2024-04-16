function  [All_masks,smoothedPoly, smoothedPoly1, max_img,min_img,imvolmx,imvolmn, bw, bw1, area1, area2, rate,minLongDIVmaxL, minShortDIVmaxL,AverageDiv, circularityMax, circularityMin,ElongationMax,ElongationMin,sp]=max_min_MUGA3(Imag,meanBG,sp,newBW,newBW1)
load maskallparam numofIter numofIterRG
itrMx=max(numofIter);
itrMxRG=max(numofIterRG);
%x = inputdlg('Pick first image:',...
 %             'Define Image', [1]);
%name= (x{:}); % image number
imvol = Imag;
%info = dicominfo(name);
%save info info;
[Y Z O] = size(imvol);
% for i=1:O
%     mean_val(i)=mean(mean(imvol(:,:,i)));
% end
% mx_val=max(max(mean_val));
% mn_val=min(min(mean_val));
% ind_max=find(mx_val==mean_val)
% ind_min=find(mn_val==mean_val)
% max_img=imvol(:,:,ind_max);
% min_img=imvol(:,:,ind_min);
%%
%mean_val(ind_max)=-1;
%mx_val=max(max(mean_val));
%mean_val(ind_max)=1000;
%mean_val(ind_min)=1000;
%mn_val=min(min(mean_val));
% if(ind_min==16)
%     ind_min=15;
% end
% if(ind_max==16)
%    ind_max=15; 
% 
% end
%% compute max min based on ROI
%imvolx=sum(imvol,3);
imvolx=sum(imvol,3);
%figure(20), 
%imshow(im2uint8(mat2gray(imvolx)),[]) , hold all,colormap(jet),colorbar, title("Pick a centered seed in this Image");
[poly, mask, smoothedPoly,sp] = regionGrowing3(im2uint8(mat2gray(imfilter(imvolx,[0 -1 0;-1 5 -1;0 -1 0]))),1,sp,itrMx,itrMxRG);
waitfor(mask);
mask=uint16(mask);
for i=1:O
    imvol2(:,:,i)=mask.*imvol(:,:,i);
end
y=(zeros(1,O));
y(1:O)=sum(sum(imvol2(:,:,1:O)));
mx1=max((y));
mx1=mx1(1);
mn1=min((y));
mn1=mn1(1);
ind_max=find(y==mx1);
ind_min=find(y==mn1);
max_img=imvol(:,:,ind_max(1));
min_img=imvol(:,:,ind_min(1));
%%
% if (ind_min~=16 || ind_max~=16)
%     ind_max2=ind_max+1;
%     ind_min2=ind_min+1;
% end
%max_img2=imvol(:,:,ind_max2);
%min_img2=imvol(:,:,ind_min2);
%% sum
%max_img=max_img+1.2*max_img2;
%min_img=min_img+0.75*(min_img2);
%% ROI max_img
[All_masks,bw, poly, smoothedPoly,bw1,poly1,smoothedPoly1]=ROI_max_min3(Imag,max_img,min_img,meanBG,sp,imvol2); 
waitfor(bw);
%bw =uint16(bw);
%% ROI min_img
%[bw1, poly1, smoothedPoly1]=ROI_max_min(bw,min_img,2,meanBG); 
waitfor(bw1);
%bw1 =uint16(bw1);
%% show max and min images with their ROI's
%figure(3)
%subplot(1,2,1),imshow(max_img,[]),colormap(jet),colorbar ;title('MAX Image');
%hold on
%impoly(gca,smoothedPoly);
%hold off
if (sum(sum(bw)))==0
   bw=newBW; 
end
imvolmx=max_img;
imvolmx(bw==0)=0;
%subplot(1,2,2),imshow(imvolmx,[]),colormap(jet),colorbar ;title('MAX ROI Image');

%figure(4)
%subplot(1,2,1),imshow(min_img,[]),colormap(jet),colorbar ;title('MIN Image');
%hold on
%impoly(gca,smoothedPoly1);
%hold off
if (sum(sum(bw1)))==0
   bw1=newBW1; 
end
imvolmn=min_img;
imvolmn(bw1==0)=0;
%subplot(1,2,2),imshow(imvolmn,[]),colormap(jet),colorbar ;title('MIN ROI Image');
%% compute area difference
[m1 n1]=find(bw==1);
[m2 n2]=find(bw1==1);
e1=fit_ellipse(m1,n1);
%area1=0.2645833333*(e1.a)*0.2645833333*(e1.b)*pi;%max
area1=(e1.a)*(e1.b)*pi;%max
e2=fit_ellipse(m2,n2);
%area2=0.2645833333*(e2.a)*0.2645833333*(e2.b)*pi;%min
area2=(e2.a)*(e2.b)*pi;
rate=area2/area1;
%% Diameters Ration
% % 1st min long diameter/max long diameter
% minLongDIVmaxL=e2.long_axis/e1.long_axis;
% % 2nd min short diameter/max short diameter
% minShortDIVmaxL=e2.short_axis/e1.short_axis;
% % 3rd Average Minimun / Average Maximum
% meanOfMin=mean([e2.long_axis e2.short_axis]);
% meanOfMax=mean([e1.long_axis e1.short_axis]);
% AverageDiv=meanOfMin/meanOfMax;
minLongDIVmaxL=(e1.long_axis-e2.long_axis)/e1.long_axis; % LA FS

minShortDIVmaxL=(e1.short_axis-e2.short_axis)/e1.short_axis;% SA FS

AverageDiv=(minLongDIVmaxL+minShortDIVmaxL)/2; % Average FS
%% max image
PerimeterMax=2*pi*sqrt(((e1.short_axis)^2+(e1.long_axis)^2)/2);
circularityMax=(4*pi*area1)/(PerimeterMax.^2);
ElongationMax=e1.short_axis/e1.long_axis;
%% min image
PerimeterMin=2*pi*sqrt((e2.short_axis^2+e2.long_axis^2)/2);
circularityMin=(4*pi*area2)/(PerimeterMin.^2);
ElongationMin=e2.short_axis/e2.long_axis;