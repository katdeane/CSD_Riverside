function [Cohd, Xmean, Ymean, Xstd, Ystd] = igetCohensd(X,Y)

% Cohd will be positive if X is greater than Y
Xmean = mean(X); Ymean = mean(Y);
Xstd  = std(X); Ystd = std(Y);
Cohd = (Xmean - Ymean) / (sqrt(Xstd^2 + Ystd^2) / 2);