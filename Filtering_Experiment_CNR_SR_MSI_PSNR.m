% read images (post-chemo).
x = inputdlg('Pick Post image:',...
              'Define Image', [1]);
name= (x{:}); % image number
imvol = squeeze(dicomread(name));
info = dicominfo(name);
for i=1:1:info.NumberOfFrames
  imvol(:,:,i)=medfilt2(imvol(:,:,i),[3 3]);%
end
figure,imshow(sum(imvol,3),[]); title('Select seed point');
colormap jet;colorbar
sp = ginput(1);
[a,B, C, D,min_img2,F,imvolmn2,bw1, AA, AB, AC, AD, AE, AF,AG, AH, AI, aj, sp]=max_min_MUGA3(imvol,0,sp,[],[]);
close
imvol=uint16(sum(imvol,3));
% adding gaussian noise to imvol
NG1=imnoise(imvol,'Gaussian',0,0.00001);
NG2=imnoise(imvol,'Gaussian',0,0.00002);
NG3=imnoise(imvol,'Gaussian',0,0.00003);
NG4=imnoise(imvol,'Gaussian',0,0.00004);
NG5=imnoise(imvol,'Gaussian',0,0.00005);
NG6=imnoise(imvol,'Gaussian',0,0.00006);
% adding poisson noise to imvol
% if you work on a specific ROI you need to compute bw using max_min_muga
I1=imvol;
I11=uint16(imvol.*1.1);
I12=uint16(imvol.*1.2);
I13=uint16(imvol.*1.3);
I14=uint16(imvol.*1.4);
I15=uint16(imvol.*1.5);
I16=uint16(imvol.*1.6);
bw1=ones(size(I11));
f1 = @(x) imnoise(x,'poisson');
NP1=roifilt2(I11,bw1,f1);
NP2=roifilt2(I12,bw1,f1);
NP3=roifilt2(I13,bw1,f1);
NP4=roifilt2(I14,bw1,f1);
NP5=roifilt2(I15,bw1,f1);
NP6=roifilt2(I16,bw1,f1);

