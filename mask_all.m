function  All_masks=mask_all(imvol,sp1,imvol2,bw)
load maskallparam XD YD numofIter numofIterRG
maxIter=max(numofIter);
minIter=min(numofIter);
maxIterRG=max(numofIterRG);
minIterRG=min(numofIterRG);
All_masks=uint16(zeros(size(imvol)));
    y=(zeros(1,16));y1=y;
    y(1:16)=sum(sum(imvol2(:,:,1:16)));
    y1(1)=y(1); y1(end)=y(end);
    for i=2:15
       y1(i)=round(((y(i-1)+y(i))+y(i+1))/3);
    end
    y=y1;
    mx1=max((y));
    mx1=mx1(1);
    mn1=min((y));
    mn1=mn1(1);
    %% if you want to enable lookup table please uncomment these
    numofIter=round(maxIter*((y-mn1)/(mx1-mn1)));

    numofIter(numofIter<=11 & numofIter>7)=11;
    numofIter(numofIter<=7)=minIter;
%     if (numofIter(1)<numofIter(end))
%         numofIter(1)=numofIter(end)
%     end
    %%
    %numofIter(numofIter(10:16))=sort(numofIter(numofIter(10:16)));
    %numofIter(numofIter(1:11))=sort(numofIter(numofIter(1:11)),'descend')
%%
numofIterRG=maxIterRG.*(numofIter./max(numofIter));
%%
sp=zeros(16,2);
sp(1,:)=sp1(1,:);% First point (max seed point) the same
for i=2:8
sp(i,2)=sp(i-1,2)-YD;% X displacement 
sp(i,1)=sp(i-1,1)-XD;% Y displacement 
end
for i=9:16
sp(i,2)=sp(i-1,2)+YD;% X displacement 
sp(i,1)=sp(i-1,1)+XD;% Y displacement 
end
for i=1:16
    [a,All_masks(:,:,i),b,c,energy(i)] = regionGrowing2(im2uint8(mat2gray((imvol(:,:,i)))),3,sp(i,:),numofIter(:,i),numofIterRG(:,i));
    %[a,All_masks(:,:,i),b,c] = regionGrowing2(im2uint8(mat2gray((imvol(:,:,i)))),3,sp,8);
end
load prepost1 tag11
if (tag11==0)
    save energyPre energy numofIter 
else
    save energyPost energy numofIter
end

energy
