BoundApEn=[];epsilon=[];Lespsilon=[];
k=0;
while (1)
    k=k+1;
    range=strcat('Y',num2str(3+k),':AA',num2str(3+k));
    M = xlsread('platform.xlsx','Sheet1',range);
    if(isempty(M))break;end
    BoundApEn(k) =M(1);
    epsilon(k)=M(2);
    Lespsilon(k)=M(3);
end
figure
subplot(1,2,1),plot(Lespsilon,BoundApEn,'+r');
xlabel('Log(\epsilon)');
ylabel('ApEn');
axis([-5 0 0 1.5])
title('pre');
BoundApEn=[];epsilon=[];Lespsilon=[];k=0;
while (1)
    k=k+1;
    range=strcat('BA',num2str(3+k),':BC',num2str(3+k));
    M = xlsread('platform.xlsx','Sheet1',range);
    if(isempty(M))break;end
    BoundApEn(k) =M(1);
    epsilon(k)=M(2);
    Lespsilon(k)=M(3);
end
subplot(1,2,2),plot(Lespsilon,BoundApEn,'+r');
xlabel('Log(\epsilon)');
ylabel('ApEn');
axis([-5 0 0 1.5])
title('post');