% adding speckle noise to imvol
NS1=imnoise(imvol,'Speckle',0.1);
NS2=imnoise(imvol,'Speckle',0.2);
NS3=imnoise(imvol,'Speckle',0.3);
NS4=imnoise(imvol,'Speckle',0.4);
NS5=imnoise(imvol,'Speckle',0.5);
NS6=imnoise(imvol,'Speckle',0.6);
%% Filtering
%% 1st: filtering gaussian noise
% Median Filtering
FG_MED1=medfilt2(NG1,[5 5]); % FG means Filter gaussian noise, med means using median filter
FG_MED2=medfilt2(NG2,[5 5]);
FG_MED3=medfilt2(NG3,[5 5]);
FG_MED4=medfilt2(NG4,[5 5]);
FG_MED5=medfilt2(NG5,[5 5]);
FG_MED6=medfilt2(NG6,[5 5]);
% Mean Filtering
h1=fspecial('average',5);
FG_AVG1=filter2(h1,NG1); % FG means Filter gaussian noise, AVG means using mean (average) filter
FG_AVG2=filter2(h1,NG2);
FG_AVG3=filter2(h1,NG3);
FG_AVG4=filter2(h1,NG4);
FG_AVG5=filter2(h1,NG5);
FG_AVG6=filter2(h1,NG6);
% Wiener Filtering
FG_WNR1=wiener2(NG1,[5 5]); % FG means Filter gaussian noise, med means using weiner filter
FG_WNR2=wiener2(NG2,[5 5]);
FG_WNR3=wiener2(NG3,[5 5]);
FG_WNR4=wiener2(NG4,[5 5]);
FG_WNR5=wiener2(NG5,[5 5]);
FG_WNR6=wiener2(NG6,[5 5]);
% MMWF Filtering
FG_MMW1=MMWF_2D(NG1,5); % FG means Filter gaussian noise, med means using modified median weiner filter
FG_MMW2=MMWF_2D(NG2,5);
FG_MMW3=MMWF_2D(NG3,5);
FG_MMW4=MMWF_2D(NG4,5);
FG_MMW5=MMWF_2D(NG5,5);
FG_MMW6=MMWF_2D(NG6,5);
%% 2nd: filtering poisson noise
% Median Filtering
FP_MED1=medfilt2(NP1,[5 5]); % FP means Filter possion noise, med means using median filter
FP_MED2=medfilt2(NP2,[5 5]);
FP_MED3=medfilt2(NP3,[5 5]);
FP_MED4=medfilt2(NP4,[5 5]);
FP_MED5=medfilt2(NP5,[5 5]);
FP_MED6=medfilt2(NP6,[5 5]);
% Mean Filtering
h1=fspecial('average',5);
FP_AVG1=filter2(h1,NP1); % FP means Filter possion noise, AVG means using mean (average) filter
FP_AVG2=filter2(h1,NP2);
FP_AVG3=filter2(h1,NP3);
FP_AVG4=filter2(h1,NP4);
FP_AVG5=filter2(h1,NP5);
FP_AVG6=filter2(h1,NP6);
% Wiener Filtering
FP_WNR1=wiener2(NP1,[5 5]); % FP means Filter possion noise, med means using weiner filter
FP_WNR2=wiener2(NP2,[5 5]);
FP_WNR3=wiener2(NP3,[5 5]);
FP_WNR4=wiener2(NP4,[5 5]);
FP_WNR5=wiener2(NP5,[5 5]);
FP_WNR6=wiener2(NP6,[5 5]);
% MMWF Filtering
FP_MMW1=MMWF_2D(NP1,5); % FP means Filter possion noise, med means using modified median weiner filter
FP_MMW2=MMWF_2D(NP2,5);
FP_MMW3=MMWF_2D(NP3,5);
FP_MMW4=MMWF_2D(NP4,5);
FP_MMW5=MMWF_2D(NP5,5);
FP_MMW6=MMWF_2D(NP6,5);
%% 3rd: filtering speckle noise
% Median Filtering
FS_MED1=medfilt2(NS1,[5 5]); % FS means Filter speckle noise, med means using median filter
FS_MED2=medfilt2(NS2,[5 5]);
FS_MED3=medfilt2(NS3,[5 5]);
FS_MED4=medfilt2(NS4,[5 5]);
FS_MED5=medfilt2(NS5,[5 5]);
FS_MED6=medfilt2(NS6,[5 5]);
% Mean Filtering
h1=fspecial('average',5);
FS_AVG1=filter2(h1,NS1); % FS means Filter speckle noise, AVG means using mean (average) filter
FS_AVG2=filter2(h1,NS2);
FS_AVG3=filter2(h1,NS3);
FS_AVG4=filter2(h1,NS4);
FS_AVG5=filter2(h1,NS5);
FS_AVG6=filter2(h1,NS6);
% Wiener Filtering
FS_WNR1=wiener2(NS1,[5 5]); % FS means Filter speckle noise, med means using weiner filter
FS_WNR2=wiener2(NS2,[5 5]);
FS_WNR3=wiener2(NS3,[5 5]);
FS_WNR4=wiener2(NS4,[5 5]);
FS_WNR5=wiener2(NS5,[5 5]);
FS_WNR6=wiener2(NS6,[5 5]);
% MMWF Filtering
FS_MMW1=MMWF_2D(NS1,5); % FS means Filter speckle noise, med means using modified median weiner filter
FS_MMW2=MMWF_2D(NS2,5);
FS_MMW3=MMWF_2D(NS3,5);
FS_MMW4=MMWF_2D(NS4,5);
FS_MMW5=MMWF_2D(NS5,5);
FS_MMW6=MMWF_2D(NS6,5);
%% compute PSNR
%10%
PSNR_G10_MED= round(psnr(imvol, uint16(FG_MED1)));
PSNR_G10_AVG= round(psnr(imvol, uint16(FG_AVG1)));
PSNR_G10_WNR= round(psnr(imvol, uint16(FG_WNR1)));
PSNR_G10_MMW= round(psnr(imvol, uint16(FG_MMW1)));
PSNR_P10_MED= round(psnr(imvol, uint16(FP_MED1)));
PSNR_P10_AVG= round(psnr(imvol, uint16(FP_AVG1)));
PSNR_P10_WNR= round(psnr(imvol, uint16(FP_WNR1)));
PSNR_P10_MMW= round(psnr(imvol, uint16(FP_MMW1)));
PSNR_S10_MED= round(psnr(imvol, uint16(FS_MED1)));
PSNR_S10_AVG= round(psnr(imvol, uint16(FS_AVG1)));
PSNR_S10_WNR= round(psnr(imvol, uint16(FS_WNR1)));
PSNR_S10_MMW= round(psnr(imvol, uint16(FS_MMW1)));
%20%
PSNR_G20_MED= round(psnr(imvol, uint16(FG_MED2)));
PSNR_G20_AVG= round(psnr(imvol, uint16(FG_AVG2)));
PSNR_G20_WNR= round(psnr(imvol, uint16(FG_WNR2)));
PSNR_G20_MMW= round(psnr(imvol, uint16(FG_MMW2)));
PSNR_P20_MED= round(psnr(imvol, uint16(FP_MED2)));
PSNR_P20_AVG= round(psnr(imvol, uint16(FP_AVG2)));
PSNR_P20_WNR= round(psnr(imvol, uint16(FP_WNR2)));
PSNR_P20_MMW= round(psnr(imvol, uint16(FP_MMW2)));
PSNR_S20_MED= round(psnr(imvol, uint16(FS_MED2)));
PSNR_S20_AVG= round(psnr(imvol, uint16(FS_AVG2)));
PSNR_S20_WNR= round(psnr(imvol, uint16(FS_WNR2)));
PSNR_S20_MMW= round(psnr(imvol, uint16(FS_MMW2)));
%30%
PSNR_G30_MED= round(psnr(imvol, uint16(FG_MED3)));
PSNR_G30_AVG= round(psnr(imvol, uint16(FG_AVG3)));
PSNR_G30_WNR= round(psnr(imvol, uint16(FG_WNR3)));
PSNR_G30_MMW= round(psnr(imvol, uint16(FG_MMW3)));
PSNR_P30_MED= round(psnr(imvol, uint16(FP_MED3)));
PSNR_P30_AVG= round(psnr(imvol, uint16(FP_AVG3)));
PSNR_P30_WNR= round(psnr(imvol, uint16(FP_WNR3)));
PSNR_P30_MMW= round(psnr(imvol, uint16(FP_MMW3)));
PSNR_S30_MED= round(psnr(imvol, uint16(FS_MED3)));
PSNR_S30_AVG= round(psnr(imvol, uint16(FS_AVG3)));
PSNR_S30_WNR= round(psnr(imvol, uint16(FS_WNR3)));
PSNR_S30_MMW= round(psnr(imvol, uint16(FS_MMW3)));
%40%
PSNR_G40_MED= round(psnr(imvol, uint16(FG_MED4)));
PSNR_G40_AVG= round(psnr(imvol, uint16(FG_AVG4)));
PSNR_G40_WNR= round(psnr(imvol, uint16(FG_WNR4)));
PSNR_G40_MMW= round(psnr(imvol, uint16(FG_MMW4)));
PSNR_P40_MED= round(psnr(imvol, uint16(FP_MED4)));
PSNR_P40_AVG= round(psnr(imvol, uint16(FP_AVG4)));
PSNR_P40_WNR= round(psnr(imvol, uint16(FP_WNR4)));
PSNR_P40_MMW= round(psnr(imvol, uint16(FP_MMW4)));
PSNR_S40_MED= round(psnr(imvol, uint16(FS_MED4)));
PSNR_S40_AVG= round(psnr(imvol, uint16(FS_AVG4)));
PSNR_S40_WNR= round(psnr(imvol, uint16(FS_WNR4)));
PSNR_S40_MMW= round(psnr(imvol, uint16(FS_MMW4)));
%50%
PSNR_G50_MED= round(psnr(imvol, uint16(FG_MED5)));
PSNR_G50_AVG= round(psnr(imvol, uint16(FG_AVG5)));
PSNR_G50_WNR= round(psnr(imvol, uint16(FG_WNR5)));
PSNR_G50_MMW= round(psnr(imvol, uint16(FG_MMW5)));
PSNR_P50_MED= round(psnr(imvol, uint16(FP_MED5)));
PSNR_P50_AVG= round(psnr(imvol, uint16(FP_AVG5)));
PSNR_P50_WNR= round(psnr(imvol, uint16(FP_WNR5)));
PSNR_P50_MMW= round(psnr(imvol, uint16(FP_MMW5)));
PSNR_S50_MED= round(psnr(imvol, uint16(FS_MED5)));
PSNR_S50_AVG= round(psnr(imvol, uint16(FS_AVG5)));
PSNR_S50_WNR= round(psnr(imvol, uint16(FS_WNR5)));
PSNR_S50_MMW= round(psnr(imvol, uint16(FS_MMW5)));
%60%
PSNR_G60_MED= round(psnr(imvol, uint16(FG_MED6)));
PSNR_G60_AVG= round(psnr(imvol, uint16(FG_AVG6)));
PSNR_G60_WNR= round(psnr(imvol, uint16(FG_WNR6)));
PSNR_G60_MMW= round(psnr(imvol, uint16(FG_MMW6)));
PSNR_P60_MED= round(psnr(imvol, uint16(FP_MED6)));
PSNR_P60_AVG= round(psnr(imvol, uint16(FP_AVG6)));
PSNR_P60_WNR= round(psnr(imvol, uint16(FP_WNR6)));
PSNR_P60_MMW= round(psnr(imvol, uint16(FP_MMW6)));
PSNR_S60_MED= round(psnr(imvol, uint16(FS_MED6)));
PSNR_S60_AVG= round(psnr(imvol, uint16(FS_AVG6)));
PSNR_S60_WNR= round(psnr(imvol, uint16(FS_WNR6)));
PSNR_S60_MMW= round(psnr(imvol, uint16(FS_MMW6)));
%% Compute MSE
%10%
MSE_G10_MED= round(immse(imvol, uint16(FG_MED1)));
MSE_G10_AVG= round(immse(imvol, uint16(FG_AVG1)));
MSE_G10_WNR= round(immse(imvol, uint16(FG_WNR1)));
MSE_G10_MMW= round(immse(imvol, uint16(FG_MMW1)));
MSE_P10_MED= round(immse(imvol, uint16(FP_MED1)));
MSE_P10_AVG= round(immse(imvol, uint16(FP_AVG1)));
MSE_P10_WNR= round(immse(imvol, uint16(FP_WNR1)));
MSE_P10_MMW= round(immse(imvol, uint16(FP_MMW1)));
MSE_S10_MED= round(immse(imvol, uint16(FS_MED1)));
MSE_S10_AVG= round(immse(imvol, uint16(FS_AVG1)));
MSE_S10_WNR= round(immse(imvol, uint16(FS_WNR1)));
MSE_S10_MMW= round(immse(imvol, uint16(FS_MMW1)));
%20%
MSE_G20_MED= round(immse(imvol, uint16(FG_MED2)));
MSE_G20_AVG= round(immse(imvol, uint16(FG_AVG2)));
MSE_G20_WNR= round(immse(imvol, uint16(FG_WNR2)));
MSE_G20_MMW= round(immse(imvol, uint16(FG_MMW2)));
MSE_P20_MED= round(immse(imvol, uint16(FP_MED2)));
MSE_P20_AVG= round(immse(imvol, uint16(FP_AVG2)));
MSE_P20_WNR= round(immse(imvol, uint16(FP_WNR2)));
MSE_P20_MMW= round(immse(imvol, uint16(FP_MMW2)));
MSE_S20_MED= round(immse(imvol, uint16(FS_MED2)));
MSE_S20_AVG= round(immse(imvol, uint16(FS_AVG2)));
MSE_S20_WNR= round(immse(imvol, uint16(FS_WNR2)));
MSE_S20_MMW= round(immse(imvol, uint16(FS_MMW2)));
%30%
MSE_G30_MED= round(immse(imvol, uint16(FG_MED3)));
MSE_G30_AVG= round(immse(imvol, uint16(FG_AVG3)));
MSE_G30_WNR= round(immse(imvol, uint16(FG_WNR3)));
MSE_G30_MMW= round(immse(imvol, uint16(FG_MMW3)));
MSE_P30_MED= round(immse(imvol, uint16(FP_MED3)));
MSE_P30_AVG= round(immse(imvol, uint16(FP_AVG3)));
MSE_P30_WNR= round(immse(imvol, uint16(FP_WNR3)));
MSE_P30_MMW= round(immse(imvol, uint16(FP_MMW3)));
MSE_S30_MED= round(immse(imvol, uint16(FS_MED3)));
MSE_S30_AVG= round(immse(imvol, uint16(FS_AVG3)));
MSE_S30_WNR= round(immse(imvol, uint16(FS_WNR3)));
MSE_S30_MMW= round(immse(imvol, uint16(FS_MMW3)));
%40%
MSE_G40_MED= round(immse(imvol, uint16(FG_MED4)));
MSE_G40_AVG= round(immse(imvol, uint16(FG_AVG4)));
MSE_G40_WNR= round(immse(imvol, uint16(FG_WNR4)));
MSE_G40_MMW= round(immse(imvol, uint16(FG_MMW4)));
MSE_P40_MED= round(immse(imvol, uint16(FP_MED4)));
MSE_P40_AVG= round(immse(imvol, uint16(FP_AVG4)));
MSE_P40_WNR= round(immse(imvol, uint16(FP_WNR4)));
MSE_P40_MMW= round(immse(imvol, uint16(FP_MMW4)));
MSE_S40_MED= round(immse(imvol, uint16(FS_MED4)));
MSE_S40_AVG= round(immse(imvol, uint16(FS_AVG4)));
MSE_S40_WNR= round(immse(imvol, uint16(FS_WNR4)));
MSE_S40_MMW= round(immse(imvol, uint16(FS_MMW4)));
%50%
MSE_G50_MED= round(immse(imvol, uint16(FG_MED5)));
MSE_G50_AVG= round(immse(imvol, uint16(FG_AVG5)));
MSE_G50_WNR= round(immse(imvol, uint16(FG_WNR5)));
MSE_G50_MMW= round(immse(imvol, uint16(FG_MMW5)));
MSE_P50_MED= round(immse(imvol, uint16(FP_MED5)));
MSE_P50_AVG= round(immse(imvol, uint16(FP_AVG5)));
MSE_P50_WNR= round(immse(imvol, uint16(FP_WNR5)));
MSE_P50_MMW= round(immse(imvol, uint16(FP_MMW5)));
MSE_S50_MED= round(immse(imvol, uint16(FS_MED5)));
MSE_S50_AVG= round(immse(imvol, uint16(FS_AVG5)));
MSE_S50_WNR= round(immse(imvol, uint16(FS_WNR5)));
MSE_S50_MMW= round(immse(imvol, uint16(FS_MMW5)));
%60%
MSE_G60_MED= round(immse(imvol, uint16(FG_MED6)));
MSE_G60_AVG= round(immse(imvol, uint16(FG_AVG6)));
MSE_G60_WNR= round(immse(imvol, uint16(FG_WNR6)));
MSE_G60_MMW= round(immse(imvol, uint16(FG_MMW6)));
MSE_P60_MED= round(immse(imvol, uint16(FP_MED6)));
MSE_P60_AVG= round(immse(imvol, uint16(FP_AVG6)));
MSE_P60_WNR= round(immse(imvol, uint16(FP_WNR6)));
MSE_P60_MMW= round(immse(imvol, uint16(FP_MMW6)));
MSE_S60_MED= round(immse(imvol, uint16(FS_MED6)));
MSE_S60_AVG= round(immse(imvol, uint16(FS_AVG6)));
MSE_S60_WNR= round(immse(imvol, uint16(FS_WNR6)));
MSE_S60_MMW= round(immse(imvol, uint16(FS_MMW6)));
%% CNR
%10%
[CNR_G10_MED, CR_G10_MED]= (cnr(imvol,bw1, (FG_MED1),NG1));
[CNR_G10_AVG, CR_G10_AVG]= (cnr(imvol,bw1, (FG_AVG1),NG1));
[CNR_G10_WNR, CR_G10_WNR]= (cnr(imvol,bw1, (FG_WNR1),NG1));
[CNR_G10_MMW, CR_G10_MMW]= (cnr(imvol,bw1, (FG_MMW1),NG1));
[CNR_P10_MED, CR_P10_MED]= (cnr(imvol,bw1, (FP_MED1),NP1));
[CNR_P10_AVG, CR_P10_AVG]= (cnr(imvol,bw1, (FP_AVG1),NP1));
[CNR_P10_WNR, CR_P10_WNR]= (cnr(imvol,bw1, (FP_WNR1),NP1));
[CNR_P10_MMW, CR_P10_MMW]= (cnr(imvol,bw1, (FP_MMW1),NP1));
[CNR_S10_MED, CR_S10_MED]= (cnr(imvol,bw1, (FS_MED1),NS1));
[CNR_S10_AVG, CR_S10_AVG]= (cnr(imvol,bw1, (FS_AVG1),NS1));
[CNR_S10_WNR, CR_S10_WNR]= (cnr(imvol,bw1, (FS_WNR1),NS1));
[CNR_S10_MMW, CR_S10_MMW]= (cnr(imvol,bw1, (FS_MMW1),NS1));
%20%
[CNR_G20_MED, CR_G20_MED]= (cnr(imvol,bw1, (FG_MED2),NG2));
[CNR_G20_AVG, CR_G20_AVG]= (cnr(imvol,bw1, (FG_AVG2),NG2));
[CNR_G20_WNR, CR_G20_WNR]= (cnr(imvol,bw1, (FG_WNR2),NG2));
[CNR_G20_MMW, CR_G20_MMW]= (cnr(imvol,bw1, (FG_MMW2),NG2));
[CNR_P20_MED, CR_P20_MED]= (cnr(imvol,bw1, (FP_MED2),NP2));
[CNR_P20_AVG, CR_P20_AVG]= (cnr(imvol,bw1, (FP_AVG2),NP2));
[CNR_P20_WNR, CR_P20_WNR]= (cnr(imvol,bw1, (FP_WNR2),NP2));
[CNR_P20_MMW, CR_P20_MMW]= (cnr(imvol,bw1, (FP_MMW2),NP2));
[CNR_S20_MED, CR_S20_MED]= (cnr(imvol,bw1, (FS_MED2),NS2));
[CNR_S20_AVG, CR_S20_AVG]= (cnr(imvol,bw1, (FS_AVG2),NS2));
[CNR_S20_WNR, CR_S20_WNR]= (cnr(imvol,bw1, (FS_WNR2),NS2));
[CNR_S20_MMW, CR_S20_MMW]= (cnr(imvol,bw1, (FS_MMW2),NS2));
%30%
[CNR_G30_MED, CR_G30_MED]= (cnr(imvol,bw1, (FG_MED3),NG3));
[CNR_G30_AVG, CR_G30_AVG]= (cnr(imvol,bw1, (FG_AVG3),NG3));
[CNR_G30_WNR, CR_G30_WNR]= (cnr(imvol,bw1, (FG_WNR3),NG3));
[CNR_G30_MMW, CR_G30_MMW]= (cnr(imvol,bw1, (FG_MMW3),NG3));
[CNR_P30_MED, CR_P30_MED]= (cnr(imvol,bw1, (FP_MED3),NP3));
[CNR_P30_AVG, CR_P30_AVG]= (cnr(imvol,bw1, (FP_AVG3),NP3));
[CNR_P30_WNR, CR_P30_WNR]= (cnr(imvol,bw1, (FP_WNR3),NP3));
[CNR_P30_MMW, CR_P30_MMW]= (cnr(imvol,bw1, (FP_MMW3),NP3));
[CNR_S30_MED, CR_S30_MED]= (cnr(imvol,bw1, (FS_MED3),NS3));
[CNR_S30_AVG, CR_S30_AVG]= (cnr(imvol,bw1, (FS_AVG3),NS3));
[CNR_S30_WNR, CR_S30_WNR]= (cnr(imvol,bw1, (FS_WNR3),NS3));
[CNR_S30_MMW, CR_S30_MMW]= (cnr(imvol,bw1, (FS_MMW3),NS3));
%40%
[CNR_G40_MED, CR_G40_MED]= (cnr(imvol,bw1, (FG_MED4),NG4));
[CNR_G40_AVG, CR_G40_AVG]= (cnr(imvol,bw1, (FG_AVG4),NG4));
[CNR_G40_WNR, CR_G40_WNR]= (cnr(imvol,bw1, (FG_WNR4),NG4));
[CNR_G40_MMW, CR_G40_MMW]= (cnr(imvol,bw1, (FG_MMW4),NG4));
[CNR_P40_MED, CR_P40_MED]= (cnr(imvol,bw1, (FP_MED4),NP4));
[CNR_P40_AVG, CR_P40_AVG]= (cnr(imvol,bw1, (FP_AVG4),NP4));
[CNR_P40_WNR, CR_P40_WNR]= (cnr(imvol,bw1, (FP_WNR4),NP4));
[CNR_P40_MMW, CR_P40_MMW]= (cnr(imvol,bw1, (FP_MMW4),NP4));
[CNR_S40_MED, CR_S40_MED]= (cnr(imvol,bw1, (FS_MED4),NS4));
[CNR_S40_AVG, CR_S40_AVG]= (cnr(imvol,bw1, (FS_AVG4),NS4));
[CNR_S40_WNR, CR_S40_WNR]= (cnr(imvol,bw1, (FS_WNR4),NS4));
[CNR_S40_MMW, CR_S40_MMW]= (cnr(imvol,bw1, (FS_MMW4),NS4));
%50%
[CNR_G50_MED, CR_G50_MED]= (cnr(imvol,bw1, (FG_MED5),NG5));
[CNR_G50_AVG, CR_G50_AVG]= (cnr(imvol,bw1, (FG_AVG5),NG5));
[CNR_G50_WNR, CR_G50_WNR]= (cnr(imvol,bw1, (FG_WNR5),NG5));
[CNR_G50_MMW, CR_G50_MMW]= (cnr(imvol,bw1, (FG_MMW5),NG5));
[CNR_P50_MED, CR_P50_MED]= (cnr(imvol,bw1, (FP_MED5),NP5));
[CNR_P50_AVG, CR_P50_AVG]= (cnr(imvol,bw1, (FP_AVG5),NP5));
[CNR_P50_WNR, CR_P50_WNR]= (cnr(imvol,bw1, (FP_WNR5),NP5));
[CNR_P50_MMW, CR_P50_MMW]= (cnr(imvol,bw1, (FP_MMW5),NP5));
[CNR_S50_MED, CR_S50_MED]= (cnr(imvol,bw1, (FS_MED5),NS5));
[CNR_S50_AVG, CR_S50_AVG]= (cnr(imvol,bw1, (FS_AVG5),NS5));
[CNR_S50_WNR, CR_S50_WNR]= (cnr(imvol,bw1, (FS_WNR5),NS5));
[CNR_S50_MMW, CR_S50_MMW]= (cnr(imvol,bw1, (FS_MMW5),NS5));
%60%
[CNR_G60_MED, CR_G60_MED]= (cnr(imvol,bw1, (FG_MED6),NG6));
[CNR_G60_AVG, CR_G60_AVG]= (cnr(imvol,bw1, (FG_AVG6),NG6));
[CNR_G60_WNR, CR_G60_WNR]= (cnr(imvol,bw1, (FG_WNR6),NG6));
[CNR_G60_MMW, CR_G60_MMW]= (cnr(imvol,bw1, (FG_MMW6),NG6));
[CNR_P60_MED, CR_P60_MED]= (cnr(imvol,bw1, (FP_MED6),NP6));
[CNR_P60_AVG, CR_P60_AVG]= (cnr(imvol,bw1, (FP_AVG6),NP6));
[CNR_P60_WNR, CR_P60_WNR]= (cnr(imvol,bw1, (FP_WNR6),NP6));
[CNR_P60_MMW, CR_P60_MMW]= (cnr(imvol,bw1, (FP_MMW6),NP6));
[CNR_S60_MED, CR_S60_MED]= (cnr(imvol,bw1, (FS_MED6),NS6));
[CNR_S60_AVG, CR_S60_AVG]= (cnr(imvol,bw1, (FS_AVG6),NS6));
[CNR_S60_WNR, CR_S60_WNR]= (cnr(imvol,bw1, (FS_WNR6),NS6));
[CNR_S60_MMW, CR_S60_MMW]= (cnr(imvol,bw1, (FS_MMW6),NS6));
%% Degree of smoothness DOS
%10%
DOS_G10_MED= round(dos(FG_MED1));
DOS_G10_AVG= round(dos(FG_AVG1));
DOS_G10_WNR= round(dos(FG_WNR1));
DOS_G10_MMW= round(dos(FG_MMW1));
DOS_P10_MED= round(dos(FP_MED1));
DOS_P10_AVG= round(dos(FP_AVG1));
DOS_P10_WNR= round(dos(FP_WNR1));
DOS_P10_MMW= round(dos(FP_MMW1));
DOS_S10_MED= round(dos(FS_MED1));
DOS_S10_AVG= round(dos(FS_AVG1));
DOS_S10_WNR= round(dos(FS_WNR1));
DOS_S10_MMW= round(dos(FS_MMW1));
%20%
DOS_G20_MED= round(dos(FG_MED2));
DOS_G20_AVG= round(dos(FG_AVG2));
DOS_G20_WNR= round(dos(FG_WNR2));
DOS_G20_MMW= round(dos(FG_MMW2));
DOS_P20_MED= round(dos(FP_MED2));
DOS_P20_AVG= round(dos(FP_AVG2));
DOS_P20_WNR= round(dos(FP_WNR2));
DOS_P20_MMW= round(dos(FP_MMW2));
DOS_S20_MED= round(dos(FS_MED2));
DOS_S20_AVG= round(dos(FS_AVG2));
DOS_S20_WNR= round(dos(FS_WNR2));
DOS_S20_MMW= round(dos(FS_MMW2));
%10%
DOS_G30_MED= round(dos(FG_MED3));
DOS_G30_AVG= round(dos(FG_AVG3));
DOS_G30_WNR= round(dos(FG_WNR3));
DOS_G30_MMW= round(dos(FG_MMW3));
DOS_P30_MED= round(dos(FP_MED3));
DOS_P30_AVG= round(dos(FP_AVG3));
DOS_P30_WNR= round(dos(FP_WNR3));
DOS_P30_MMW= round(dos(FP_MMW3));
DOS_S30_MED= round(dos(FS_MED3));
DOS_S30_AVG= round(dos(FS_AVG3));
DOS_S30_WNR= round(dos(FS_WNR3));
DOS_S30_MMW= round(dos(FS_MMW3));
%10%
DOS_G40_MED= round(dos(FG_MED4));
DOS_G40_AVG= round(dos(FG_AVG4));
DOS_G40_WNR= round(dos(FG_WNR4));
DOS_G40_MMW= round(dos(FG_MMW4));
DOS_P40_MED= round(dos(FP_MED4));
DOS_P40_AVG= round(dos(FP_AVG4));
DOS_P40_WNR= round(dos(FP_WNR4));
DOS_P40_MMW= round(dos(FP_MMW4));
DOS_S40_MED= round(dos(FS_MED4));
DOS_S40_AVG= round(dos(FS_AVG4));
DOS_S40_WNR= round(dos(FS_WNR4));
DOS_S40_MMW= round(dos(FS_MMW4));
%10
DOS_G50_MED= round(dos(FG_MED5));
DOS_G50_AVG= round(dos(FG_AVG5));
DOS_G50_WNR= round(dos(FG_WNR5));
DOS_G50_MMW= round(dos(FG_MMW5));
DOS_P50_MED= round(dos(FP_MED5));
DOS_P50_AVG= round(dos(FP_AVG5));
DOS_P50_WNR= round(dos(FP_WNR5));
DOS_P50_MMW= round(dos(FP_MMW5));
DOS_S50_MED= round(dos(FS_MED5));
DOS_S50_AVG= round(dos(FS_AVG5));
DOS_S50_WNR= round(dos(FS_WNR5));
DOS_S50_MMW= round(dos(FS_MMW5));
%10
DOS_G60_MED= round(dos(FG_MED6));
DOS_G60_AVG= round(dos(FG_AVG6));
DOS_G60_WNR= round(dos(FG_WNR6));
DOS_G60_MMW= round(dos(FG_MMW6));
DOS_P60_MED= round(dos(FP_MED6));
DOS_P60_AVG= round(dos(FP_AVG6));
DOS_P60_WNR= round(dos(FP_WNR6));
DOS_P60_MMW= round(dos(FP_MMW6));
DOS_S60_MED= round(dos(FS_MED6));
DOS_S60_AVG= round(dos(FS_AVG6));
DOS_S60_WNR= round(dos(FS_WNR6));
DOS_S60_MMW= round(dos(FS_MMW6));
%%%
%% show 10% results
% show 10% noise and filtering results
hf=figure
subplot(3,6,1);imshow(imvol,[]);title('Original','Fontsize',12);colormap jet;
subplot(3,6,2);imshow(NG1,[]);title('Gaussian noise 10%','Fontsize',12);colormap jet;
ha=subplot(3,6,3);imshow(FG_MED1,[]);title('Median filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_G10_MED),', CNR= ',num2str(CNR_G10_MED));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,4);imshow(FG_AVG1,[]);title('Mean filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_G10_AVG),', CNR= ',num2str(CNR_G10_AVG));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,5);imshow(FG_WNR1,[]);title('Weiner filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_G10_WNR),', CNR= ',num2str(CNR_G10_WNR));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,6);imshow(FG_MMW1,[]);title('MMWF filer','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_G10_MMW),', CNR= ',num2str(CNR_G10_MMW));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

