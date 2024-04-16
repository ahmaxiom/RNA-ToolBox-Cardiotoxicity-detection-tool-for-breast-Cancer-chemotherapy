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
%figure,imshow(sum(imvol,3),[]); title('Select seed point');
%colormap jet;colorbar
%sp = ginput(1);
%[a,B, C, D,min_img2,F,imvolmn2,bw1, AA, AB, AC, AD, AE, AF,AG, AH, AI, aj, sp]=max_min_MUGA3(imvol,0,sp,[],[]);
%bw1=(bw1);
%for i=1:1:info.NumberOfFrames
  %imvol1(:,:,i)=uint16(bw1).*imvol(:,:,i);%
%end
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
Test_RP=regionprops(bwlabel(test_bw),'Extrema','Centroid','MinorAxisLength');
C_test=round([Test_RP.Centroid]);% to compute each bkg in each square of the image after splitting it to 4 regions based on center of the router region
Extrema=round([Test_RP.Extrema]);% extrema [top-left top-right right-top right-bottom bottom-right bottom-left left-bottom left-top] to comopute region 1&2

% plot outer ROI
ed=edge(test_bw);
for i=1:128
    for j=1:128
        if(ed(i,j)==1)
           sumImg(i,j)= 1;
        end
    end
end
%
%% bkg1
Extrema_1=max(Extrema(1:4));
img1=imvol;
img1(:,1:Extrema_1,:)=0;
meanBGBox1=mean(mean(mean(img1)));
%% bkg2
Extrema_1=min(Extrema(5:8));
img1=imvol;
img1(:,Extrema_1:end,:)=0;
meanBGBox2=mean(mean(mean(img1)));
%% mean Bkg of box1 and box2
meanBkg=(meanBGBox1+meanBGBox2)/2;
%% bkg1
ed1=ed;
ed1(:,1:C_test(1))=0;
ed1(1:C_test(2)+25,:)=0;
NewImg1=ed1;
NewImg1=imtranslate(NewImg1,[8, 0]);
NewImg1=imdilate(NewImg1,[1 1]);
meanBG1=mean(mean(test(NewImg1==1)))/16;
%add bkg1 to image
sumImg(NewImg1==1)=max(sumImg(:))-200;
[xE1 yE1]=find(NewImg1==1);

%% bkg2
ed2=ed;
ed2(:,1:C_test(1))=0;
ed2(1:C_test(2)-10,:)=0;
ed2(C_test(2)+10:end,:)=0;
NewImg2=ed2;
NewImg2=imtranslate(NewImg2,[8, 0]);
NewImg2=imdilate(NewImg2,[1 1]);
meanBG2=mean(mean(test(NewImg2==1)))/16;
%add bkg2 to image
sumImg(NewImg2==1)=max(sumImg(:))-200;
[xE2 yE2]=find(NewImg2==1);

%% bkg3
ed3=ed;
ed3(:,1:C_test(1))=0;
ed3(C_test(2)-25:end,:)=0;
NewImg3=ed3;
NewImg3=imtranslate(NewImg3,[8, 0]);
meanBG3=mean(mean(test(NewImg3==1)))/16;
%add bkg3 to image
sumImg(NewImg3==1)=max(sumImg(:))-200;
[xE3 yE3]=find(NewImg3==1);

%% bkg4
ed4=ed;
ed4(:,C_test(1):end)=0;
ed4(C_test(2)-20:end,:)=0;
NewImg4=ed4;
NewImg4=imtranslate(NewImg4,[-8, 0]);
NewImg4=imdilate(NewImg4,[1 1]);
meanBG4=mean(mean(test(NewImg4==1)))/16;
%add bkg4 to image
sumImg(NewImg4==1)=max(sumImg(:))-200;
[xE4 yE4]=find(NewImg4==1);

%% bkg5
ed5=ed;
ed5(:,C_test(1):end)=0;
ed5(1:C_test(2)-10,:)=0;
ed5(C_test(2)+10:end,:)=0;
NewImg5=ed5;
NewImg5=imtranslate(NewImg5,[-8, 0]);
NewImg5=imdilate(NewImg5,[1 1]);
meanBG5=mean(mean(test(NewImg5==1)))/16;
%add bkg5 to image
sumImg(NewImg5==1)=max(sumImg(:))-200;
[xE5 yE5]=find(NewImg5==1);

%% bkg6
ed6=ed;
ed6(:,C_test(1):end)=0;
ed6(1:C_test(2)+25,:)=0;
NewImg6=ed6;
NewImg6=imtranslate(NewImg6,[-8, 0]);
meanBG6=mean(mean(test(NewImg6==1)))/16;
%add bkg6 to image
sumImg(NewImg6==1)=max(sumImg(:))-200;
[xE6 yE6]=find(NewImg6==1);


% plot
imshow(sumImg,[]);colormap jet;colorbar
hold on
plot(yE1,xE1,'.r')
plot(yE2,xE2,'.g')
plot(yE3,xE3,'.w')
plot(yE4,xE4,'.w')
plot(yE5,xE5,'.g')
plot(yE6,xE6,'.r')

str1 = '1';
str2 = '2';
str3 = '3';
str4 = '4';
str5 = '5';
str6 = '6';
text(yE1(1),xE1(1)+2,str1,'FontSize',14)
text(yE2(1),xE2(1)+2,str2,'FontSize',14)
text(yE3(end),xE3(end),str3,'FontSize',14)
text(yE4(1),xE4(1)+2,str4,'FontSize',14)
text(yE5(1),xE5(1)+2,str5,'FontSize',14)
text(yE6(1),xE6(1)+2,str6,'FontSize',14)
hold off
%% Export to excel sheet
load numBkg;
numBkg=numBkg+1;
filename = 'bkg.xlsx';
T1 = table({info.PatientID},{meanBkg},{meanBG1},{meanBG2},{meanBG3},{meanBG4},{meanBG5},{meanBG6});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('A',num2str(numBkg)));
save numBkg numBkg
disp('Data has been written to excel sheet, check bkg.xlsx in the current folder!');