clear all
close all
clc
x = inputdlg('Pick Post image:',...
              'Define Image', [1]);
name= (x{:}); % image number
imvol = squeeze(dicomread(name));
info = dicominfo(name);
save info info;
for i=1:1:info.NumberOfFrames
  imvol(:,:,i)=medfilt2(imvol(:,:,i),[5 5]);%
end
figure,imshow(sum(imvol,3),[]); title('Select seed point');
colormap jet;colorbar
sp = ginput(1);
[a,B, C, D,min_img2,F,imvolmn2,bw1, AA, AB, AC, AD, AE, AF,AG, AH, AI, aj, sp]=max_min_MUGA3(imvol,0,sp,[],[]);
bw1=(bw1);
for i=1:1:info.NumberOfFrames
  imvol1(:,:,i)=uint16(bw1).*imvol(:,:,i);%
end
close
sumImg=sum(imvol,3);
imshow(sumImg,[]);colormap jet;colorbar
test=sum(imvol,3);
test_bw=(test>500);
test_bw=imopen(test_bw,strel('disk',5));
%figure,imshow(test_bw,[]);
s=regionprops(bwlabel(test_bw),'Area');
Area=[s.Area];
loc2=find(Area==max(Area));
test_bw(bwlabel(test_bw)~=loc2)=0;
%figure,imshow(test_bw,[]);
%% bkg1
NewImg1=imdilate(bw1,strel('disk',3))-imdilate(bw1,strel('disk',1));
S1=regionprops(bwlabel(NewImg1),'Centroid');
cc1=round([S1.Centroid]);
NewImg1(1:cc1(2),1:cc1(1))=0;
NewImg1(1:cc1(2),cc1(1):end)=0;
NewImg1(cc1(2):end,1:cc1(1))=0;
Test_RP=regionprops(bwlabel(test_bw),'Extrema','Centroid','MinorAxisLength');
Extrema=[Test_RP.Extrema];
D1=round(cc1(1)-Extrema(4,1)); % displacement to shift bkg2 back to left side of bag ROI
C_test=round([Test_RP.Centroid]);
MAL=round([Test_RP.MinorAxisLength]);
%msk2=poly2mask(y-D1,x,128,128);
NewImg1 = imtranslate(NewImg1,[-D1, 0]);


meanBG1=mean(mean(test(NewImg1==1)))/16;
% plot outer ROI
ed=edge(test_bw);
for i=1:128
    for j=1:128
        if(ed(i,j)==1)
           sumImg(i,j)= 1;
        end
    end
end
imshow(sumImg,[]);colormap jet;colorbar
%

%plot bkg1
ee=NewImg1;
[xE yE]=find(ee==1);
waitfor(xE);
hold on
plot(yE,xE,'r');
% end plotting

%% bkg2
NewImg2=fliplr(NewImg1);
[xE yE]=find(NewImg2==1);
D2=round(abs(yE(1)-Extrema(7,1))); % displacement to shift bkg2 back to left side of bag ROI
NewImg2 = imtranslate(NewImg2,[-D2, 0]);
[xE yE]=find(NewImg2==1);

if(abs(C_test(1)-yE(1))<15)
    NewImg2=imtranslate(NewImg2,[-round(MAL/3), 0]);
elseif (abs(C_test(1)-yE(1))>40)
    NewImg2=imtranslate(NewImg2,[round(MAL/2), 0]);
elseif (abs(C_test(1)-yE(1))>20)
    NewImg2=imtranslate(NewImg2,[round(MAL)/2, 0]);
end
if (abs(C_test(2)-xE(1))<5 )
    NewImg2=imtranslate(NewImg2,[0, -5]);
elseif (abs(C_test(2)-xE(1))>40 )
    NewImg2=imtranslate(NewImg2,[0, 10]);
elseif (abs(C_test(2)-xE(1))>20 )
    NewImg2=imtranslate(NewImg2,[0, 5]);
end

%plot bkg2
ee=NewImg2;
hold on
[xE yE]=find(ee==1);
waitfor(xE);
plot(yE,xE,'r');
% end plotting

%% bkg3
NewImg3=flipud(NewImg1);
[xE yE]=find(NewImg3==1);
D31=round(yE(1)-Extrema(2,1)); 
D32=round(xE(1)-Extrema(2,2)); 
NewImg3 = imtranslate(NewImg3,[-D31, -D32]);
[xE yE]=find(NewImg3==1);
if(abs(C_test(1)-yE(1))<5)
    NewImg3=imtranslate(NewImg3,[round(MAL/2), 0]);
elseif(abs(C_test(1)-yE(1))<15)
    NewImg3=imtranslate(NewImg3,[round(MAL/3), 0]);
end
if (abs(C_test(2)-xE(1))<10 )
    NewImg3=imtranslate(NewImg3,[0, 10]);
end

%plot bkg3
ee=NewImg3;
hold on
[xE yE]=find(ee==1);
waitfor(xE);
plot(yE,xE,'r');
hold off;
% end plotting
%% bkg4
NewImg4=fliplr(NewImg3);
[xE yE]=find(NewImg4==1);
D41=round((yE(end)-Extrema(1,1))); 
D42=round((xE(end)-Extrema(1,2)));
if (D41>=0 && D42>=0)
NewImg4 = imtranslate(NewImg4,[-D41, -D42]);
end
[xE yE]=find(NewImg4==1);
if(abs(C_test(2)-xE(end))<20)
    if(C_test(2)<xE(end))
    NewImg4=imtranslate(NewImg4,[-round(MAL/3), 0]);
    end
end
if (abs(C_test(1)-yE(end))<15 )
    if(C_test(1)<yE(end))
    NewImg4=imtranslate(NewImg4,[0, -round(MAL/3)]);
    end
end
%plot bkg4
ee=NewImg4;
hold on
[xE yE]=find(ee==1);
waitfor(xE);
plot(yE,xE,'r');
hold off;
% end plotting