subplot(3,6,7);imshow(imvol,[]);title('Original','Fontsize',12);colormap jet;
subplot(3,6,8);imshow(NP6,[]);title(["Possion noise=","imnoise(Pixel Value*1.1)"],'Fontsize',12);colormap jet;
ha=subplot(3,6,9),imshow(FP_MED1,[]);title('Median filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_P10_MED),', CNR= ',num2str(CNR_P10_MED));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,10);imshow(FP_AVG1,[]);title('Mean filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_P10_AVG),', CNR= ',num2str(CNR_P10_AVG));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,11);imshow(FP_WNR1,[]);title('Weiner filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_P10_WNR),', CNR= ',num2str(CNR_P10_WNR));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,12);imshow(FP_MMW1,[]);title('MMWF filer','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_P10_MMW),', CNR= ',num2str(CNR_P10_MMW));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

subplot(3,6,13);imshow(imvol,[]);title('Original','Fontsize',12);colormap jet;
subplot(3,6,14);imshow(NS1,[]);title('Speckle noise 10%','Fontsize',12);colormap jet;
ha=subplot(3,6,15);imshow(FS_MED1,[]);title('Median filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_S10_MED),', CNR= ',num2str(CNR_S10_MED));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,16);imshow(FS_AVG1,[]);title('Mean filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_S10_AVG),', CNR= ',num2str(CNR_S10_AVG));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,17);imshow(FS_WNR1,[]);title('Weiner filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_S10_WNR),', CNR= ',num2str(CNR_S10_WNR));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,18);imshow(FS_MMW1,[]);title('MMWF filer','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_S10_MMW),', CNR= ',num2str(CNR_S10_MMW));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

