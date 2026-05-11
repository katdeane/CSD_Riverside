%%% Group BAT - Awake, each letter denotes a different recording location
animals = {'BAT13a','BAT13b'}; % ,'BAT13c' - need to get CF measurement in  

% notes:
% 13a - During insertion a small amount of blood came up. 
%       Signal was good but during BBNs it suddently went flat after adding 
%       saline to cortex. It recovered (I took BBN4) and then flattened
%       again. I removed her in case there was some issue with breathing
%       that was causing loss of consciousness. However, she was
%       rambunctious right out of fixation. On inspection the following
%       day, the area looked to have sustained damage, loss of vasculature
%       and some tissue buldging. The next probe location was sufficiently
%       distant.

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',...%13a
    '[16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8]',...%13b
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7]',...%13c
    };

%           13a         13b         13c             
Layer.II = {'[1:3]',    '[1:4]',    '[1:4]'}; 

Layer.IV = {'[4:8]',    '[5:9]',    '[5:10]'};

Layer.Va = {'[9:10]',  '[10:11]',   '[11:12]'};

Layer.Vb = {'[11:13]',  '[12:14]',  '[13:14]'}; 

Layer.VI = {'[14:17]',  '[15:17]',  '[15:17]'}; 



%% Conditions
Cond.NoiseBurst = {...
    {'02'},... %B13a %25KB
    {'13'},... %B13b
    {'33'},... %B13c
    };

Cond.CF = {...
    {'06'},... %B13a %210KB
    {'16'},... %B13b
    {'36'},... %B13c
    };

Cond.Spontaneous = {...
    {'03'},... %B13a %19.5KB
    {'14'},... %B13b
    {'34'},... %B13c 
    };

Cond.TonotopyNSR60 = {...
    {[]},... %B13a %63.7KB
    {[]},... %B13b
    {[]},... %B13c
    };

Cond.TonotopyNSR70 = {...
    {'05'},... %B13a %63.7KB
    {'17'},... %B13b
    {'35'},... %B13c
    };

Cond.ClickTrain = {...
    {'04'},... %B13a %152.6KB
    {'15'},... %B13b
    {'37'},... %B13c
    };

Cond.BBN0 = {...
    {'07'},... %B13a %30.6-31KB
    {'18'},... %B13b
    {'38'},... %B13c
    };

Cond.BBN1 = {...
    {'08'},... %B13a
    {'19'},... %B13b
    {'39'},... %B13c
    };

Cond.BBN2 = {...
    {'09'},... %B13a
    {'20'},... %B13b
    {'40'},... %B13c
    };

Cond.BBN3 = {...
    {'10'},... %B13a
    {'21'},... %B13b
    {'41'},... %B13c
    };

Cond.BBN4 = {...
    {'11'},... %B13a
    {'22'},... %B13b
    {'42'},... %B13c
    };

Cond.BBNm1 = {...
    {[]},... %B13a
    {'23'},... %B13b
    {'43'},... %B13c
    };

Cond.BBNm2 = {...
    {[]},... %B13a
    {'24'},... %B13b
    {'44'},... %B13c
    };

Cond.BBNm3 = {...
    {[]},... %B13a
    {'25'},... %B13b
    {'45'},... %B13c
    };

Cond.BBNm4 = {...
    {[]},... %B13a
    {'26'},... %B13b
    {'46'},... %B13c
    };