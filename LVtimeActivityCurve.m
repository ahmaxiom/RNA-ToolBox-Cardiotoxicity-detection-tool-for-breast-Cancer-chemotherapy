function [mx1,mn1,indMax,indMin,weight,yy]= LVtimeActivityCurve(imvolx,z,z2,z3,test)
% this function is to draw the LV time activity curve %
load info info
FrameTime=info.GatedInformationSequence.Item_1.DataInformationSequence.Item_1.FrameTime;
x=FrameTime:FrameTime:16*FrameTime;
y=(zeros(1,info.NumberOfFrames));
%for i=1:info.NumberOfFrames

   y(1:info.NumberOfFrames)=sum(sum(imvolx(:,:,1:info.NumberOfFrames)));
   y(12)=mean(y(11:14));
   y(13)=mean(y(12:14));
   mx1=max((y));
   mx1=mx1(1);
   mn1=min((y));
   mn1=mn1(1);
%    y1=y;
%    y1(y==mn1)=[];
%    if ~isempty(z3)
%       mn2=min((y1));
%       mn2=mn2(1);
%       mn1p=mn1;
%       mn1=mn1+mn2;
%    else
%       mn1p=mn1;
%    end
   
   indMax=find(mx1==y);
   indMin=find(mn1==y);
   %sum(sum(imvolx(:,:,indMax)))
   %sum(sum(imvolx(:,:,indMin)))

if (z2==0 | z2==2)
else
imvolx=z2;
   y(1:info.NumberOfFrames)=sum(sum(imvolx(:,:,1:info.NumberOfFrames)));
   y(12)=mean(y(11:14));
   y(13)=mean(y(12:14));
   mx1=y(indMax);
   mx1=mx1(1);
   mn1=y(indMin);
   mn1=mn1(1);
   y1=y;
   y1(y==mn1)=[];
   if ~isempty(z3)
      mn2=min((y1));
      mn2=mn2(1);
      mn1=mn1+mn2;
   end
   %sum(sum(imvolx(:,:,indMax)))
   %sum(sum(imvolx(:,:,indMin)))
   end
%
yy = smooth(y);
if (z2==0 & (test~=1))
%plot(x,y,'-*b');
%hold on;
plot(x,yy,'-*r');
if (z==1) 
    title('Post LV Time activity curve');
else
    title('Pre LV Time activity curve');
end
mx=max(y);
mn=min(y);
axis([x(1) x(end) 0 mx]);
xlabel('Time (msec)');
ylabel('Count (count)');
%legend('Original Curve','Smoothed Curve',...
%       'Location','SW')
legend('Smoothed Curve',...
       'Location','SW')
clear info
end
if (z==1)
save curvePost x y yy
elseif (z==2)
save curvePre x y yy
end
weight=zeros(1,16);
if (test==1)
   val=(y-yy)/y;
   for i=1:16
      if val(i)>=3 weight(i)=3;
      elseif val(i)>=2 weight(i)=2;
      elseif val(i)>=0 weight(i)=1;
      elseif val(i)<0 && val(i)>=-1 weight(i)=-1;
      elseif val(i)<-1 && val(i)>=-2 weight(i)=-2;
      elseif val(i)<-2 && val(i)>=-3 weight(i)=-2;
      end
   end
end