% show 30% noise and filtering results
hf=figure
subplot(3,6,1),imshow(imvol,[]);title('Original','Fontsize',12);colormap jet;
subplot(3,6,2),imshow(NG3,[]);title('Gaussian noise 30%','Fontsize',12);colormap jet;
ha=subplot(3,6,3),imshow(FG_MED3,[]);title('Median filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_G30_MED),', CNR= ',num2str(CNR_G30_MED));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,4),imshow(FG_AVG3,[]);title('Mean filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_G30_AVG),', CNR= ',num2str(CNR_G30_AVG));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,5);imshow(FG_WNR3,[]);title('Weiner filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_G30_WNR),', CNR= ',num2str(CNR_G30_WNR));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,6);imshow(FG_MMW3,[]);title('MMWF filer','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_G30_MMW),', CNR= ',num2str(CNR_G30_MMW));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

subplot(3,6,7);imshow(imvol,[]);title('Original','Fontsize',12);colormap jet;
subplot(3,6,8);imshow(NP6,[]);title(["Possion noise=","imnoise(Pixel Value*1.3)"],'Fontsize',12);colormap jet;
ha=subplot(3,6,9);imshow(FP_MED3,[]);title('Median filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_P30_MED),', CNR= ',num2str(CNR_P30_MED));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,10);imshow(FP_AVG3,[]);title('Mean filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_P30_AVG),', CNR= ',num2str(CNR_P30_AVG));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,11);imshow(FP_WNR3,[]);title('Weiner filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_P30_WNR),', CNR= ',num2str(CNR_P30_WNR));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,12);imshow(FP_MMW3,[]);title('MMWF filer','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_P30_MMW),', CNR= ',num2str(CNR_P30_MMW));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

