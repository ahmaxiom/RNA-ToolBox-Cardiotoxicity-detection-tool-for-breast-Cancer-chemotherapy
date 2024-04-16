%% Generating uniform signal then appying two types of noise (pulse and multiplicative) 
%% After that compute the ApEn and Bounded ApEn for each one
% tolerance r and m parameters\
r_val=1;
m_val=2;
% Sine Signal
   Fs = 8000;                   % samples per second
   dt = 1/Fs;                   % seconds per sample
   StopTime = 0.125;             % seconds
   t = (0:dt:StopTime-dt)';     % seconds
   %%Sine wave:
   Fc = 60;                     % hertz
   s1 = sin(2*pi*Fc*t);
   % Plot the signal versus time:
   figure;
   plot(t,s1);
   xlabel('time (in seconds)');
   title('Signal versus Time');
% define noise initiation and increament
init=0;
inc=0.03;
% noise   
s2=imnoise(s1,'salt & pepper',init+inc);
s3=imnoise(s1,'salt & pepper',init+2*inc);
s4=imnoise(s1,'salt & pepper',init+3*inc);
s5=imnoise(s1,'salt & pepper',init+4*inc);
s6=imnoise(s1,'salt & pepper',init+5*inc);
s7=imnoise(s1,'salt & pepper',init+6*inc);
s8=imnoise(s1,'salt & pepper',init+7*inc);
s9=imnoise(s1,'salt & pepper',init+8*inc);
s10=imnoise(s1,'salt & pepper',init+9*inc);
%plot(s1(1:100));title('Original uniform signal');
figure
subplot(3,3,1),plot(s2);title('pulse nosiy 0.1 signal');
subplot(3,3,2),plot(s3);title('pulse nosiy 0.2 signal');
subplot(3,3,3),plot(s4);title('pulse nosiy 0.3 signal');
subplot(3,3,4),plot(s5);title('pulse nosiy 0.4 signal');
subplot(3,3,5),plot(s6);title('pulse nosiy 0.5 signal');
subplot(3,3,6),plot(s7);title('pulse nosiy 0.6 signal');
subplot(3,3,7),plot(s8);title('pulse nosiy 0.7 signal');
subplot(3,3,8),plot(s9);title('pulse nosiy 0.8 signal');
subplot(3,3,9),plot(s10);title('pulse nosiy 0.9 signal');

[en1]=EntropySig(s1)
[en2]=EntropySig(s2)
[en3]=EntropySig(s3)
[en4]=EntropySig(s4)
[en5]=EntropySig(s5)
[en6]=EntropySig(s6)
[en7]=EntropySig(s7)
[en8]=EntropySig(s8)
[en9]=EntropySig(s9)
[en10]=EntropySig(s10)

ApEn1= ApEn_slow(s1, m_val,r_val*std(s1))
ApEn2= ApEn_slow(s2, m_val,r_val*std(s2))
ApEn3= ApEn_slow(s3, m_val,r_val*std(s3))
ApEn4= ApEn_slow(s4, m_val,r_val*std(s4))
ApEn5= ApEn_slow(s5, m_val,r_val*std(s5))
ApEn6= ApEn_slow(s6, m_val,r_val*std(s6))
ApEn7= ApEn_slow(s7, m_val,r_val*std(s7))
ApEn8= ApEn_slow(s8, m_val,r_val*std(s8))
ApEn9= ApEn_slow(s9, m_val,r_val*std(s9))
ApEn10= ApEn_slow(s10, m_val,r_val*std(s10))
[BoundApEn1]=BoundedProcess(s1);
[BoundApEn2]=BoundedProcess(s2);
[BoundApEn3]=BoundedProcess(s3);
[BoundApEn4]=BoundedProcess(s4);
[BoundApEn5]=BoundedProcess(s5);
[BoundApEn6]=BoundedProcess(s6);
[BoundApEn7]=BoundedProcess(s7);
[BoundApEn8]=BoundedProcess(s8);
[BoundApEn9]=BoundedProcess(s9);
[BoundApEn10]=BoundedProcess(s10);


