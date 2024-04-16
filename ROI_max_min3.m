%[mask1,poly, smoothedPoly]=ROI_max_min(msk,I,n,meanBG)
function  [All_masks,bw, poly, smoothedPoly,bw1,poly1,smoothedPoly1]=ROI_max_min3(imvol,max_img,min_img,meanBG,sp,imvol2)
I2=max_img;
load maskallparam numofIter numofIterRG XD YD
itrMx=max(numofIter);
itrMn=min(numofIter);
itrMxRG=max(numofIterRG);
itrMnRG=min(numofIterRG);
%I2=medfilt2(I2,[5 5]);
%s=strel('disk',1);
%I3=imopen(I2,fliplr(s));
I3=imfilter(I2,[0 -1 0;-1 5 -1;0 -1 0]);
    %figure(31), imshow(im2uint8(mat2gray(I2)),[]) , hold all,colormap(jet),colorbar, title("Pick a centered seed in this Image");
        [poly, mask, smoothedPoly,sp] = regionGrowing3(im2uint8(mat2gray(I3)),1,sp,itrMx,itrMxRG);
        waitfor(poly);
         bw=mask; 
%if (n==1)
I2=min_img;

%I2=medfilt2(I,[5 5]);
%s=strel('disk',1);
%I3=imopen(I2,fliplr(s));
I3=imfilter(I2,[0 -1 0;-1 5 -1;0 -1 0]);
sp1=sp;
sp1(1,2)=sp(1,2)-7*YD;
sp1(1,1)=sp(1,1)-7*XD;
%elseif (n==2)
    %figure(41), imshow(im2uint8(mat2gray(I)),[]) , hold all,colormap(jet),colorbar, title("Pick a centered seed in this Min Image");
    [poly1, mask2, smoothedPoly1,sp] = regionGrowing3(im2uint8(mat2gray(I3)),2,sp1,itrMn,itrMnRG);
    waitfor(poly);
    bw1=mask2;
    %bw1(bw==0)=0; 
%end

%[roiwindow]=example4(I,poly);
%figure,imshow(mask,[]);

 All_masks=mask_all3(imvol,sp,imvol2);

        
end
%load mask mask;

