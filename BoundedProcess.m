function [BoundApEn,epsilon,Lespsilon] = BoundedProcess(A)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
A=A./max(A);
BoundP=max(A);
BoundM=min(A);
k=0;
for i=2:1:size(A,1)
   e(i)=A(i)-A(i-1);
   if(e(i)>BoundP || e(i)<BoundM)
       e(i)=e(i)+A(i-1);
       k=k+1;
   end
end
alpha=std(e);
betta=BoundP-BoundM;
epsilon=alpha/betta;
Lespsilon=log(epsilon) ;% log(epsilon)
r=1*std(e);% tolerance parameter
%BoundApEn=-log((2*sqrt(12)*alpha/betta+r.*2)/(12*((alpha/betta).^2))) %bounded aproaximate entropy
%BoundApEn=log(sqrt(3))+log(epsilon)-log(r) %bounded aproaximate entropy
BoundApEn=ApEn_slow(e,2,r);
end
