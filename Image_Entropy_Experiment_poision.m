m_val=2; r_val=1;
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
figure
[a,B, C, D,min_img2,F,imvolmn2,bw1, AA, AB, AC, AD, AE, AF,AG, AH, AI, aj, sp]=max_min_MUGA3(imvol,0,sp,[],[]);
bw1=(bw1);
for i=1:1:info.NumberOfFrames
  imvol1(:,:,i)=uint16(bw1).*imvol(:,:,i);%
end
close
imshow(sum(imvol1,3),[]);colormap jet;colorbar
I1=imvol1;
I2=uint16(imvol1*1.11);
I3=uint16(imvol1*1.15);
I4=uint16(imvol1*1.2);
I5=uint16(imvol1*1.25);
I6=uint16(imvol1*1.3);
I7=uint16(imvol1*1.35);

f1 = @(x) imnoise(x,'poisson');
for i=1:16
I2(:,:,i)=roifilt2(I2(:,:,i),bw1,f1);
I3(:,:,i)=roifilt2(I3(:,:,i),bw1,f1);
I4(:,:,i)=roifilt2(I4(:,:,i),bw1,f1);
I5(:,:,i)=roifilt2(I5(:,:,i),bw1,f1);
I6(:,:,i)=roifilt2(I6(:,:,i),bw1,f1);
I7(:,:,i)=roifilt2(I7(:,:,i),bw1,f1);
end
figure
subplot(2,3,1),imshow(sum(I2,3),[0 800]);title('noise level 1');colormap jet;colorbar
subplot(2,3,2),imshow(sum(I3,3),[0 800]);title('noise level 2');colormap jet;colorbar
subplot(2,3,3),imshow(sum(I4,3),[0 800]);title('noise level 3');colormap jet;colorbar
subplot(2,3,4),imshow(sum(I5,3),[0 800]);title('noise level 4');colormap jet;colorbar
subplot(2,3,5),imshow(sum(I6,3),[0 800]);title('noise level 5');colormap jet;colorbar
subplot(2,3,6),imshow(sum(I7,3),[0 800]);title('noise level 6');colormap jet;colorbar
I11=sum(I1,3);
I12=sum(I2,3);
I13=sum(I3,3);
I14=sum(I4,3);
I15=sum(I5,3);
I16=sum(I6,3);
I17=sum(I7,3);

s1=(I11(bw1));
s2=(I12(bw1));
s3=(I13(bw1));
s4=(I14(bw1));
s5=(I15(bw1));
s6=(I16(bw1));
s7=(I17(bw1));


%[,Sync_post]=computeEntropySynchrony(s1,-1,-1,0)
[Ent1 syn1]=computeEntropySynchronyNo(I1);
[Ent2 syn2]=computeEntropySynchronyNo(I2);
[Ent3 syn3]=computeEntropySynchronyNo(I3);
[Ent4 syn4]=computeEntropySynchronyNo(I4);
[Ent5 syn5]=computeEntropySynchronyNo(I5);
[Ent6 syn6]=computeEntropySynchronyNo(I6);
[Ent7 syn7]=computeEntropySynchronyNo(I7);


ApEnPost1= ApEn_slow(s1, m_val,r_val*std(s1));
ApEnPost2= ApEn_slow(s2, m_val,r_val*std(s2));
ApEnPost3= ApEn_slow(s3, m_val,r_val*std(s3));
ApEnPost4= ApEn_slow(s4, m_val,r_val*std(s4));
ApEnPost5= ApEn_slow(s5, m_val,r_val*std(s5));
ApEnPost6= ApEn_slow(s6, m_val,r_val*std(s6));
ApEnPost7= ApEn_slow(s7, m_val,r_val*std(s7));

[BoundApEnPost1,epsilonPost1,LspsilonPost1]=BoundedProcess(s1);
[BoundApEnPost2,epsilonPost2,LspsilonPost2]=BoundedProcess(s2);
[BoundApEnPost3,epsilonPost3,LspsilonPost3]=BoundedProcess(s3);
[BoundApEnPost4,epsilonPost4,LspsilonPost4]=BoundedProcess(s4);
[BoundApEnPost5,epsilonPost5,LspsilonPost5]=BoundedProcess(s5);
[BoundApEnPost6,epsilonPost6,LspsilonPost6]=BoundedProcess(s6);
[BoundApEnPost7,epsilonPost7,LspsilonPost7]=BoundedProcess(s7);
[Ent1 Ent2 Ent3 Ent4 Ent5 Ent6 Ent7]
[ApEnPost1 ApEnPost2 ApEnPost3 ApEnPost4 ApEnPost5 ApEnPost6 ApEnPost7]
[BoundApEnPost1 BoundApEnPost2 BoundApEnPost3 BoundApEnPost4 BoundApEnPost5 BoundApEnPost6 BoundApEnPost7]
[syn1 syn2 syn3 syn4 syn5 syn6 syn7]
filename = 'ImageNoiseEntropyExperimentPoisson.xlsx';
T1 = table({Ent1},{Ent2},{Ent3},{Ent4},{Ent5},{Ent6},{Ent7});
%system('taskkill /F /IM EXCEL.EXE');
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B2:H2'));
T1 = table({ApEnPost1},{ApEnPost2},{ApEnPost3},{ApEnPost4},{ApEnPost5},{ApEnPost6},{ApEnPost7});
%system('taskkill /F /IM EXCEL.EXE');
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B3:H3'));
T1 = table({BoundApEnPost1},{BoundApEnPost2},{BoundApEnPost3},{BoundApEnPost4},{BoundApEnPost5},{BoundApEnPost6},{BoundApEnPost7});
%system('taskkill /F /IM EXCEL.EXE');
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B4:H4'));
T1 = table({syn1},{syn2},{syn3},{syn4},{syn5},{syn6},{syn7});
%system('taskkill /F /IM EXCEL.EXE');
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B5:H4'));
disp('Data has been written to excel sheet, check ImageNoiseEntropyExperimentPoisson.xlsx in the current folder!');
