%%% Group AWT = Awake Wild Type (C57 B6/J) males
animals = {'AWT07'};

% ruled out:

% notes:
% AWT03 had huge artifacts throughout

%% Channels and Layers
% channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
    '[18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29]',... %07
    };

%           01          02          03          04          05          06          07          08      
Layer.II = {'[1:3]'}; 
         
Layer.IV = {'[4:8]'};
     
Layer.Va = {'[9:12]'};
   
Layer.Vb = {'[13:16]'};
    
Layer.VI = {'[17:23]'}; 



%% Conditions
Cond.NoiseBurst = {...
    {'01','02'},... %AWT07
    };


Cond.ClickTrain = {...
    {'05'},... %AWT07
	};


Cond.gapASSR = {...
    {'07'},... %AWT07
    };

