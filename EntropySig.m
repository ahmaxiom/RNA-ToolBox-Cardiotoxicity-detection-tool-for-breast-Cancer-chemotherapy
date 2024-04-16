%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Entropy & Synchrony Calculation %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [en]=EntropySig(signal)
hist1 = hist(signal);
phist = hist1 ./ sum(hist1);
p=phist(phist~=0);
en = -sum(p.*log2(p))/log2(length(signal));