subplot(3,6,13);imshow(imvol,[]);title('Original','Fontsize',12);colormap jet;
subplot(3,6,14);imshow(NS3,[]);title('Speckle noise 30%','Fontsize',12);colormap jet;
ha=subplot(3,6,15);imshow(FS_MED3,[]);title('Median filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_S30_MED),', CNR= ',num2str(CNR_S30_MED));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,16);imshow(FS_AVG3,[]);title('Mean filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_S30_AVG),', CNR= ',num2str(CNR_S30_AVG));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,17);imshow(FS_WNR3,[]);title('Weiner filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_S30_WNR),', CNR= ',num2str(CNR_S30_WNR));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,18);imshow(FS_MMW3,[]);title('MMWF filer','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_S30_MMW),', CNR= ',num2str(CNR_S30_MMW));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

% show 60% noise and filtering results
hf=figure
subplot(3,6,1);imshow(imvol,[]);title('Original','Fontsize',12);colormap jet;
subplot(3,6,2);imshow(NG6,[]);title('Gaussian noise 60%','Fontsize',12);colormap jet;
ha=subplot(3,6,3);imshow(FG_MED6,[]);title('Median filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_G60_MED),', CNR= ',num2str(CNR_G60_MED));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,4);imshow(FG_AVG6,[]);title('Mean filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_G60_AVG),', CNR= ',num2str(CNR_G60_AVG));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,5);imshow(FG_WNR6,[]);title('Weiner filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_G60_WNR),', CNR= ',num2str(CNR_G60_WNR));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,6);imshow(FG_MMW6,[]);title('MMWF filer','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_G60_MMW),', CNR= ',num2str(CNR_G60_MMW));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

