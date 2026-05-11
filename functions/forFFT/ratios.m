function [skewratio, kurtratio] = ratios(y)
[v_skew, v_kurt] = findstderror(y);
skewratio = skewness(y) / v_skew;
kurtratio = (kurtosis(y)-3) / v_kurt;
