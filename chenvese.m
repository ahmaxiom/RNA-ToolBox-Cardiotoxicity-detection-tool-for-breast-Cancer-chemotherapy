%==========================================================================
%
%   Active contour with Chen-Vese Method 
%   for image segementation
%
%   Implemented by Yue Wu (yue.wu@tufts.edu)
%   Tufts University
%   Feb 2009
%   http://sites.google.com/site/rexstribeofimageprocessing/
% 
%   all rights reserved 
%   Last update 02/26/2009
%--------------------------------------------------------------------------
%   Usage of varibles:
%   input: 
%       I           = any gray/double/RGB input image
%       mask        = initial mask, either customerlized or built-in
%       num_iter    = total number of iterations
%       mu          = weight of length term
%       method      = submethods pick from ('chen','vector','multiphase')
%
%   Types of built-in mask functions
%       'small'     = create a small circular mask
%       'medium'    = create a medium circular mask
%       'large'     = create a large circular mask
%       'whole'     = create a mask with holes around
%       'whole+small' = create a two layer mask with one layer small
%                       circular mask and the other layer with holes around
%                       (only work for method 'multiphase')
%   Types of methods
%       'chen'      = general CV method
%       'vector'    = CV method for vector image
%       'multiphase'= CV method for multiphase (2 phases applied here)
%
%   output: 
%       phi0        = updated level set function 
%
%--------------------------------------------------------------------------
%
% Description: This code implements the paper: "Active Contours Without
% Edges" by Chan and Vese for method 'chen', the paper:"Active Contours Without
% Edges for vector image" by Chan and Vese for method 'vector', and the paper
% "A Multiphase Level Set Framework for Image Segmentation Using the 
% Mumford and Shah Model" by Chan and Vese. 
%
%--------------------------------------------------------------------------
% Deomo: Please see HELP file for details
%==========================================================================
function [seg force] = chenvese(I,mask,num_iter,mu,method)
%%
%-- Default settings
%   length term mu = 0.2 and default method = 'chan'
  if(~exist('mu','var')) 
    mu=0.2; 
  end
  
  if(~exist('method','var')) 
    method = 'chan'; 
  end
%-- End default settings
%%
%-- Initializations on input image I and mask
%  resize original image
   s = 200./min(size(I,1),size(I,2)); % resize scale
   if s<1
       I = imresize(I,s);
   end
  
%   auto mask settings
  if ischar(mask)
      switch lower (mask)
          case 'small'
              mask = maskcircle2(I,'small');
          case 'medium'
              mask = maskcircle2(I,'medium');
          case 'large'
              mask = maskcircle2(I,'large');              
          case 'whole'
              mask = maskcircle2(I,'whole'); 
              %mask = init_mask(I,30);      
          case 'whole+small'
              m1 = maskcircle2(I,'whole');
              m2 = maskcircle2(I,'small');
              mask = zeros(size(I,1),size(I,2),2);
              mask(:,:,1) = m1(:,:,1);
              mask(:,:,2) = m2(:,:,2);
          otherwise
              error('unrecognized mask shape name (MASK).');
      end
  else
      if s<1
          mask = imresize(mask,s);
      end
      if size(mask,1)>size(I,1) || size(mask,2)>size(I,2)
          error('dimensions of mask unmathch those of the image.')
      end
      switch lower(method)
          case 'multiphase'
              if  (size(mask,3) == 1)  
                  error('multiphase requires two masks but only gets one.')
              end
      end
  end       
  
switch lower(method)
    case 'chan'
        if size(I,3)== 3
            P = rgb2gray(uint8(I));
            P = double(P);
        elseif size(I,3) == 2
            P = 0.5.*(double(I(:,:,1))+double(I(:,:,2)));
        else
            P = double(I);
        end
        layer = 1;
        
    case 'vector'
        s = 200./min(size(I,1),size(I,2)); % resize scale
        I = imresize(I,s);
        mask = imresize(mask,s);
        layer = size(I,3);
        if layer == 1
            display('only one image component for vector image')
        end
        P = double(I);
            
    case 'multiphase'
        layer = size(I,3);
        if size(I,1)*size(I,2)>200^2
            s = 200./min(size(I,1),size(I,2)); % resize scale
            I = imresize(I,s);
            mask = imresize(mask,s);
        end
            
        P = double(I);  %P store the original image
    otherwise
        error('!invalid method')
