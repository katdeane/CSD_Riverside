function index = StimIndex(dataList,Cond,Subject,Condition)

% this function gives back the index that should be taken to pull the data
% for this subject for this condiiton. 

% Cond is the Condition list pulled in from running the group meta script
% (e.g. 'MKO.m')
% Subject = 1 (1st subject in group) 
% Condition = 'NoiseBurst' 


if matches(Condition,'NoiseBurst')
    index =  length(Cond.(Condition){Subject});
else
    for idirtytrick = 1:length(dataList)
        if exist('index','var')
            continue
        elseif isempty(dataList{idirtytrick})
            continue
        elseif contains(dataList{idirtytrick},Condition)
            index = idirtytrick;
        else
            continue
        end
    end
end

if ~exist('index','var')
    index = [];
end