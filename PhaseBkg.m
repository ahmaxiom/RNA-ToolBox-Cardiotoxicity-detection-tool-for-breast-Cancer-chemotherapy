x = inputdlg('Pick Post image:',...
              'Define Image', [1]);
name= (x{:}); % image number
imvol = squeeze(dicomread(name));
info = dicominfo(name);
save info info;
for i=1:1:info.NumberOfFrames
  imvol(:,:,i)=medfilt2(imvol(:,:,i),[3 3]);%
end
figure,imshow(sum(imvol,3),[]); title('Select seed point');
colormap jet;colorbar
sp = ginput(1);
figure
[a,B, C, D,min_img2,F,imvolmn2,bw1, AA, AB, AC, AD, AE, AF,AG, AH, AI, aj, sp]=max_min_MUGA3(imvol,0,sp,[],[]);

NewImg5=imdilate(bw1,strel('disk',3))-imdilate(bw1,strel('disk',2));
S5=regionprops(bwlabel(NewImg5),'Centroid');
cc5=round([S5.Centroid]);
D5=sum(sum(imvolmn2(cc5(2):end,cc5(1):end)));
NewImg5(1:cc5(2),1:cc5(1))=0;
NewImg5(1:cc5(2),cc5(1):end)=0;
NewImg5(cc5(2):end,1:cc5(1))=0;

imvolmn11=imvol;
imvolmn11(NewImg5==0)=0;
meanBGMn=mean(mean(max(imvol(NewImg5==1))));
%meanBGMn=mean([meanBG1,meanBG2,meanBG3,meanBG4,meanBG5])

imvol=imvol-meanBGMn;
phase=(zeros(128,128,3));amp=phase;
for i=1:128
for j=1:128
%AA(1:16)=imvol1(i,j,1:16); 
%f=(fftshift(fft(double(AA))));
%Im=sum(exp(1i*angle(f))); R=sum(abs(f));
%phase=sum(rad2deg(atan(Im./R)));
%amp=sum(sqrt((Im.^2)+(R.^2)));
%A1(i,j)=ifft(Im); A2(i,j)=R;


F =(fft(double(imvol(i,j,1:16))));
F_Mag = (abs((F)));
F_Phase =(rad2deg(exp(1i*angle(F))));
% reconstructin
I_Mag = abs(ifft(F_Mag));
I_Phase =abs(ifft(F_Phase));
% Calculate limits for plotting
phase(i,j,1:16)=(I_Phase);
amp(i,j,1:16)=(I_Mag);

end
end
% ss=abs(sum(phase),3);
% max(ss(:))
% min(ss(:))
% max(ss(:))

subplot(131), imshow(((sum(phase,3))),[]), title('Phase plot');colormap jet;colorbar
subplot(132), imshow((sum(amp,3)),[]), title('Amplitude plot');colormap jet;colorbar
subplot(133)
[counts, grayLevels] = MyHistogram(abs(sum(phase,3)),(sum(amp,3)));
axis([-10 360  0 40])