filename = 'Entropy.xlsx';
T1=  table({en1},{en2},{en3},{en4},{en5},{en6},{en7},{en8},{en9},{en10});
T2 = table({ApEn1},{ApEn2},{ApEn3},{ApEn4},{ApEn5},{ApEn6},{ApEn7},{ApEn8},{ApEn9},{ApEn10});
T3 = table({BoundApEn1},{BoundApEn2},{BoundApEn3},{BoundApEn4},{BoundApEn5},{BoundApEn6},{BoundApEn7},{BoundApEn8},{BoundApEn9},{BoundApEn10});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B3:k3'));
writetable(T2,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B4:k4'));
writetable(T3,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B5:k5'));
%%
s2=imnoise(s1,'speckle',init+inc);
s3=imnoise(s1,'speckle',init+2*inc);
s4=imnoise(s1,'speckle',init+3*inc);
s5=imnoise(s1,'speckle',init+4*inc);
s6=imnoise(s1,'speckle',init+5*inc);
s7=imnoise(s1,'speckle',init+6*inc);
s8=imnoise(s1,'speckle',init+7*inc);
s9=imnoise(s1,'speckle',init+8*inc);
s10=imnoise(s1,'speckle',init+9*inc);

figure
subplot(3,3,1),plot(s2);title('speckle nosiy 0.1 signal');
subplot(3,3,2),plot(s3);title('speckle nosiy 0.2 signal');
subplot(3,3,3),plot(s4);title('speckle nosiy 0.3 signal');
subplot(3,3,4),plot(s5);title('speckle nosiy 0.4 signal');
subplot(3,3,5),plot(s6);title('speckle nosiy 0.5 signal');
subplot(3,3,6),plot(s7);title('speckle nosiy 0.6 signal');
subplot(3,3,7),plot(s8);title('speckle nosiy 0.7 signal');
subplot(3,3,8),plot(s9);title('speckle nosiy 0.8 signal');
subplot(3,3,9),plot(s10);title('speckle nosiy 0.9 signal');
[en1]=EntropySig(s1)
[en2]=EntropySig(s2)
[en3]=EntropySig(s3)
[en4]=EntropySig(s4)
[en5]=EntropySig(s5)
[en6]=EntropySig(s6)
[en7]=EntropySig(s7)
[en8]=EntropySig(s8)
[en9]=EntropySig(s9)
[en10]=EntropySig(s10)
ApEn1= ApEn_slow(s1, m_val,r_val*std(s1))
ApEn2= ApEn_slow(s2, m_val,r_val*std(s2))
ApEn3= ApEn_slow(s3, m_val,r_val*std(s3))
ApEn4= ApEn_slow(s4, m_val,r_val*std(s4))
ApEn5= ApEn_slow(s5, m_val,r_val*std(s5))
ApEn6= ApEn_slow(s6, m_val,r_val*std(s6))
ApEn7= ApEn_slow(s7, m_val,r_val*std(s7))
ApEn8= ApEn_slow(s8, m_val,r_val*std(s8))
ApEn9= ApEn_slow(s9, m_val,r_val*std(s9))
ApEn10= ApEn_slow(s10, m_val,r_val*std(s10))
[BoundApEn1]=BoundedProcess(s1);
[BoundApEn2]=BoundedProcess(s2);
[BoundApEn3]=BoundedProcess(s3);
[BoundApEn4]=BoundedProcess(s4);
[BoundApEn5]=BoundedProcess(s5);
[BoundApEn6]=BoundedProcess(s6);
[BoundApEn7]=BoundedProcess(s7);
[BoundApEn8]=BoundedProcess(s8);
[BoundApEn9]=BoundedProcess(s9);
[BoundApEn10]=BoundedProcess(s10);


filename = 'Entropy.xlsx';
[ApEn1 ApEn2 ApEn3 ApEn4 ApEn5 ApEn6 ApEn7 ApEn8 ApEn9 ApEn10...
 BoundApEn1 BoundApEn2 BoundApEn3 BoundApEn4 BoundApEn5...
 BoundApEn6 BoundApEn7 BoundApEn8 BoundApEn9 BoundApEn10]
T1=  table({en1},{en2},{en3},{en4},{en5},{en6},{en7},{en8},{en9},{en10});
T2 = table({ApEn1},{ApEn2},{ApEn3},{ApEn4},{ApEn5},{ApEn6},{ApEn7},{ApEn8},{ApEn9},{ApEn10});
T3 = table({BoundApEn1},{BoundApEn2},{BoundApEn3},{BoundApEn4},{BoundApEn5},{BoundApEn6},{BoundApEn7},{BoundApEn8},{BoundApEn9},{BoundApEn10});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B8:k8'));
writetable(T2,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B9:k9'));
writetable(T3,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B10:k10'));
%%
s2=imnoise(s2,'salt & pepper',init+inc);
s3=imnoise(s3,'salt & pepper',init+2*inc);
s4=imnoise(s4,'salt & pepper',init+3*inc);
s5=imnoise(s5,'salt & pepper',init+4*inc);
s6=imnoise(s6,'salt & pepper',init+5*inc);
s7=imnoise(s7,'salt & pepper',init+6*inc);
s8=imnoise(s8,'salt & pepper',init+7*inc);
s9=imnoise(s9,'salt & pepper',init+8*inc);
s10=imnoise(s10,'salt & pepper',init+9*inc);
%plot(s1(1:100));title('Original uniform signal');
figure
subplot(3,3,1),plot(s2);title('mixed nosiy 0.1 signal');
subplot(3,3,2),plot(s3);title('mixed nosiy 0.2 signal');
subplot(3,3,3),plot(s4);title('mixed nosiy 0.3 signal');
subplot(3,3,4),plot(s5);title('mixed nosiy 0.4 signal');
subplot(3,3,5),plot(s6);title('mixed nosiy 0.5 signal');
subplot(3,3,6),plot(s7);title('mixed nosiy 0.6 signal');
subplot(3,3,7),plot(s8);title('mixed nosiy 0.7 signal');
subplot(3,3,8),plot(s9);title('mixed nosiy 0.8 signal');
subplot(3,3,9),plot(s10);title('mixed nosiy 0.9 signal');

[en1]=EntropySig(s1)
[en2]=EntropySig(s2)
[en3]=EntropySig(s3)
[en4]=EntropySig(s4)
[en5]=EntropySig(s5)
[en6]=EntropySig(s6)
[en7]=EntropySig(s7)
[en8]=EntropySig(s8)
[en9]=EntropySig(s9)
[en10]=EntropySig(s10)

ApEn1= ApEn_slow(s1, m_val,r_val*std(s1))
ApEn2= ApEn_slow(s2, m_val,r_val*std(s2))
ApEn3= ApEn_slow(s3, m_val,r_val*std(s3))
ApEn4= ApEn_slow(s4, m_val,r_val*std(s4))
ApEn5= ApEn_slow(s5, m_val,r_val*std(s5))
ApEn6= ApEn_slow(s6, m_val,r_val*std(s6))
ApEn7= ApEn_slow(s7, m_val,r_val*std(s7))
ApEn8= ApEn_slow(s8, m_val,r_val*std(s8))
ApEn9= ApEn_slow(s9, m_val,r_val*std(s9))
ApEn10= ApEn_slow(s10, m_val,r_val*std(s10))
[BoundApEn1]=BoundedProcess(s1);
[BoundApEn2]=BoundedProcess(s2);
[BoundApEn3]=BoundedProcess(s3);
[BoundApEn4]=BoundedProcess(s4);
[BoundApEn5]=BoundedProcess(s5);
[BoundApEn6]=BoundedProcess(s6);
[BoundApEn7]=BoundedProcess(s7);
[BoundApEn8]=BoundedProcess(s8);
[BoundApEn9]=BoundedProcess(s9);
[BoundApEn10]=BoundedProcess(s10);


filename = 'Entropy.xlsx';
T1=  table({en1},{en2},{en3},{en4},{en5},{en6},{en7},{en8},{en9},{en10});
T2 = table({ApEn1},{ApEn2},{ApEn3},{ApEn4},{ApEn5},{ApEn6},{ApEn7},{ApEn8},{ApEn9},{ApEn10});
T3 = table({BoundApEn1},{BoundApEn2},{BoundApEn3},{BoundApEn4},{BoundApEn5},{BoundApEn6},{BoundApEn7},{BoundApEn8},{BoundApEn9},{BoundApEn10});
writetable(T1,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B13:k13'));
writetable(T2,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B14:k14'));
writetable(T3,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('B15:k15'));
%%
disp('Data has been written to excel sheet, check Entropy.xlsx in the current folder!');