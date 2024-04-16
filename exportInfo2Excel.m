%% This script is written to export Workspace data to a predesigned excel sheet in order to save patient's information and the caculated data
%% note this script shoudn't be executed before running
% TID_new_Region_Growing_allParametters.m script !!!
%% Get row number and name of excel sheet.
%% Median
clear all
load pre AcquisitionDate2 area1Pre area2Pre AverageDivPre circularityMaxPre circularityMinPre ElongationMaxPre ...
    ElongationMinPre Entro_pre ApEnPre FrameTime2 heart2lungpre HeartRate2 HighRRValue2 IntervalsAcquired2 IntervalsRejected2 LowRRValue2...
    LVEFpre Manufacturer minLongDIVmaxLPre minShortDIVmaxLPre PatientAge2 PatientID PatientWeight2 PixelNumMaxPre PixelNumMinPre...
    post2pre ratePre Sync_pre TIDmax TIDmin TotalBGmaxPre TotalBGminPre phasePre BoundApEnPre epsilonPre LspsilonPre ApEnPreMXMN...
    Synchrony_PreMXMN Entro_PreMXMN BoundApEnPreMXMN LVEFprePhase RFT_Pre RFV_Pre LVFR_Pre LVER_Pre
load num num;

filename = 'new_platform.xlsx';
load post AcquisitionDate area1Post area2Post AverageDivPost circularityMaxPost circularityMinPost ElongationMaxPost ...
    ElongationMinPost Entro_post ApEnPost FrameTime heart2lungpost HeartRate HighRRValue IntervalsAcquired IntervalsRejected LowRRValue...
    LVEFpost Manufacturer minLongDIVmaxLPost minShortDIVmaxLPost PatientAge PatientID PatientWeight PixelNumMaxPost PixelNumMinPost...
    post2pre ratePost Sync_post TIDmax TIDmin TotalBGmaxPost TotalBGminPost phasePost BoundApEnPost epsilonPost LspsilonPost ...
    ApEnPostMXMN Entro_PostMXMN Synchrony_PostMXMN BoundApEnPostMXMN LVEFpostPhase RFT_Post RFV_Post LVFR_Post LVER_Post

%% PRE
% patient ID
T1 = table({PatientID},{' '},{' '},{PatientAge2},{datetime(AcquisitionDate2,'InputFormat','yyyyMMdd')},{LVEFpre},{LVEFprePhase}...
    ,Sync_pre,Synchrony_PreMXMN,Entro_pre,Entro_PreMXMN,ApEnPre,ApEnPreMXMN,heart2lungpre,AverageDivPre,minLongDIVmaxLPre,minShortDIVmaxLPre,circularityMaxPre...
    ,circularityMinPre,ElongationMaxPre,ElongationMinPre,HighRRValue2,IntervalsRejected2,IntervalsAcquired2,HeartRate2...
    ,FrameTime2,{Manufacturer},{phasePre},BoundApEnPre, BoundApEnPreMXMN,epsilonPre, LspsilonPre,TotalBGmaxPre,PixelNumMaxPre, TotalBGminPre, PixelNumMinPre,...
    {' '},...
    {datetime(AcquisitionDate,'InputFormat','yyyyMMdd')},{LVEFpost},{LVEFpostPhase},Sync_post, Synchrony_PostMXMN,Entro_post,...
    Entro_PostMXMN,ApEnPost,ApEnPostMXMN,heart2lungpost,AverageDivPost,...
    minLongDIVmaxLPost,minShortDIVmaxLPost,circularityMaxPost,circularityMinPost,ElongationMaxPost,ElongationMinPost,HighRRValue,...
    IntervalsRejected,IntervalsAcquired,HeartRate,FrameTime,{Manufacturer},phasePost,{' '},post2pre,TIDmax,TIDmin,BoundApEnPost,BoundApEnPostMXMN,...
    epsilonPost, LspsilonPost, TotalBGmaxPost,PixelNumMaxPost, TotalBGminPost, PixelNumMinPost,...
    RFT_Pre,RFV_Pre, LVFR_Pre, LVER_Pre,RFT_Post,RFV_Post,LVFR_Post,LVER_Post);
%system('taskkill /F /IM EXCEL.EXE');
writetable(T1,filename,'Sheet','Median','WriteVariableNames',false,'Range',strcat('A',num2str(num)));
% % age and date (post)
% writetable(T2,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('D',num2str(num),':','F',num2str(num)));
% %system('taskkill /F /IM EXCEL.EXE');
% 
% % Rest of data (post)
% writetable(T3,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('G',num2str(num),':','X',num2str(num)));
%system('taskkill /F /IM EXCEL.EXE');

%% POST
% date (post)
%T2 = table({datetime(AcquisitionDate,'InputFormat','yyyyMMdd')},{LVEFpost},Sync_post,Entro_post,ApEnPost,heart2lungpost,AverageDivPost,minLongDIVmaxLPost,minShortDIVmaxLPost,circularityMaxPost,circularityMinPost,ElongationMaxPost,ElongationMinPost,HighRRValue,IntervalsRejected,IntervalsAcquired,HeartRate,FrameTime,{Manufacturer},phasePost,{' '},post2pre,TIDmax,TIDmin);
%T3 = table(Sync_post,Entro_post,ApEnPost,heart2lungpost,AverageDivPost,minLongDIVmaxLPost,minShortDIVmaxLPost,circularityMaxPost,circularityMinPost,ElongationMaxPost,ElongationMinPost,HighRRValue,IntervalsRejected,IntervalsAcquired,HeartRate,FrameTime,{Manufacturer},phasePost);

% writetable(T3,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('AB',num2str(num),':','AS',num2str(num)));
% %system('taskkill /F /IM EXCEL.EXE');
% 
% %% A2/A1 and TID
%T4 = table(post2pre,TIDmax,TIDmin);
%writetable(T2,filename,'Sheet','Sheet1','WriteVariableNames',false,'Range',strcat('Z',num2str(num),':','AW',num2str(num)));
%system('taskkill /F /IM EXCEL.EXE');

%% close excel process
%system('taskkill /F /IM EXCEL.EXE');
disp('Data has been written to excel sheet, check platform.xlsx in the current folder!');
%% end :)

%% Write sp to text file
load sp_pre sp_pre
load sp_post sp_post
fileID = fopen('seed2.txt','a');
fmt = '%31s\n';
sp=strcat(num2str(sp_pre(1)),',', num2str(sp_pre(2)),',', num2str(sp_post(1)),',',num2str(sp_post(2)))
fprintf(fileID,fmt,sp);
%%
%% increase num for the next patient
num = num+1;
save num num;
clear all