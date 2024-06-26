function [x_mean,x_median,x_min,x_wiener,x_mmwf,x_mmwf_star]=MMWF_2D(x,n)

% Code designed by Carlo Vittorio Cannistraci 2014
% INPUT: x is the signal as a 2D matrix, n is the window size (only odd numbers accepted)
% OUTPUT: x_mmwf is the MMWF result; x_mmwf_star is the MMWF* result
x=double(x);
tt=numel(x);
xf_mean=zeros(tt,1);
xf_median=xf_mean;
xf_min=xf_mean;
xf_var=xf_mean;
xf_var_median1=xf_mean;

n=(n-1)/2;

  [s1,s2] = ind2sub(size(x),1:tt);
xt=zeros(size(x));
%parpool open
for i=1:tt
    xt=x(max(1,s1(i)-n):min(s1(i)+n,size(x,1)),max(1,s2(i)-n):min(s2(i)+n,size(x,2)));
    xf_mean(i)=mean(xt(:));
    xf_median(i)=median(xt(:));
    xf_min(i)=min(xt(:));
    xf_var(i)=var(xt(:));
    xf_var_median1(i)=mean((xt(:)-xf_median(i)).^2);
end
%parpool close

x_mean=zeros(size(x));
x_mean(1:tt)=xf_mean;

x_median=zeros(size(x));
x_median(1:tt)=xf_median;

x_min=zeros(size(x));
x_min(1:tt)=xf_min;

x_wiener=zeros(size(x));
vv=max(0,xf_var-mean(xf_var))./xf_var; vv(isnan(vv))=0;
x_wiener(1:tt)=xf_mean+vv.*(x(:)-xf_mean);

x_mmwf=zeros(size(x));
x_mmwf(1:tt)=xf_median+vv.*(x(:)-xf_median);

%%% New part


x_mmwf_star=zeros(size(x));
x_mmwf_star(1:tt)=xf_median+vv2(xf_var_median1).*(x(:)-xf_median);

%%% Support function

function vv2=vv2(xf_var)
vv2=max(0,xf_var-median(xf_var))./xf_var;
vv2(isnan(vv2))=0;

