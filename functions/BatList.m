% make grand bat list 

speaker = 1:1:11;
speakerrep = repmat(speaker,1,20);

signal = ones(1,220);
signal2 = signal*2;
signal3 = signal*3;

a = [signal, signal2, signal3];
b = [speakerrep, speakerrep, speakerrep];

list = [a;b];

shuforder = randperm(length(list));

shuflist = list(:,shuforder)';