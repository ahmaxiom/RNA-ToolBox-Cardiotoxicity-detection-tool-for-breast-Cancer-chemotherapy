function [dos] = dos(img1)
%% Written at 21-9-2021 based on information of https://stats.stackexchange.com/questions/379666/measure-of-smoothness
%% this function computes the degree of smoothness of an image according to
%% the sum of magnitude (sqrt of the square of all gradients)
% img is the image to compute dos for
% dos is the degree of smoothness
[m n l] = size(img1);
dos = sum(sum(sum(sqrt(gradient(gradient(gradient(double(img1)))).^2))))/(m*n*l);
end

