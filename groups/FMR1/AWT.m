%%% Group AWT = Awake Wild Type (C57 B6/J) males
animals = {'AWT01','AWT02','AWT06','AWT07','AWT08','AWT13','AWT14'};

% ruled out:
% AWT04 and AWT05 had too low amplitude responses
% AWT09, hardware stopped working at the beginning of recording
% AWT03 had huge artifacts throughout 

% notes:
% AWT11 click train cut off on the last trial, possibly some line noise
% AWT12 had some movement artifacts (jumps)
% AWT15 signal a little weak

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... %01
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27]'...%02
    '[20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... %06
    '[18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',... %07
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32]',... %08
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6]' ...%13 
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]' ...%14
    };

%           01          02          06          07          08          13          14         
Layer.II = {'[1:3]',	'[1:3]',	'[1:4]',    '[1:3]',    '[1:3]',	'[1:2]',    '[1:4]'}; 
         
Layer.IV = {'[4:7]',	'[4:11]',	'[5:9]',    '[4:9]',    '[4:9]',	'[3:8]',    '[5:11]'};
     
Layer.Va = {'[8:10]',	'[12:15]',	'[10:13]',  '[10:12]',  '[10:12]',	'[9:12]',   '[12:15]'};
   
Layer.Vb = {'[11:15]',	'[16:19]',	'[14:17]',  '[13:17]',  '[13:18]',	'[13:18]',  '[16:19]'};
    
Layer.VI = {'[16:22]',	'[20:21]',	'[18:21]',  '[18:22]',  '[19:21]',	'[19:22]',  '[20:23]'}; 

% first noiseburst contains date and time window of recording

%% Conditions
Cond.NoiseBurst = {...
    {'02','03'},... %AWT01 5.30.24 (14:30-15:30) {allego 1, 2}
    {'01','02'},... %AWT02 5.31.24 (10:44-11:45) {allego 0, 1}
    {'01','02'},... %AWT06 6.21.24 (11:15-12:20) {allego 13, 0} - restarted allego
    {'01','02'},... %AWT07 6.21.24 (12:26-13:35) {allego 3, 4}
    {'01','02'},... %AWT08 6.21.24 (13:40-14:50) {allego 11, 12}
    {'01'},... %AWT13 - 9.6.24 (13:10-14:10)     {allego 24}
    {'01'},... %AWT14 - 9.6.42 (14:18-15:25)     {allego 31}
    };

Cond.Spontaneous = {...
    {'04'},... %AWT01 - {allego 3}
    {'03'},... %AWT02 - {allego 2}
    {'03'},... %AWT06 - {allego 1}
    {'03'},... %AWT07 - {allego 5}
    {'03'},... %AWT08 - {allego 14}
    {'02'},... %AWT13 - {allego 25}
    {'02'},... %AWT14 - {allego 32}
    };

Cond.Tonotopy = {...
    {'05'},... %AWT01 - {allego 4}
    {'05'},... %AWT02 - {allego 4}
    {'05'},... %AWT06 - {allego 3}
    {'06'},... %AWT07 - {allego 8}
    {'05'},... %AWT08 - {allego 16}
    {'06'},... %AWT13 - {allego 29}
    {'03'},... %AWT14 - {allego 33}
    };

Cond.ClickTrain = {...
    {'06'},... %AWT01 - {allego 5}
    {'07'},... %AWT02 - {allego 6}
    {'07'},... %AWT06 - {allego 1}
    {'05'},... %AWT07 - {allego 7}
    {'04'},... %AWT08 - {allego 15}
    {'03'},... %AWT13 - {allego 26}
    {'06'},... %AWT14 - {allego 36}
    };

Cond.Chirp = {...
    {'08'},... %AWT01 - {allego 7}
    {'06'},... %AWT02 - {allego 5}
    {'04'},... %AWT06 - {allego 2}
    {'04'},... %AWT07 - {allego 6}
    {'07'},... %AWT08 - {allego 18}
    {'05'},... %AWT13 - {allego 28}
    {'04'},... %AWT14 - {allego 34}
    };

Cond.gapASSR = {...
    {'07'},... %AWT01 - {allego 6}
    {'09'},... %AWT03 - {allego 16}
    {'06'},... %AWT06 - {allego 0} - restarted allego
    {'07'},... %AWT07 - {allego 9}
    {'06'},... %AWT08 - {allego 17}
    {'04'},... %AWT13 - {allego 27}
    {'05'},... %AWT14 - {allego 35}
    };

Cond.postNoiseBurst = {...
    {[]},... %AWT01  - forgot lol
    {'08'},... %AWT02 - {allego 7}
    {'08'},... %AWT06 - {allego 2}
    {'08'},... %AWT07 - {allego 10}
    {'08'},... %AWT08 - {allego 19}
    {'07'},... %AWT13 - {allego 30}
    {'07'},... %AWT14 - {allego 37}
    };
