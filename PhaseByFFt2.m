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
image=(handles.imvol-meanBGMn);
F = fft2(double(image));
F_Mag = abs(F);
F_Phase =rad2deg ((exp(1i*angle(F))));
% reconstructin
I_Mag = ifft2(log(F_Mag+1));
I_Phase = abs(ifft2(F_Phase));
% Calculate limits for plotting
I_Mag_min = min(min(min(abs(I_Mag))));
I_Mag_max = max(max(max(abs(I_Mag))));
I_Phase_min = min(min(min(abs(I_Phase))));
I_Phase_max = max(max(max(abs(I_Phase))));
% Display reconstructed images
subplot(121),imshow(sum(image,3),[]), colormap jet;colorbar 
title('original image');
subplot(122),imshow(sum((I_Phase),3),[]), colormap jet ;colorbar
title('reconstructed image only by Phase');
figure
Sphase=(abs(I_Phase));
max(Sphase(:))
min(Sphase(:))
%max(abs(sum((I_Phase),3)))
[counts, grayLevels] = MyHistogram(sum(I_Phase,3),(I_Mag));
%axis([0 360 0 20])
% max(Sphase(:))
figure
histogram(sum((I_Phase),3))
%axis([0 360 0 20])