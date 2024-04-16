function [P, J, smoothedPoly,seedPointx,ext_energy] = regionGrowing3(ImgO,n,seedPoint,numofIter,numofIterRG)
amp=(zeros(128,128));phase=amp;
for i=1:128
for j=1:128
F =(fft(double(ImgO(i,j))));
F_Mag = (abs((F)));
% reconstructin
I_Mag = abs(ifft(F_Mag));
F_Phase =(rad2deg(exp(1i*angle(F))));

% Calculate limits for plotting
amp(i,j)=(I_Mag);
I_Phase =abs(ifft(F_Phase));
% Calculate limits for plotting
phase(i,j)=(I_Phase);
end
end
Img=phase;

    p1=seedPoint;

%if(n==1)
Px(1) =p1(1,1);   Py(1) =p1(1,2);
Px(2) =p1(1,1)-1;   Py(2) =p1(1,2)-1;
Px(3) =p1(1,1)+1;   Py(3) =p1(1,2)-1;
Px(4) =p1(1,1)-1;   Py(4) =p1(1,2)+1;
Px(5) =p1(1,1)-1;   Py(5) =p1(1,2);
Px(6) =p1(1,1);     Py(6) =p1(1,2)+1;
Px(7) =p1(1,1);     Py(7) =p1(1,2)-1;
Px(8) =p1(1,1)+1;   Py(8) =p1(1,2);

% Px(9) =p1(1,1)+2;   Py(9) =p1(1,2);
% Px(10) =p1(1,1)-2;   Py(10) =p1(1,2);
% Px(11) =p1(1,1);    Py(11) =p1(1,2)-2;
% Px(12) =p1(1,1);    Py(12) =p1(1,2)+2;
% Px(13) =p1(1,1)-1;    Py(13) =p1(1,2)-2;
% Px(14) =p1(1,1)+1;    Py(14) =p1(1,2)-2;
% Px(15) =p1(1,1)-1;    Py(15) =p1(1,2)+2;
% Px(16) =p1(1,1)+1;    Py(16) =p1(1,2)+2;
% Px(17) =p1(1,1);    Py(17) =p1(1,2)-3;
% Px(18) =p1(1,1)+3;    Py(18) =p1(1,2);
% Px(19) =p1(1,1)-2;    Py(19) =p1(1,2)+2;
% Px(20) =p1(1,1)+2;    Py(20) =p1(1,2)+2;
% Px(21) =p1(1,1)-3;    Py(21) =p1(1,2)+3;
% Px(22) =p1(1,1)+3;    Py(22) =p1(1,2)+3;
% Px(23) =p1(1,1);    Py(23) =p1(1,2)-3;
% Px(24) =p1(1,1);    Py(24) =p1(1,2)+3;
% Px(2) =p1(1,1)-2;Py(2) =p1(1,2)-1;
% Px(3) =p1(1,1)-1;Py(3) =p1(1,2)-2;
% Px(4) =p1(1,1)-2;Py(4) =p1(1,2)-2;
% Px(5) =p1(1,1)-1;Py(5) =p1(1,2)-3;
% Px(6) =p1(1,1)-3;Py(6) =p1(1,2)-1;
% Px(7) =p1(1,1)-2;Py(7) =p1(1,2)-3;
% Px(8) =p1(1,1)-3;Py(8) =p1(1,2)-2;
% Px(9) =p1(1,1)-3;Py(9) =p1(1,2)-3;
% Px(10) =p1(1,1)-1;Py(10) =p1(1,2)-4;
% Px(11) =p1(1,1)-2;Py(11) =p1(1,2)-4;
% Px(12) =p1(1,1)-3;Py(12) =p1(1,2)-4;
% Px(13) =p1(1,1)-4;Py(13) =p1(1,2)-4;
% Px(14) =p1(1,1)-4;Py(14) =p1(1,2)-1;
% Px(15) =p1(1,1)-4;Py(15) =p1(1,2)-2;
% Px(16) =p1(1,1)-4;Py(16) =p1(1,2)-3;
% Px(17)=p1(1,1); Py(17)=p1(1,2);
%end
%if (n==2)
%Px =p1(1,1)-6*rand(16,1)
%Py =p1(1,2)-8*rand(16,1)    
%end
p(:,1)=Px';
p(:,2)=Py';
p=uint8(p);
mask = zeros(size(Img));
for i=1:size(p,1)
mask(p(i,2),p(i,1)) = 1;
end
load AC SmoothFactor ContractionBias method
if (n==1 || n==4) % max roi and unified roi
J = activecontour((Img),mask,numofIter,method,'SmoothFactor',SmoothFactor,'ContractionBias',ContractionBias);
elseif (n==2) % min roi
J = activecontour((Img),mask,numofIter,method,'SmoothFactor',SmoothFactor,'ContractionBias',ContractionBias);
elseif (n==3)% all 16 ROIs
J = activecontour((Img),mask,numofIter,method,'SmoothFactor',SmoothFactor,'ContractionBias',ContractionBias);
load AC SmoothFactor ContractionBias method
[seg force] = chenvese(ImgO,J,numofIter,SmoothFactor,'chan');
ext_energy=mean(force(:));
end
%
J=imfilter(J,ones(11)/121);
J=imdilate(J,strel('rectangle',[6 2]));
% Extract polygon of J
s=regionprops(bwlabel(J),'ConvexHull','Area');
Area=[s.Area];
[xx yy]=find(Area==max(Area));
P=[s(yy).ConvexHull];
%P=bwconvhull(J,'union');
% ellipse_t=fit_ellipse(P(:,1),P(:,2));
% x=ellipse_t.X0_in-round(ellipse_t.a);
% y=ellipse_t.Y0_in-round(ellipse_t.b);
% %M(x:x+ellipse_t.short_axis, y:y+ellipse_t.long_axis)=1;
% %figure(11),imshow(Img);
% %impoly(gca,[x y ellipse_t.short_axis ellipse_t.long_axis]);
% if (n==1)
% e=imellipse(gca,[x y ellipse_t.short_axis+3 ellipse_t.long_axis+4]);
% elseif(n==2 || n==3)
% e=imellipse(gca,[x y ellipse_t.short_axis+3 ellipse_t.long_axis+4]);       
% end
% J=createMask(e);
% s=regionprops(bwlabel(J),'ConvexHull','Area');
% P=[s.ConvexHull];
%% apply region growing not active contouring AC inside the ROI of AC algorithm
[J1] =regiongrowingX(J.*double(amp),round(p1(2)),round(p1(1)),numofIterRG);
%round(p1)   uint8(J).*
%%
numofIter2=numofIter;
load maskallparam numofIter
if numofIter2==min(numofIter)
J=imfilter(J1,ones(9)/81);
J=imdilate(J,strel('rectangle',[4 2]));

else
J=imfilter(J1,ones(11)/121);
J=imdilate(J,strel('rectangle',[6 2]));

end
J=imfill(J,'holes');
J=imopen(J,strel('disk',1));
J=imclose(J,strel('disk',2));

%figure,imshow(J);

s=regionprops(bwlabel(J),'ConvexHull','Area');
Area=[s.Area];
[xx yy]=find(Area==max(Area));
P=[s(yy).ConvexHull];
smoothedPoly=P;
seedPointx=p1;