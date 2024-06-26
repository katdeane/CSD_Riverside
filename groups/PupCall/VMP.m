%%% Group VMP = Virgin Male Pupcall
animals = {'VMP02','VMP03','VMP04','VMP05','VMP06','VMP08'};

% notes:
% VMP01 was a test, did not contain full dataset
% VMP05 was stained in the recording location with Fluoro-ruby
% VMP07 died about 10 minutes after pup calls, during a second pup call
% recording
% VMP08 died about 40 minutes after pup calls, during gapASSR

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31]',... %02
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... %03
    '[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',... %04
    '[18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... %05
    '[18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',... %V06
    '[16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29]',... %V08
    };

%           02          03          04          05          06          08      
Layer.II = {'[1:3]',    '[1:2]',    '[1:4]',    '[1:5]',    '[1:4]',    '[1:4]'}; 

Layer.IV = {'[4:11]',   '[3:9]',    '[5:13]',   '[6:13]',   '[5:12]',    '[5:9]'};

Layer.Va = {'[12:16]',  '[10:12]',  '[14:19]',  '[14:17]',  '[13:18]',  '[10:14]'};

Layer.Vb = {'[17:21]',  '[13:18]',  '[20:24]',  '[18:24]',  '[19:25]',  '[15:19]'}; 

Layer.VI = {'[22:27]',  '[19:24]',  '[24:28]',  '[25:30]',  '[26:29]',  '[20:23]'}; 


%% Conditions
Cond.NoiseBurst = {...
    {'03'},... %VMP02
    {'02'},... %VMP03
    {'03'},... %VMP04
    {'02'},... %VMP05
    {'04'},... %VMP06
    {'03'},... %VMP08
    };

Cond.Pupcall30 = {... % 30 dB attenuation  = 45-50 dB SPL
    {'06'},... %VMP02 
    {'06'},... %VMP03
    {'05'},... %VMP04
    {'03'},... %VMP05
    {'05'},... %VMP06
    {'05'},... %VMP08
    };

Cond.PostNoiseBurst = {...
    {'12'},... %VMP02
    {'09'},... %VMP03
    {'06'},... %VMP04
    {'06'},... %VMP05
    {'07'},... %VMP06
    {'06'},... %VMP08
    };

Cond.Spontaneous = {...
    {'04'},... %VMP02
    {'04'},... %VMP03
    {'04'},... %VMP04
    {'04'},... %VMP05
    {'06'},... %VMP06
    {'04'},... %VMP08
    };

Cond.Chirp = {...
    {'09'},... %VMP02
    {'05'},... %VMP03
    {'07'},... %VMP04
    {'08'},... %VMP05
    {'08'},... %VMP06
    {'08'},... %VMP08
    };

Cond.gapASSR = {...
    {'10'},... %VMP02
    {'08'},... %VMP03
    {'08'},... %VMP04
    {'09'},... %VMP05
    {'09'},... %VMP06
    {[]},... %VMP08
    };

Cond.ClickTrain = {...
    {'11'},... %VMP02
    {'07'},... %VMP03
    {[]},... %VMP04 - loss of response here
    {'07'},... %VMP05
    {'10'},... %VMP06
    {'07'},... %VMP05
    };