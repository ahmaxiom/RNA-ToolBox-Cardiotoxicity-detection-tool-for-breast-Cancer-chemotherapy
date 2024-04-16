function [cnr_val,CR] = cnr(img1,bw,img2,N)
%% Written at 21-9-2021 based on paper:
% https://www.researchgate.net/publication/228664578_Practical_Evaluation_of_Image_Quality_in_Computed_Radiographic_CR_Imaging_Systems
% https://en.wikipedia.org/wiki/Contrast_resolution
% https://en.wikipedia.org/wiki/Contrast-to-noise_ratio
%% This function computes the contrast to noise ratio and the contrast
%% resolution
% img1 is the original image
% imag2 is the filtered image
% N is the noisy image (img1+noise)
%% 
A = double(img1); B = double(img2);
N = double(N);
sigNois=A-N; % compute the noise only
mn1=mean2(A(bw==1)); % mean value of original image
mn2=mean2(B(bw==1)); % mean value of filtered image
sd=std2(sigNois(bw==1)); % std of the noise
dif=abs(mn1-mn2); % mean difference
cnr_val=dif./sd; % cnr value
% contrast resolution
CR=dif/(mn1+mn2);
end

