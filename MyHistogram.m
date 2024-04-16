function [counts, grayLevels] = MyHistogram(x1,x2)
[rows, columns, numberOfColorChannels] = size(x1);
counts = zeros(1, 361);
mxVal=max(x2(:));
for col = 1 : columns
	for row = 1 : rows
		% Get the gray level.
		grayLevel = round(x1(row, col));
		% Add 1 because graylevel zero goes into index 1 and so on.
      if (x2(row,col)>0.001*mxVal)
            counts(grayLevel+ 1) = counts(grayLevel+1) + 1;
      end
	end
end
% Plot the histogram.
grayLevels = 0 : 360;
bar(grayLevels, counts, 'BarWidth', 0.5, 'FaceColor', 'b');
xlabel('degree', 'FontSize', 10);
ylabel('frequency', 'FontSize', 10);
title('Histogram', 'FontSize', 10);
%axis([-180 180 0 max(counts)]);
grid on;
end