subplot(3,6,7);imshow(imvol,[]);title('Original','Fontsize',12);colormap jet;
subplot(3,6,8);imshow(NP6,[]);title(["Possion noise=","imnoise(Pixel Value*1.6)"],'Fontsize',12);colormap jet;
ha=subplot(3,6,9);imshow(FP_MED6,[]);title('Median filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_P60_MED),', CNR= ',num2str(CNR_P60_MED));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,10);imshow(FP_AVG6,[]);title('Mean filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_P60_AVG),', CNR= ',num2str(CNR_P60_AVG));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,11);imshow(FP_WNR6,[]);title('Weiner filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_P60_WNR),', CNR= ',num2str(CNR_P60_WNR));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,12);imshow(FP_MMW6,[]);title('MMWF filer','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_P60_MMW),', CNR= ',num2str(CNR_P60_MMW));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

subplot(3,6,13);imshow(imvol,[]);title('Original','Fontsize',12);colormap jet;
subplot(3,6,14);imshow(NS6,[]);title('Speckle noise 60%','Fontsize',12);colormap jet;
ha=subplot(3,6,15);imshow(FS_MED6,[]);title('Median filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_S60_MED),', CNR= ',num2str(CNR_S60_MED));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,16);imshow(FS_AVG6,[]);title('Mean filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_S60_AVG),', CNR= ',num2str(CNR_S60_AVG));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,17);imshow(FS_WNR6,[]);title('Weiner filter','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_S60_WNR),', CNR= ',num2str(CNR_S60_WNR));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');

