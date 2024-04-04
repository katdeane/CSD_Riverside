function index = StimIndex(dataList,Cond,Subject,Condition)

% this function gives back the index that should be taken to pull the data
% for this subject for this condition.

% will give index for last noiseburst and first of any other condition

% Cond is the Condition list pulled in from running the group meta script
% (e.g. 'MKO.m')
% Subject = 1 (1st subject in group) 
% Condition = 'NoiseBurst' 


if matches(Condition,'NoiseBurst')
    % check that noiseburst measurement taken (MKO14b)
    if ~isempty(Cond.(Condition){Subject}{1,1}) 
        index =  length(Cond.(Condition){Subject});
    end
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