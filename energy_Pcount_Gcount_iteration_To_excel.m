load preInf energy numofIter Gray_count pixel_count
energyPre=energy;
numofIterPre=numofIter;
Gray_countPre=Gray_count;
pixel_countPre=pixel_count;
load postInf energy numofIter Gray_count pixel_count
energyPost=energy;
numofIterPost=numofIter;
Gray_countPost=Gray_count;
pixel_countPost=pixel_count;
filename = 'energy.xlsx';
T1 = table(energyPre(1), energyPre(2), energyPre(3), energyPre(4), energyPre(5), energyPre(6), energyPre(7), energyPre(8),...
   energyPre(9), energyPre(10), energyPre(11), energyPre(12), energyPre(13), energyPre(14), energyPre(15), energyPre(16));
T2= table(numofIterPre(1), numofIterPre(2), numofIterPre(3), numofIterPre(4), numofIterPre(5), numofIterPre(6), numofIterPre(7), numofIterPre(8),...
   numofIterPre(9), numofIterPre(10), numofIterPre(11), numofIterPre(12), numofIterPre(13), numofIterPre(14), numofIterPre(15), numofIterPre(16));
T3=table(Gray_countPre(1), Gray_countPre(2), Gray_countPre(3), Gray_countPre(4), Gray_countPre(5), Gray_countPre(6), Gray_countPre(7), Gray_countPre(8),...
   Gray_countPre(9), Gray_countPre(10), Gray_countPre(11), Gray_countPre(12), Gray_countPre(13), Gray_countPre(14), Gray_countPre(15), Gray_countPre(16));
T4=table(pixel_countPre(1), pixel_countPre(2), pixel_countPre(3), pixel_countPre(4), pixel_countPre(5), pixel_countPre(6), pixel_countPre(7), pixel_countPre(8),...
   pixel_countPre(9), pixel_countPre(10), pixel_countPre(11), pixel_countPre(12), pixel_countPre(13), pixel_countPre(14), pixel_countPre(15), pixel_countPre(16));
writetable(T1,filename,'Sheet','pre','WriteVariableNames',false,'Range',strcat('B3:Q4'));
writetable(T2,filename,'Sheet','pre','WriteVariableNames',false,'Range',strcat('B4:Q4'));
writetable(T3,filename,'Sheet','pre','WriteVariableNames',false,'Range',strcat('B5:Q5'));
writetable(T4,filename,'Sheet','pre','WriteVariableNames',false,'Range',strcat('B6:Q6'));
%
T1 = table(energyPost(1), energyPost(2), energyPost(3), energyPost(4), energyPost(5), energyPost(6), energyPost(7), energyPost(8),...
   energyPost(9), energyPost(10), energyPost(11), energyPost(12), energyPost(13), energyPost(14), energyPost(15), energyPost(16));
T2= table(numofIterPost(1), numofIterPost(2), numofIterPost(3), numofIterPost(4), numofIterPost(5), numofIterPost(6), numofIterPost(7), numofIterPost(8),...
   numofIterPost(9), numofIterPost(10), numofIterPost(11), numofIterPost(12), numofIterPost(13), numofIterPost(14), numofIterPost(15), numofIterPost(16));
T3=table(Gray_countPost(1), Gray_countPost(2), Gray_countPost(3), Gray_countPost(4), Gray_countPost(5), Gray_countPost(6), Gray_countPost(7), Gray_countPost(8),...
   Gray_countPost(9), Gray_countPost(10), Gray_countPost(11), Gray_countPost(12), Gray_countPost(13), Gray_countPost(14), Gray_countPost(15), Gray_countPost(16));
T4=table(pixel_countPost(1), pixel_countPost(2), pixel_countPost(3), pixel_countPost(4), pixel_countPost(5), pixel_countPost(6), pixel_countPost(7), pixel_countPost(8),...
   pixel_countPost(9), pixel_countPost(10), pixel_countPost(11), pixel_countPost(12), pixel_countPost(13), pixel_countPost(14), pixel_countPost(15), pixel_countPost(16));
writetable(T1,filename,'Sheet','Post','WriteVariableNames',false,'Range',strcat('B3:Q4'));
writetable(T2,filename,'Sheet','Post','WriteVariableNames',false,'Range',strcat('B4:Q4'));
writetable(T3,filename,'Sheet','Post','WriteVariableNames',false,'Range',strcat('B5:Q5'));
writetable(T4,filename,'Sheet','Post','WriteVariableNames',false,'Range',strcat('B6:Q6'));
%
disp('Data has been written to excel sheet, check energy.xlsx in the current folder!');