end
%-- End Initializations on input image I and mask
%%
%--   Core function
switch lower(method)
    case {'chan','vector'}
        %-- SDF
        %   Get the distance map of the initial mask
        
        mask = mask(:,:,1);
        phi0 = bwdist(mask)-bwdist(1-mask)+im2double(mask)-.5; 
        %   initial force, set to eps to avoid division by zeros
        force = eps; 
        %-- End Initialization
        %-- Display settings
          %figure();
          %subplot(2,2,1); imshow(I); title('Input Image');
          %subplot(2,2,2); contour(flipud(phi0), [0 0], 'r','LineWidth',1); title('initial contour');
          %subplot(2,2,3); title('Segmentation');
        %-- End Display original image and mask
        %-- Main loop
          for n=1:num_iter
              inidx = find(phi0>=0); % frontground index
              outidx = find(phi0<0); % background index
              force_image = 0; % initial image force for each layer 
              for i=1:layer
                  L = im2double(P(:,:,i)); % get one image component
                  c1 = sum(sum(L.*Heaviside(phi0)))/(length(inidx)+eps); % average inside of Phi0
                  c2 = sum(sum(L.*(1-Heaviside(phi0))))/(length(outidx)+eps); % verage outside of Phi0
                  force_image=-(L-c1).^2+(L-c2).^2+force_image; 
                  % sum Image Force on all components (used for vector image)
                  % if 'chan' is applied, this loop become one sigle code as a
                  % result of layer = 1
              end
              % calculate the external force of the image 
              force = mu*kappa(phi0)./max(max(abs(kappa(phi0))))+1/layer.*force_image;
              % normalized the force
              force = force./(max(max(abs(force))));
              % get stepsize dt
              dt=0.5;
              
              % get parameters for checking whether to stop
              old = phi0;
              phi0 = phi0+dt.*force;
              new = phi0;
              indicator = checkstop(old,new,dt);
              % intermediate output
              if(mod(n,20) == 0) 
                 showphi(I,phi0,n);  
              end;
              if indicator % decide to stop or continue 
                  showphi(I,phi0,n);
                  %make mask from SDF
                  seg = phi0<=0; %-- Get mask from levelset
                  %subplot(2,2,4); imshow(seg); title('Global Region-Based Segmentation');
                  return;
              end
          end;
          showphi(I,phi0,n);
          %make mask from SDF
          seg = phi0<=0; %-- Get mask from levelset
          %subplot(2,2,4); imshow(seg); title('Global Region-Based Segmentation');
    case 'multiphase'
        %-- Initializations
        %   Get the distance map of the initial masks
        mask1 = mask(:,:,1);
        mask2 = mask(:,:,2);
        phi1=bwdist(mask1)-bwdist(1-mask1)+im2double(mask1)-.5;%Get phi1 from the initial mask 1
        phi2=bwdist(mask2)-bwdist(1-mask2)+im2double(mask2)-.5;%Get phi1 from the initial mask 2
        
        %-- Display settings
        figure();
        %subplot(2,2,1); 
        if layer ~= 1
            %imshow(I); title('Input Image');
        else
            %imagesc(P); axis image; colormap(gray);title('Input Image');
        end
        %subplot(2,2,2);
        %hold on
        %contour(flipud(mask1),[0,0],'r','LineWidth',2.5); 
        %contour(flipud(mask1),[0,0],'x','LineWidth',1);
        %contour(flipud(mask2),[0,0],'g','LineWidth',2.5);
        %contour(flipud(mask2),[0,0],'x','LineWidth',1);
        %title('initial contour');
        %hold off
        %subplot(2,2,3); title('Segmentation');
        %-- End display settings
        
        %Main loop
        for n=1:num_iter
              %-- Narrow band for each phase
              nb1 = find(phi1<1.2 & phi1>=-1.2); %narrow band of phi1
              inidx1 = find(phi1>=0); %phi1 frontground index
              outidx1 = find(phi1<0); %phi1 background index
              nb2 = find(phi2<1.2 & phi2>=-1.2); %narrow band of phi2
              inidx2 = find(phi2>=0); %phi2 frontground index
              outidx2 = find(phi2<0); %phi2 background index
              %-- End initiliazaions on narrow band
              %-- Mean calculations for different partitions
              %c11 = mean (phi1>0 & phi2>0)
              %c12 = mean (phi1>0 & phi2<0)
              %c21 = mean (phi1<0 & phi2>0)
              %c22 = mean (phi1<0 & phi2<0)
              cc11 = intersect(inidx1,inidx2); %index belong to (phi1>0 & phi2>0)
              cc12 = intersect(inidx1,outidx2); %index belong to (phi1>0 & phi2<0)
              cc21 = intersect(outidx1,inidx2); %index belong to (phi1<0 & phi2>0)
              cc22 = intersect(outidx1,outidx2); %index belong to (phi1<0 & phi2<0)
              
              f_image11 = 0;
              f_image12 = 0;
              f_image21 = 0;
              f_image22 = 0; % initial image force for each layer 
              
              for i=1:layer
                  L = im2double(P(:,:,i)); % get one image component
          
              if isempty(cc11)
                  c11 = eps;
              else
                  c11 = mean(L(cc11));
              end
              
              if isempty(cc12)
                  c12 = eps;
              else
                  c12 = mean(L(cc12)); 
              end
              
              if isempty(cc21)
                  c21 = eps;
              else
                  c21 = mean(L(cc21));
              end
              
              if isempty(cc22)
                  c22 = eps;
              else
                  c22 = mean(L(cc22));
              end
              
              %-- End mean calculation
              %-- Force calculation and normalization
              % force on each partition
              
              f_image11=(L-c11).^2.*Heaviside(phi1).*Heaviside(phi2)+f_image11;
              f_image12=(L-c12).^2.*Heaviside(phi1).*(1-Heaviside(phi2))+f_image12;
              f_image21=(L-c21).^2.*(1-Heaviside(phi1)).*Heaviside(phi2)+f_image21;
              f_image22=(L-c22).^2.*(1-Heaviside(phi1)).*(1-Heaviside(phi2))+f_image22;
              end
              
                  % sum Image Force on all components (used for vector image)
                  % if 'chan' is applied, this loop become one sigle code as a
                  % result of layer = 1
 
              % calculate the external force of the image 
              
              % curvature on phi1
              curvature1 = mu*kappa(phi1);
              curvature1 = curvature1(nb1);
              % image force on phi1
              fim1 = 1/layer.*(-f_image11(nb1)+f_image21(nb1)-f_image12(nb1)+f_image22(nb1));
              fim1 = fim1./max(abs(fim1)+eps);
              % curvature on phi2
              curvature2 = mu*kappa(phi2);
              curvature2 = curvature2(nb2);
              % image force on phi2
              fim2 = 1/layer.*(-f_image11(nb2)+f_image12(nb2)-f_image21(nb2)+f_image22(nb2));
              fim2 = fim2./max(abs(fim2)+eps);
              % force on phi1 and phi2
              force1 = curvature1+fim1;
              force2 = curvature2+fim2;
              %-- End force calculation
              % detal t
              dt = 1.5;
              
              old(:,:,1) = phi1;
              old(:,:,2) = phi2;
              %update of phi1 and phi2
              phi1(nb1) = phi1(nb1)+dt.*force1;
              phi2(nb2) = phi2(nb2)+dt.*force2;
              
              new(:,:,1) = phi1;
              new(:,:,2) = phi2;
              
              indicator = checkstop(old,new,dt);
              if indicator 
                 showphi(I, new, n);
                 %make mask from SDF
                 seg11 = (phi1>0 & phi2>0); %-- Get mask from levelset
                 seg12 = (phi1>0 & phi2<0);
                 seg21 = (phi1<0 & phi2>0);
                 seg22 = (phi1<0 & phi2<0);
                 se = strel('disk',1);
                 aa1 = imerode(seg11,se);
                 aa2 = imerode(seg12,se);
                 aa3 = imerode(seg21,se);
                 aa4 = imerode(seg22,se);
                 seg = aa1+2*aa2+3*aa3+4*aa4;
                
                 %subplot(2,2,4); imagesc(seg);axis image;title('Global Region-Based Segmentation');
                  return
              end
              % re-initializations
              phi1 = reinitialization(phi1, 0.6);%sussman(phi1, 0.6);%
              phi2 = reinitialization(phi2, 0.6);%sussman(phi2,0.6);
              %intermediate output
              if(mod(n,20) == 0) 
                 phi(:,:,1) = phi1;
                 phi(:,:,2) = phi2;
                 showphi(I, phi, n);
              end;
          end;
          phi(:,:,1) = phi1;
          phi(:,:,2) = phi2;
          showphi(I, phi, n);
          %make mask from SDF
        seg11 = (phi1>0 & phi2>0); %-- Get mask from levelset
        seg12 = (phi1>0 & phi2<0);
        seg21 = (phi1<0 & phi2>0);
        seg22 = (phi1<0 & phi2<0);
        se = strel('disk',1);
        aa1 = imerode(seg11,se);
        aa2 = imerode(seg12,se);
        aa3 = imerode(seg21,se);
        aa4 = imerode(seg22,se);
        seg = aa1+2*aa2+3*aa3+4*aa4;
        %seg = bwlabel(seg);
        %subplot(2,2,4); imagesc(seg);axis image;title('Global Region-Based Segmentation');
