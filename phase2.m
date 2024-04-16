x = inputdlg('Pick Post image:',...
              'Define Image', [1]);
handles.name= (x{:}); % image number
handles.imvol = squeeze(dicomread(handles.name));
info = dicominfo(handles.name);
save info info;
for i=1:1:info.NumberOfFrames
  handles.imvol(:,:,i)=medfilt2(handles.imvol(:,:,i),[5 5]);%
end
% BW=im2bw(imvolmx1,0.00001);
% for i=1:16
% volx(:,:,i)=volx(:,:,i).*uint16(BW);
% end
load meanBGMn meanBGMn
% 
image = sum(handles.imvol-meanBGMn,3);
F =(fft2(double((image))));
F_Mag = abs(F);
F_Phase = exp(1i*angle(F));
% reconstructin
I_Mag = ifft2(log(F_Mag+1));
I_Phase =abs( ifft2(rad2deg(F_Phase)));
% Calculate limits for plotting
I_Mag_min = min(min(abs(I_Mag)));
I_Mag_max = max(max(abs(I_Mag)));
I_Phase_min = min(min(abs(I_Phase)));
I_Phase_max = max(max(abs(I_Phase)));
% Display reconstructed images
subplot(121),imagesc(abs(I_Mag),[I_Mag_min I_Mag_max]), colormap jet ;colorbar
title('reconstructed image only by Magnitude');
subplot(122),imagesc(abs(I_Phase),[I_Mag_min I_Mag_max]), colormap jet ;colorbar
title('reconstructed image only by Phase');
[counts, grayLevels] = MyHistogram(abs(I_Phase),I_Mag);