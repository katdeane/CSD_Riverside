function [v_skew, v_kurt] = findstderror(y);
N = length(y);
seskew = 6*N*(N-1) / ((N-2)*(N+1)*(N+3));
sekurt = 4*(N^2-1)*seskew / ((N-3)*(N+5));
v_skew = sqrt(seskew);
v_kurt = sqrt(sekurt);