end
end
function H=Heaviside(z)
% Heaviside step function (smoothed version)
% Copyright (c) 2009, 
% Yue Wu @ ECE Department, Tufts University
% All Rights Reserved  

Epsilon=10^(-5);
H=zeros(size(z,1),size(z,2));
idx1=find(z>Epsilon);
idx2=find(z<Epsilon & z>-Epsilon);
H(idx1)=1;
for i=1:length(idx2)
    H(idx2(i))=1/2*(1+z(idx2(i))/Epsilon+1/pi*sin(pi*z(idx2(i))/Epsilon));
end;
end
%%
function KG = kappa(I)
% get curvature information of input image
% input: 2D image I
% output: curvature matrix KG

% Copyright (c) 2009, 
% Yue Wu @ ECE Department, Tufts University
% All Rights Reserved  

I = double(I);
[m,n] = size(I);
P = padarray(I,[1,1],1,'pre');
P = padarray(P,[1,1],1,'post');

% central difference
fy = P(3:end,2:n+1)-P(1:m,2:n+1);
fx = P(2:m+1,3:end)-P(2:m+1,1:n);
fyy = P(3:end,2:n+1)+P(1:m,2:n+1)-2*I;
fxx = P(2:m+1,3:end)+P(2:m+1,1:n)-2*I;
fxy = 0.25.*(P(3:end,3:end)-P(1:m,3:end)+P(3:end,1:n)-P(1:m,1:n));
G = (fx.^2+fy.^2).^(0.5);
K = (fxx.*fy.^2-2*fxy.*fx.*fy+fyy.*fx.^2)./((fx.^2+fy.^2+eps).^(1.5));
KG = K.*G;
KG(1,:) = eps;
KG(end,:) = eps;
KG(:,1) = eps;
KG(:,end) = eps;
KG = KG./max(max(abs(KG)));
end
%%

