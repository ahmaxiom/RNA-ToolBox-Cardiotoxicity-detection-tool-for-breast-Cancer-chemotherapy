%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Entropy & Synchrony Calculation %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [entropy,synchrony]=computeEntropySynchrony(vol,par1,par2,par3)
[m n l]=size(vol);
  vectora = zeros(m,n);
  vectorb = zeros(m,n);
  %create a temporary array for image statistics for each loop
  temparray = uint16(zeros(1,l));
  %create a permanant array of amplitudes and initialise it to 0
  amparr = zeros(m,n);
  %create a permanant array of phases and initialise it to 0
  phasearr = zeros(m,n);
  %initialise a counter
  c = 0;
  volx=sum(vol,3);
  for x = 1:1:m

    for y = 1:1:n

      temparray(:) = 0;
      for i = 1:1:l
        if (volx(x,y,1) ~= 0)
          temparray(i) = vol(x ,y,i );
        end%if
      end% for
      % this calculates the amplitude and the phase in the image
     % temparray = medfilt2(temparray,[2 2]);

      maxvalue=max(temparray);
     if(maxvalue~=0)
      maxPoint=find(maxvalue==temparray);
      maxlocation=ind2sub(size(temparray),maxPoint);
      tt=temparray;
      tt(temparray==0)=[];
      minvalue=min(tt);
      minPoint=find(minvalue==temparray);
     % minlocation=ind2sub(size(temparray),minPoint)
      amparr(x,y ) = maxvalue - minvalue;
      phasearr(x,y) = minPoint(1);
      % this calculates the parameters necessary for the synchrony of the heart
      if (volx(x ,y ,1) ~= 0)

        vectora(x ,y ) = amparr(x ,y ) .* cos(phasearr(x ,y ) ./ 2 .* pi);
        vectorb(x ,y ) = amparr(x ,y ) .* sin(phasearr(x ,y ) ./ 2 .* pi);
        c = c + 1;
      end%if
     end
    end% for

  end% for
  save phasearr phasearr vectora vectorb volx
if (par1==-1&par3==10)
    %load ind_max ind_max
    load prepost tag
 figure
      subplot(2,2,1),imshow(volx,[]),colormap('gray');colorbar;
      if (tag==0) 
          title('Pre ROI image');
      else
          title('Post ROI image');
      end
      A=rad2deg(atan((vectorb+1)./(vectora+1)));
      A2=sqrt((vectora.^2)+(vectorb.^2));
      %A3=im2bw(sum(A,3),0.01);
      subplot(2,2,2),imshow(abs(A),[0  10]),colormap('jet');colorbar;
      if (tag==0)
        title('Pre Phase image');
      else
        title('Post Phase image');
      end
      subplot(2,2,3),
      [counts, grayLevels] = MyHistogram(abs(A),A2);
      %hist(A);
      if (tag==0)
        title('Pre Phase histogram');
      else
        title('Post Phase histogram'); 
      end
      %ss=hist(A);
     % axis([0 360 0 max(counts)])
      xlabel('degree', 'FontSize', 10);
      ylabel('frequency', 'FontSize', 10);
      subplot(2,2,4),
      histogram(abs(A),360);
      axis([0 360 0 max(counts)]);
      %imshow(A2,[])
      xlabel('degree', 'FontSize', 10);
      ylabel('frequency', 'FontSize', 10);
      %A=phasearr;
end
% A1=rad2deg(angle(fft(A)));
% hist(A)
%  for i=1:size(A,1)
% if (A(i)<0) 
% A2(i)=(180-A(i));
% end
% if (A(i)>0)
% A2(i)=(A(i));
% end
% end
  %this calculates the parameters necessary for the entropy of the heart
  phasearr1=phasearr(phasearr~=0);
  u=unique(phasearr1);
  histV=zeros(size(u));
  for i=1:size(phasearr1,1)
  
      for k=1:size(u,1)
          if(u(k)==phasearr1(i))
              histV(k)=histV(k)+1;  
          end
      end
  end
%  histV = imhist(uint8(unique(phasearr1)),info.NumberOfFrames);
  phist = histV ./ sum(histV);
  p=phist(phist~=0);
  %this calculates entropy
  entropy = -sum(p.*log2(p))/log2(l);


  %this calculates synchrony
  denominator = sum(sum(sqrt(vectora.^2 + vectorb.^2)));
  toti = sum(sum(abs(vectora)));
  totj = sum(sum(abs(vectorb)));
  numerator = sqrt(toti.^2 + totj.^2);
  synchrony = (numerator ./ denominator);
  