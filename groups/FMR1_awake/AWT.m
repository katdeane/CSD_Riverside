%%% Group AWT = Awake Wild Type (C57 B6/J) males
animals = {'AWT01','AWT02','AWT03','AWT06','AWT07','AWT08','AWT10','AWT11','AWT12','AWT13','AWT14','AWT15'};

% ruled out:
% AWT04 and AWT05 had too low amplitude responses
% AWT09, hardware stopped working at the beginning of recording

% notes:
% AWT03 had huge artifacts throughout (last click train not bad through)
% AWT11 click train cut off on the last trial, possibly some line noise
% AWT12 had some movement artifacts (jumps)
% AWT15 signal a little weak

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... %01
    '[20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',... %02
    '[14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... %03
    '[19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',... %06
    '[18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29]',... %07
    '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32]',... %08
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]' ...%10
    '[14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]' ...%11
    '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]' ...%12
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6]' ...%13
    '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]' ...%14
    '[14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]' ...%15
    };

%           01          02          03          06          07          08           10          11          12          13          14          15 
Layer.II = {'[1:3]',	'[1:3]',    '[1:4]',	'[1:4]',    '[1:3]',    '[1:2]',    '[1:4]',	'[1:3]',    '[1:3]',	'[1:2]',    '[1:4]',    '[1:3]'}; 
         
Layer.IV = {'[4:11]',	'[4:11]',   '[5:11]',	'[5:12]',   '[4:8]',    '[3:7]',    '[5:10]',	'[4:9]',    '[4:9]',	'[3:8]',    '[5:11]',   '[4:10]'};
     
Layer.Va = {'[12:14]',	'[12:15]',  '[12:14]',	'[13:15]',  '[9:12]',   '[8:10]',   '[11:13]',	'[10:12]',  '[10:13]',	'[9:12]',   '[12:15]',  '[11:13]'};
   
Layer.Vb = {'[15:19]',	'[16:19]',  '[15:18]',	'[16:18]',  '[13:16]',  '[11:16]',  '[14:18]',	'[13:16]',  '[14:18]',	'[13:18]',  '[16:19]',  '[14:17]'};
    
Layer.VI = {'[21:23]',	'[20:21]',  '[19:21]',	'[19:22]',  '[17:23]',  '[17:21]',  '[19:22]',	'[17:21]',  '[19:21]',	'[19:22]',  '[20:23]',  '[18:21]'}; 

% first noiseburst contains date and time window of recording

%% Conditions
Cond.NoiseBurst = {...
    {'02','03'},... %AWT01 5.30.24 (14:30-15:30) {allego 1, 2}
    {'01','02'},... %AWT02 5.31.24 (10:44-11:45) {allego 0, 1}
    {'05','06'},... %AWT03 5.31.24 (11:51-~)     {allego 12, 13}
    {'01','02'},... %AWT06 6.21.24 (11:15-12:20) {allego 13, 0} - restarted allego
    {'01','02'},... %AWT07 6.21.24 (12:26-13:35) {allego 3, 4}
    {'01','02'},... %AWT08 6.21.24 (13:40-14:50) {allego 11, 12}
    {'02'},... %AWT10 - 9.6.42 (8:50-10:00)      {allego 1}
    {'02'},... %AWT11 - 9.6.24 (10:06-11:25)     {allego 9}
    {'01','02'},... %AWT12 - 9.6.42 (11:25-13:00){allego 16, 17}
    {'01'},... %AWT13 - 9.6.24 (13:10-14:10)     {allego 24}
    {'01'},... %AWT14 - 9.6.42 (14:18-15:25)     {allego 31}
    {'02','03'},... %AWT15 - 9.6.24 (15:30-end)  {allego 39, 40}
    };