function m = maskcircle2(I,type)
% auto pick a circular mask for image I 
% built-in mask creation function
% Input: I   : input image     
%        type: mask shape keywords
% Output: m  : mask image

% Copyright (c) 2009, 
% Yue Wu @ ECE Department, Tufts University
% All Rights Reserved  

if size(I,3)~=3
    temp = double(I(:,:,1));
else
    temp = double(rgb2gray(I));
end

h = [0 1 0; 1 -4 1; 0 1 0];
T = conv2(temp,h);
T(1,:) = 0;
T(end,:) = 0;
T(:,1) = 0;
T(:,end) = 0;

thre = max(max(abs(T)))*.5;
idx = find(abs(T) > thre);
[cx,cy] = ind2sub(size(T),idx);
cx = round(mean(cx));
cy = round(mean(cy));

[x,y] = meshgrid(1:min(size(temp,1),size(temp,2)));

m = zeros(size(temp));
[p,q] = size(temp);

switch lower (type)
    case 'small'
        r = 10;
        n = zeros(size(x));
        n((x-cx).^2+(y-cy).^2<r.^2) = 1;
        m(1:size(n,1),1:size(n,2)) = n;
        %m((x-cx).^2+(y-cy).^2<r.^2) = 1;
    case 'medium'
        r = min(min(cx,p-cx),min(cy,q-cy));
        r = max(2/3*r,25);
        n = zeros(size(x));
        n((x-cx).^2+(y-cy).^2<r.^2) = 1;
        m(1:size(n,1),1:size(n,2)) = n;
        %m((x-cx).^2+(y-cy).^2<r.^2) = 1;
    case 'large'
        r = min(min(cx,p-cx),min(cy,q-cy));
        r = max(2/3*r,60);
        n = zeros(size(x));
        n((x-cx).^2+(y-cy).^2<r.^2) = 1;
        m(1:size(n,1),1:size(n,2)) = n;
        %m((x-cx).^2+(y-cy).^2<r.^2) = 1;
    case 'whole'
        r = 9;
        m = zeros(round(ceil(max(p,q)/2/(r+1))*3*(r+1)));
        siz = size(m,1);
        sx = round(siz/2);       
        i = 1:round(siz/2/(r+1));
        j = 1:round(0.9*siz/2/(r+1));
        j = j-round(median(j)); 
        m(sx+2*j*(r+1),(2*i-1)*(r+1)) = 1;
        se = strel('disk',r);
        m = imdilate(m,se);
        m = m(round(siz/2-p/2-6):round(siz/2-p/2-6)+p-1,round(siz/2-q/2-6):round(siz/2-q/2-6)+q-1); 
