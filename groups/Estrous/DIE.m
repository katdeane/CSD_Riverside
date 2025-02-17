%%This study was ran by Anjum, Levi, & Katrina to identify auditory laminar
%%differences during peak estrogen (Proestrus/estrus)  and low estrogen
%%(Metestrus/Diestrus), with young (2-7 month old) FVB Female mice.

%%DIE = Diestrus/Metestrus Mice Group
%% I'm sorry for the ominous naming, I could not figure out how else to shorten diestrus into 3 letters

%%CSD
animals = {'FYS10','FYE04','FYE06','FYE08','FYE11','FYE14','FYE16','FYE17','FYE18','FYE19'};  
 
% notes:


%% Channels and Layers
%channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
  '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',...YS10
  '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',...YE04
  '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',...YE06
  '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',...YE08
  '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3]',...YE11
  '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',...YE14
  '[18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27]',...YE16
  '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29]',...YE17
  '[20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',...YE18
  '[21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32]',...YE19
   };

%             YS10    YE04    YE06    YE08   YE11    YE14     YE16   YE17
Layer.II = {'[1:3]','[1:3]','[1:3]','[1:2]','[1:3]','[1:3]','[1:3]','[1:3]','[1:3]','[1:4]'}; 
%              
Layer.IV = {'[4:8]','[4:8]','[4:8]','[3:8]','[4:8]','[4:7]','[4:8]','[4:7]','[4:8]','[5:9]'};
%              
Layer.Va = {'[9:11]','[9:10]','[9:12]','[9:11]','[9:11]','[8:10]','[9:11]','[9:11]','[9:11]','[10:12]'};
%              
Layer.Vb = {'[12:14]','[11:13]','[13:16]','[12:15]','[11:14]','[11:13]','[12:14]','[12:14]','[12:15]','[13:17]'}; 
%              
Layer.VI = {'[15:17]','[14:18]','[17:21]','[16:20]','[15:19]','[14:17]','[15:19]','[15:16]','[16:20]','[18:23]'};

%% Conditions
Cond.NoiseBurst = {...
    {'01'},... FYS10
    {'01'},... FYE04
    {'01'},... FYE06
    {'01'},... FYE08
    {'03'},... FYE11
    {'01'},... FYE14
    {'01'},... FYE16
    {'01'},... FYE17
    {'01'},... FYE18
    {'01'},... FYE19
    };

Cond.gapASSR = {...
    {'05'},... FYS10
    {'05'},... FYE04
    {'05'},... FYE06
    {'04'},... FYE08
    {'07'},... FYE11
    {'03'},... FYE14
    {'04'},... FYE16
    {'03'},... FYE17
    {'03'},... FYE18
    {'04'},... FYE19
    };

Cond.Tonotopy = {...
   {'02'},... FYS10
   {'02'},... FYE04
   {'03'},... FYE06
   {'03'},... FYE08
   {'06'},... FYE11
   {'02'},... FYE14
   {'02'},... FYE16
   {'02'},... FYE17
   {'02'},... FYE18
   {'03'},... FYE19
    };

Cond.Spontaneous = {...
    {'06'},... FYS10
    {'07'},... FYE04
    {'06'},... FYE06
    {'06'},... FYE08
    {'08'},... FYE11
    {'06'},... FYE14
    {'06'},... FYE16
    {'06'},... FYE17
    {'06'},... FYE18
    {'06'},... FYE19
	};

Cond.ClickTrain = {...
   {'04'},... FYS10
   {'04'},... FYE04
   {'02'},... FYE06
   {'02'},... FYE08
   {'04'},... FYE11
   {'04'},... FYE14
   {'05'},... FYE16
   {'04'},... FYE17
   {'04'},... FYE18
   {'05'},... FYE19
	};

Cond.Chirp = {...
    {'03'},... FYS10
    {'03'},... FYE04
    {'04'},... FYE06
    {'05'},... FYE08
    {'05'},... FYE11
    {'05'},... FYE14
    {'03'},... FYE16
    {'05'},... FYE17
    {'05'},... FYE18
    {'02'},... FYE19
    };