ha=subplot(3,6,18);imshow(FS_MMW6,[]);title('MMWF filer','Fontsize',12);colormap jet;
pos = get(ha, 'position');pos(2)=pos(2)-0.08;pos(1)=pos(1)+0.01;
txt=strcat('PSNR= ',num2str(PSNR_S60_MMW),', CNR= ',num2str(CNR_S60_MMW));
annotation(hf, 'textbox', pos, 'String', num2str(txt), 'vert', 'bottom', 'EdgeColor','none','FontSize',12,'FitBoxToText','off');
%% Export to excel sheet
% PSNR
filename = 'Filtering.xlsx';
T1 = table({PSNR_G10_MED},{PSNR_G20_MED},{PSNR_G30_MED},{PSNR_G40_MED},{PSNR_G50_MED},{PSNR_G60_MED});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B3:G3'));
T1 = table({PSNR_G10_AVG},{PSNR_G20_AVG},{PSNR_G30_AVG},{PSNR_G40_AVG},{PSNR_G50_AVG},{PSNR_G60_AVG});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B4:G4'));
T1 = table({PSNR_G10_WNR},{PSNR_G20_WNR},{PSNR_G30_WNR},{PSNR_G40_WNR},{PSNR_G50_WNR},{PSNR_G60_WNR});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B5:G5'));
T1 = table({PSNR_G10_MMW},{PSNR_G20_MMW},{PSNR_G30_MMW},{PSNR_G40_MMW},{PSNR_G50_MMW},{PSNR_G60_MMW});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B6:G6'));
%
T1 = table({PSNR_P10_MED},{PSNR_P20_MED},{PSNR_P30_MED},{PSNR_P40_MED},{PSNR_P50_MED},{PSNR_P60_MED});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B10:G10'));
T1 = table({PSNR_P10_AVG},{PSNR_P20_AVG},{PSNR_P30_AVG},{PSNR_P40_AVG},{PSNR_P50_AVG},{PSNR_P60_AVG});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B11:G11'));
T1 = table({PSNR_P10_WNR},{PSNR_P20_WNR},{PSNR_P30_WNR},{PSNR_P40_WNR},{PSNR_P50_WNR},{PSNR_P60_WNR});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B12:G12'));
T1 = table({PSNR_P10_MMW},{PSNR_P20_MMW},{PSNR_P30_MMW},{PSNR_P40_MMW},{PSNR_P50_MMW},{PSNR_P60_MMW});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B13:G13'));
%
T1 = table({PSNR_S10_MED},{PSNR_S20_MED},{PSNR_S30_MED},{PSNR_S40_MED},{PSNR_S50_MED},{PSNR_S60_MED});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B17:G17'));
T1 = table({PSNR_S10_AVG},{PSNR_S20_AVG},{PSNR_S30_AVG},{PSNR_S40_AVG},{PSNR_S50_AVG},{PSNR_S60_AVG});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B18:G18'));
T1 = table({PSNR_S10_WNR},{PSNR_S20_WNR},{PSNR_S30_WNR},{PSNR_S40_WNR},{PSNR_S50_WNR},{PSNR_S60_WNR});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B19:G19'));
T1 = table({PSNR_S10_MMW},{PSNR_S20_MMW},{PSNR_S30_MMW},{PSNR_S40_MMW},{PSNR_S50_MMW},{PSNR_S60_MMW});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B20:G20'));
% MSE
filename = 'Filtering.xlsx';
T1 = table({MSE_G10_MED},{MSE_G20_MED},{MSE_G30_MED},{MSE_G40_MED},{MSE_G50_MED},{MSE_G60_MED});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('K3:P3'));
T1 = table({MSE_G10_AVG},{MSE_G20_AVG},{MSE_G30_AVG},{MSE_G40_AVG},{MSE_G50_AVG},{MSE_G60_AVG});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('K4:P4'));
T1 = table({MSE_G10_WNR},{MSE_G20_WNR},{MSE_G30_WNR},{MSE_G40_WNR},{MSE_G50_WNR},{MSE_G60_WNR});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('K5:P5'));
T1 = table({MSE_G10_MMW},{MSE_G20_MMW},{MSE_G30_MMW},{MSE_G40_MMW},{MSE_G50_MMW},{MSE_G60_MMW});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('K6:P6'));
%
T1 = table({MSE_P10_MED},{MSE_P20_MED},{MSE_P30_MED},{MSE_P40_MED},{MSE_P50_MED},{MSE_P60_MED});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('K10:P10'));
T1 = table({MSE_P10_AVG},{MSE_P20_AVG},{MSE_P30_AVG},{MSE_P40_AVG},{MSE_P50_AVG},{MSE_P60_AVG});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('K11:P11'));
T1 = table({MSE_P10_WNR},{MSE_P20_WNR},{MSE_P30_WNR},{MSE_P40_WNR},{MSE_P50_WNR},{MSE_P60_WNR});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('K12:P12'));
T1 = table({MSE_P10_MMW},{MSE_P20_MMW},{MSE_P30_MMW},{MSE_P40_MMW},{MSE_P50_MMW},{MSE_P60_MMW});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('K13:P13'));
%
T1 = table({MSE_S10_MED},{MSE_S20_MED},{MSE_S30_MED},{MSE_S40_MED},{MSE_S50_MED},{MSE_S60_MED});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('K17:P17'));
T1 = table({MSE_S10_AVG},{MSE_S20_AVG},{MSE_S30_AVG},{MSE_S40_AVG},{MSE_S50_AVG},{MSE_S60_AVG});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('K18:P18'));
T1 = table({MSE_S10_WNR},{MSE_S20_WNR},{MSE_S30_WNR},{MSE_S40_WNR},{MSE_S50_WNR},{MSE_S60_WNR});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('K19:P19'));
T1 = table({MSE_S10_MMW},{MSE_S20_MMW},{MSE_S30_MMW},{MSE_S40_MMW},{MSE_S50_MMW},{MSE_S60_MMW});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('K20:P20'));
% CNR
filename = 'Filtering.xlsx';
T1 = table({CNR_G10_MED},{CNR_G20_MED},{CNR_G30_MED},{CNR_G40_MED},{CNR_G50_MED},{CNR_G60_MED});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('T3:Y3'));
T1 = table({CNR_G10_AVG},{CNR_G20_AVG},{CNR_G30_AVG},{CNR_G40_AVG},{CNR_G50_AVG},{CNR_G60_AVG});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('T4:Y4'));
T1 = table({CNR_G10_WNR},{CNR_G20_WNR},{CNR_G30_WNR},{CNR_G40_WNR},{CNR_G50_WNR},{CNR_G60_WNR});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('T5:Y5'));
T1 = table({CNR_G10_MMW},{CNR_G20_MMW},{CNR_G30_MMW},{CNR_G40_MMW},{CNR_G50_MMW},{CNR_G60_MMW});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('T6:Y6'));
%
T1 = table({CNR_P10_MED},{CNR_P20_MED},{CNR_P30_MED},{CNR_P40_MED},{CNR_P50_MED},{CNR_P60_MED});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('T10:Y10'));
T1 = table({CNR_P10_AVG},{CNR_P20_AVG},{CNR_P30_AVG},{CNR_P40_AVG},{CNR_P50_AVG},{CNR_P60_AVG});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('T11:Y11'));
T1 = table({CNR_P10_WNR},{CNR_P20_WNR},{CNR_P30_WNR},{CNR_P40_WNR},{CNR_P50_WNR},{CNR_P60_WNR});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('T12:Y12'));
T1 = table({CNR_P10_MMW},{CNR_P20_MMW},{CNR_P30_MMW},{CNR_P40_MMW},{CNR_P50_MMW},{CNR_P60_MMW});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('T13:Y13'));
%
T1 = table({CNR_S10_MED},{CNR_S20_MED},{CNR_S30_MED},{CNR_S40_MED},{CNR_S50_MED},{CNR_S60_MED});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('T17:Y17'));
T1 = table({CNR_S10_AVG},{CNR_S20_AVG},{CNR_S30_AVG},{CNR_S40_AVG},{CNR_S50_AVG},{CNR_S60_AVG});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('T18:Y18'));
T1 = table({CNR_S10_WNR},{CNR_S20_WNR},{CNR_S30_WNR},{CNR_S40_WNR},{CNR_S50_WNR},{CNR_S60_WNR});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('T19:Y19'));
T1 = table({CNR_S10_MMW},{CNR_S20_MMW},{CNR_S30_MMW},{CNR_S40_MMW},{CNR_S50_MMW},{CNR_S60_MMW});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('T20:Y20'));
%
%% Contrast Resolution CR
% CR
filename = 'Filtering.xlsx';
T1 = table({CR_G10_MED},{CR_G20_MED},{CR_G30_MED},{CR_G40_MED},{CR_G50_MED},{CR_G60_MED});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AC3:AH3'));
T1 = table({CR_G10_AVG},{CR_G20_AVG},{CR_G30_AVG},{CR_G40_AVG},{CR_G50_AVG},{CR_G60_AVG});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AC4:AH4'));
T1 = table({CR_G10_WNR},{CR_G20_WNR},{CR_G30_WNR},{CR_G40_WNR},{CR_G50_WNR},{CR_G60_WNR});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AC5:AH5'));
T1 = table({CR_G10_MMW},{CR_G20_MMW},{CR_G30_MMW},{CR_G40_MMW},{CR_G50_MMW},{CR_G60_MMW});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AC6:AH6'));
%
T1 = table({CR_P10_MED},{CR_P20_MED},{CR_P30_MED},{CR_P40_MED},{CR_P50_MED},{CR_P60_MED});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AC10:AH10'));
T1 = table({CR_P10_AVG},{CR_P20_AVG},{CR_P30_AVG},{CR_P40_AVG},{CR_P50_AVG},{CR_P60_AVG});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AC11:AH11'));
T1 = table({CR_P10_WNR},{CR_P20_WNR},{CR_P30_WNR},{CR_P40_WNR},{CR_P50_WNR},{CR_P60_WNR});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AC12:AH12'));
T1 = table({CR_P10_MMW},{CR_P20_MMW},{CR_P30_MMW},{CR_P40_MMW},{CR_P50_MMW},{CR_P60_MMW});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AC13:AH13'));
%
T1 = table({CR_S10_MED},{CR_S20_MED},{CR_S30_MED},{CR_S40_MED},{CR_S50_MED},{CR_S60_MED});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AC17:AH17'));
T1 = table({CR_S10_AVG},{CR_S20_AVG},{CR_S30_AVG},{CR_S40_AVG},{CR_S50_AVG},{CR_S60_AVG});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AC18:AH18'));
T1 = table({CR_S10_WNR},{CR_S20_WNR},{CR_S30_WNR},{CR_S40_WNR},{CR_S50_WNR},{CR_S60_WNR});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AC19:AH19'));
T1 = table({CR_S10_MMW},{CR_S20_MMW},{CR_S30_MMW},{CR_S40_MMW},{CR_S50_MMW},{CR_S60_MMW});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AC20:AH20'));
%
%% Degree of smoothness DOS
% DOS
filename = 'Filtering.xlsx';
T1 = table({DOS_G10_MED},{DOS_G20_MED},{DOS_G30_MED},{DOS_G40_MED},{DOS_G50_MED},{DOS_G60_MED});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AL3:AQ3'));
T1 = table({DOS_G10_AVG},{DOS_G20_AVG},{DOS_G30_AVG},{DOS_G40_AVG},{DOS_G50_AVG},{DOS_G60_AVG});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AL4:AQ4'));
T1 = table({DOS_G10_WNR},{DOS_G20_WNR},{DOS_G30_WNR},{DOS_G40_WNR},{DOS_G50_WNR},{DOS_G60_WNR});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AL5:AQ5'));
T1 = table({DOS_G10_MMW},{DOS_G20_MMW},{DOS_G30_MMW},{DOS_G40_MMW},{DOS_G50_MMW},{DOS_G60_MMW});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AL6:AQ6'));
%
T1 = table({DOS_P10_MED},{DOS_P20_MED},{DOS_P30_MED},{DOS_P40_MED},{DOS_P50_MED},{DOS_P60_MED});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AL10:AQ10'));
T1 = table({DOS_P10_AVG},{DOS_P20_AVG},{DOS_P30_AVG},{DOS_P40_AVG},{DOS_P50_AVG},{DOS_P60_AVG});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AL11:AQ11'));
T1 = table({DOS_P10_WNR},{DOS_P20_WNR},{DOS_P30_WNR},{DOS_P40_WNR},{DOS_P50_WNR},{DOS_P60_WNR});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AL12:AQ12'));
T1 = table({DOS_P10_MMW},{DOS_P20_MMW},{DOS_P30_MMW},{DOS_P40_MMW},{DOS_P50_MMW},{DOS_P60_MMW});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AL13:AQ13'));
%
T1 = table({DOS_S10_MED},{DOS_S20_MED},{DOS_S30_MED},{DOS_S40_MED},{DOS_S50_MED},{DOS_S60_MED});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AL17:AQ17'));
T1 = table({DOS_S10_AVG},{DOS_S20_AVG},{DOS_S30_AVG},{DOS_S40_AVG},{DOS_S50_AVG},{DOS_S60_AVG});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AL18:AQ18'));
T1 = table({DOS_S10_WNR},{DOS_S20_WNR},{DOS_S30_WNR},{DOS_S40_WNR},{DOS_S50_WNR},{DOS_S60_WNR});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AL19:AQ19'));
T1 = table({DOS_S10_MMW},{DOS_S20_MMW},{DOS_S30_MMW},{DOS_S40_MMW},{DOS_S50_MMW},{DOS_S60_MMW});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AL20:AQ20'));
%

disp('Data has been written to excel sheet, check Filtering.xlsx in the current folder!');