end
        tem(:,:,1) = m;
        M = padarray(m,[floor(2/3*r),floor(2/3*r)],0,'post');
        tem(:,:,2) = M(floor(2/3*r)+1:end,floor(2/3*r)+1:end);
        m = tem; 
return
end
%%
function D = reinitialization(D,dt)
% reinitialize the distance map for active contour

% Copyright (c) 2009, 
% Yue Wu @ ECE Department, Tufts University
% All Rights Reserved  

T = padarray(D,[1,1],0,'post');
T = padarray(T,[1,1],0,'pre');
% differences on all directions
a = D-T(1:end-2,2:end-1);
b = T(3:end,2:end-1)-D;
c = D-T(2:end-1,1:end-2);
d = T(2:end-1,3:end)-D;

a_p = max(a,0);
a_m = min(a,0);
b_p = max(b,0);
b_m = min(b,0);
c_p = max(c,0);
c_m = min(c,0);
d_p = max(d,0);
d_m = min(d,0);

G = zeros(size(D));
ind_plus = find(D>0);
ind_minus = find(D<0);
G(ind_plus) = sqrt(max(a_p(ind_plus).^2,b_m(ind_plus).^2)+max(c_p(ind_plus).^2,d_m(ind_plus).^2))-1;
G(ind_minus) = sqrt(max(a_m(ind_minus).^2,b_p(ind_minus).^2)+max(c_m(ind_minus).^2,d_p(ind_minus).^2))-1;

sign_D = D./sqrt(D.^2+1);
D = D-dt.*sign_D.*G;
end
%%
function showphi(I, phi, i)
% show curve evolution of phi

% Copyright (c) 2009, 
% Yue Wu @ ECE Department, Tufts University
% All Rights Reserved  

for j = 1:size(phi,3)
    phi_{j} = phi(:,:,j);
end
  %imshow(I,'initialmagnification','fit','displayrange',[0 255]);
  %hold on;

  if size(phi,3) == 1
      %contour(phi_{1}, [0 0], 'r','LineWidth',4);
      %contour(phi_{1}, [0 0], 'g','LineWidth',1.3);
  else
      %contour(phi_{1}, [0 0], 'r','LineWidth',4);
      %contour(phi_{1}, [0 0], 'x','LineWidth',1.3);
      %contour(phi_{2}, [0 0], 'g','LineWidth',4);
      %contour(phi_{2}, [0 0], 'x','LineWidth',1.3);
  end
  %hold off; 
  %title([num2str(i) ' Iterations']); 
  %drawnow;
end
%%
function indicator = checkstop(old,new,dt)
% indicate whether we should performance further iteraions or stop

% Copyright (c) 2009, 
% Yue Wu @ ECE Department, Tufts University
% All Rights Reserved  

layer = size(new,3);

for i = 1:layer
    old_{i} = old(:,:,i);
    new_{i} = new(:,:,i);
end

if layer
    ind = find(abs(new)<=.5);
    M = length(ind);
    Q = sum(abs(new(ind)-old(ind)))./M;
    if Q<=dt*.18^2
        indicator = 1;
    else
        indicator = 0;
    end
else
    ind1 = find(abs(old_{1})<1);
    ind2 = find(abs(old_{2})<1);
    M1 = length(ind1);
    M2 = length(ind2);
    Q1 = sum(abs(new_{1}(ind1)-old_{1}(ind1)))./M1;
    Q2 = sum(abs(new_{2}(ind2)-old_{2}(ind2)))./M2;
    if Q1<=dt*.18^2 && Q2<=dt*.18^2
        indicator = 1;
    else
        indicator = 0;
    end
end
return
end
%%