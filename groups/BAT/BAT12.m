%%% Group BAT - Awake, each letter denotes a different recording location
animals = {'BAT12a','BAT12b','BAT12c','BAT12d','BAT12e'};  

% notes:
% I could really only get a response from one small area of cortex, 12c
% and 12e on my cortical schematic. These were lower frequency and at the
% bottom of my window, so I should have seen other higher frequency
% responses elsewhere in the space I had opened. I took a few bad
% recordings in an attempt to get higher CF but they aren't usable. 

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7]',...%12a
    '[18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26]',...%12b
    '[18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26]',...%12c
    '[21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',...%12d
    '[14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6]',...%12e
    };

%           12a         12b         12c         12d         12e         
Layer.II = {'[1:3]',    '[1:4]',    '[1:4]',    '[1:4]',    '[1:3]'}; 

Layer.IV = {'[4:9]',    '[5:9]',    '[5:9]',    '[5:9]',    '[4:8]'};

Layer.Va = {'[10:11]',  '[10:11]',  '[10:11]',  '[10:11]',  '[9:10]'};

Layer.Vb = {'[12:14]',  '[12:14]',  '[12:14]',  '[12:14]',  '[11:12]'}; 

Layer.VI = {'[15:16]',  '[15:16]',  '[15:17]',  '[15:16]',  '[13:17]'}; 



%% Conditions
Cond.NoiseBurst = {...
    {'07'},... %B12a %25KB
    {'23'},... %B12b
    {'41'},... %B12c
    {'58'},... %B12d
    {'76'},... %B12e
    };

Cond.CF = {...
    {'10'},... %B12a %210KB
    {'26'},... %B12b
    {'44'},... %B12c
    {'60'},... %B12d
    {'80'},... %B12e
    };

Cond.Spontaneous = {...
    {'08'},... %B12a %19.5KB
    {'24'},... %B12b
    {'42'},... %B12c 
    {'59'},... %B12d
    {'77'},... %B12e
    };

Cond.TonotopyNSR60 = {...
    {[]},... %B12a %63.7KB
    {[]},... %B12b
    {[]},... %B12c
    {[]},... %B12d
    {[]},... %B12e
    };

Cond.TonotopyNSR70 = {...
    {'11'},... %B12a %63.7KB
    {'25'},... %B12b
    {'40'},... %B12c
    {'61'},... %B12d
    {'78'},... %B12e
    };

Cond.ClickTrain = {...
    {'09'},... %B12a %152.6KB
    {'27'},... %B12b
    {'43'},... %B12c
    {'62'},... %B12d
    {'79'},... %B12e
    };

Cond.BBN0 = {...
    {'12'},... %B12a %30.6-31KB
    {'28'},... %B12b
    {'46'},... %B12c
    {'63'},... %B12d
    {'81'},... %B12e
    };

Cond.BBN1 = {...
    {'13'},... %B12a
    {'29'},... %B12b
    {'47'},... %B12c
    {'64'},... %B12d
    {'82'},... %B12e
    };

Cond.BBN2 = {...
    {'14'},... %B12a
    {'30'},... %B12b
    {'48'},... %B12c
    {'65'},... %B12d
    {'83'},... %B12e
    };

Cond.BBN3 = {...
    {'15'},... %B12a
    {'31'},... %B12b
    {'49'},... %B12c
    {'66'},... %B12d
    {'84'},... %B12e
    };

Cond.BBN4 = {...
    {'16'},... %B12a
    {'32'},... %B12b
    {'50'},... %B12c
    {'67'},... %B12d
    {'85'},... %B12e
    };

Cond.BBNm1 = {...
    {'17'},... %B12a
    {'33'},... %B12b
    {'51'},... %B12c
    {'68'},... %B12d
    {'86'},... %B12e
    };

Cond.BBNm2 = {...
    {'18'},... %B12a
    {'34'},... %B12b
    {'52'},... %B12c
    {'69'},... %B12d
    {'87'},... %B12e
    };

Cond.BBNm3 = {...
    {'19'},... %B12a
    {'35'},... %B12b
    {'53'},... %B12c
    {'70'},... %B12d
    {'88'},... %B12e
    };

Cond.BBNm4 = {...
    {'20'},... %B12a
    {'36'},... %B12b
    {'54'},... %B12c
    {'71'},... %B12d
    {'89'},... %B12e
    };