Cond.Spontaneous = {...
    {'04'},... %AWT01 - {allego 3}
    {'03'},... %AWT02 - {allego 2}
    {'07'},... %AWT03 - {allego 14}
    {'03'},... %AWT06 - {allego 1}
    {'03'},... %AWT07 - {allego 5}
    {'03'},... %AWT08 - {allego 14}
    {'03'},... %AWT10 - {allego 2}
    {'03'},... %AWT11 - {allego 10}
    {'03'},... %AWT12 - {allego 18}
    {'02'},... %AWT13 - {allego 25}
    {'02'},... %AWT14 - {allego 32}
    {'04'},... %AWT15 - {allego 41}
    };

Cond.Tonotopy = {...
    {'05'},... %AWT01 - {allego 4}
    {'05'},... %AWT02 - {allego 4}
    {'10'},... %AWT03 - {allego 17}
    {'05'},... %AWT06 - {allego 3}
    {'06'},... %AWT07 - {allego 8}
    {'05'},... %AWT08 - {allego 16}
    {'06'},... %AWT10 - {allego 5}
    {'05'},... %AWT11 - {allego 12}
    {'04'},... %AWT12 - {allego 19}
    {'06'},... %AWT13 - {allego 29}
    {'03'},... %AWT14 - {allego 33}
    {'08'},... %AWT15 - {allego 46}
    };

Cond.ClickTrain = {...
    {'06'},... %AWT01 - {allego 5}
    {'07'},... %AWT02 - {allego 6}
    {'13'},... %AWT03 - {allego 20} second taken due to less artifacts later, first rejected
    {'07'},... %AWT06 - {allego 1}
    {'05'},... %AWT07 - {allego 7}
    {'04'},... %AWT08 - {allego 15}
    {'07'},... %AWT10 - {allego 6}
    {'06'},... %AWT11 - {allego 13}
    {'05'},... %AWT12 - {allego 20}
    {'03'},... %AWT13 - {allego 26}
    {'06'},... %AWT14 - {allego 36}
    {'07'},... %AWT15 - {allego 45}
    };

Cond.Chirp = {...
    {'08'},... %AWT01 - {allego 7}
    {'06'},... %AWT02 - {allego 5}
    {'11'},... %AWT03 - {allego 18}
    {'04'},... %AWT06 - {allego 2}
    {'04'},... %AWT07 - {allego 6}
    {'07'},... %AWT08 - {allego 18}
    {'05'},... %AWT10 - {allego 4}
    {'04'},... %AWT11 - {allego 11}
    {'07'},... %AWT12 - {allego 22}
    {'05'},... %AWT13 - {allego 28}
    {'04'},... %AWT14 - {allego 34}
    {'05'},... %AWT15 - {allego 42}
    };

Cond.gapASSR = {...
    {'07'},... %AWT01 - {allego 6}
    {'04'},... %AWT02 - {allego 3}
    {'09'},... %AWT03 - {allego 16}
    {'06'},... %AWT06 - {allego 0} - restarted allego
    {'07'},... %AWT07 - {allego 9}
    {'06'},... %AWT08 - {allego 17}
    {'04'},... %AWT10 - {allego 3}
    {'07'},... %AWT11 - {allego 14}
    {'06'},... %AWT12 - {allego 21}
    {'04'},... %AWT13 - {allego 27}
    {'05'},... %AWT14 - {allego 35}
    {'06'},... %AWT15 - {allego 44}
    };

Cond.postNoiseBurst = {...
    {[]},... %AWT01  - forgot lol
    {'08'},... %AWT02 - {allego 7}
    {'12'},... %AWT03 - {allego 20}
    {'08'},... %AWT06 - {allego 2}
    {'08'},... %AWT07 - {allego 10}
    {'08'},... %AWT08 - {allego 19}
    {'08'},... %AWT10 - {allego 7}
    {'08'},... %AWT11 - {allego 15}
    {'08'},... %AWT12 - {allego 23}
    {'07'},... %AWT13 - {allego 30}
    {'07'},... %AWT14 - {allego 37}
    {'09'},... %AWT15 - {allego 47}
    };
