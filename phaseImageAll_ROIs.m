x = inputdlg('Pick Post image:',...
              'Define Image', [1]);
handles.name= (x{:}); % image number
handles.imvol = squeeze(dicomread(handles.name));
info = dicominfo(handles.name);
save info info;
load meanBGMn2 meanBGMn2;
load meanBGMn meanBGMn;
for i=1:1:info.NumberOfFrames
  handles.imvol(:,:,i)=medfilt2(handles.imvol(:,:,i),[5 5]);%
end
volx=(handles.imvol-meanBGMn2);
image =( volx);
F = fft2(double(image));
F_Mag = abs(F);
F_Phase = rad2deg ((exp(1i*angle(F))));
% reconstructin
I_Mag = ifft2(log(F_Mag+1));
I_Phase =uint16(360*(mat2gray( abs(ifft2(F_Phase)))));
% Calculate limits for plotting
I_Mag_min = min(min(abs(I_Mag)));
I_Mag_max = max(max(abs(I_Mag)));
I_Phase_min = min(min(abs(I_Phase)));
I_Phase_max = max(max(abs(I_Phase)));
% Display reconstructed images
bw=uint16(zeros(size(I_Phase)));
for i=1:16
bw(:,:,i)=uint16(I_Phase(:,:,i)>round(mean(I_Phase(:))));
bw(:,:,i)=(bwareaopen(bw(:,:,i),200));
bw(:,:,i)=bwlabel(imfill(bw(:,:,i),'holes'));
end
subplot(121),imshow(label2rgb(sum(bw,3),'jet','b', 'shuffle'),[]), colorbar 
title('reconstructed image only by Phase');
subplot(122)
[counts, grayLevels] = MyHistogram((I_Phase),(I_Mag)); 
title('reconstructed image only by Magnitude');
axis([0 360 0 30]);