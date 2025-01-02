%%This study was ran by Anjum, Levi, & Katrina to identify auditory laminar
%%differences during peak estrogen (Proestrus/estrus)  and low estrogen
%%(Metestrus/Diestrus), with young (2-7 month old) FVB Female mice.

%%PRO = Proestrus/Estrus Mice Group
%%CSD
animals = {'FYS06','FYE01','FYE02','FYE03','FYE05','FYE07','FYE09','FYE10','FYE12','FYE13'};  
 
% notes:
%FYS06 & FYS10 data was used for both aging study and estrous study
%FYE01 CSD was difficult to define bc of there being low signal

%% Channels and Layers
%channel order: [17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]

channels = {...
  '[12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',...YS06
  '[20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4]',...YE01
  '[15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28]',...YE02
  '[19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5]',...YE03
  '[23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',...YE05
  '[11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32]',...YE07
  '[22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2]',...YE09
  '[20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',...YE10
  '[10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1]',...YE12
  '[13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30]',...YE13
   };

%            YS06     YE01    YE02    YE03    YE05    YE07    YE09    YE10
Layer.II = {'[1:3]','[1:4]','[1:3]','[1:3]','[1:3]','[1:3]','[1:3]','[1:3]',...
 ...%    YE12   YE13     YE14
    '[1:3]','[1:3]','[1:3]'}; 
%              
Layer.IV = {'[4:8]','[5:9]','[4:7]','[4:9]','[4:8]','[4:8]','[4:9]','[4:9]',...
   '[4:7]','[4:8]','[4:7]'};
%              
Layer.Va = {'[9:12]','[10:12]','[8:9]','[10:11]','[9:10]','[9:12]','[10:13]','[10:13]',...
    '[8:10]','[9:12]','[8:10]'};
%              
Layer.Vb = {'[13:15]','[13:15]','[10:12]','[12:15]','[11:13]','[13:16]','[14:17]','[14:18]',...
    '[11:13]','[13:17]','[11:13]'}; 
%              
Layer.VI = {'[16:18]','[16:20]','[13:20]','[16:20]','[14:18]','[17:20]','[18:20]','[19:21]',...
    '[14:19]','[18:20]','[14:28]'};

%% Conditions
Cond.NoiseBurst = {...
    {'01'},... FYS06
    {'02'},... FYE01
    {'01'},... FYE02
    {'01'},... FYE03
    {'01'},... FYE05
    {'01'},... FYE07
    {'02'},... FYE09
    {'01'},... FYE10
    {'01'},... FYE12
    {'03'},... FYE13
    };

Cond.gapASSR = {...
    {'04'},... FYS06
    {'06'},... FYE01
    {'05'},... FYE02
    {'05'},... FYE03
    {'05'},... FYE05
    {'04'},... FYE07
    {'05'},... FYE09
    {'05'},... FYE10
    {'03'},... FYE12
    {'05'},... FYE13
    };

Cond.Tonotopy = {...
   {'03'},... FYS06
   {'03'},... FYE01
   {'02'},... FYE02
   {'02'},... FYE03
   {'03'},... FYE05
   {'03'},... FYE07
   {'04'},... FYE09
   {'04'},... FYE10
   {'02'},... FYE12
   {'04'},... FYE13
    };

Cond.Spontaneous = {...
    {'06'},... FYS06
    {'07'},... FYE01
    {'06'},... FYE02
    {'07'},... FYE03
    {'06'},... FYE05
    {'06'},... FYE07
    {'07'},... FYE09
    {'06'},... FYE10
    {'06'},... FYE12
    {'08'},... FYE13
	};

Cond.ClickTrain = {...
   {'05'},... FYS06
   {'05'},... FYE01
   {'04'},... FYE02
   {'04'},... FYE03
   {'02'},... FYE05
   {'02'},... FYE07
   {'03'},... FYE09
   {'02'},... FYE10
   {'04'},... FYE12
   {'06'},... FYE13
	};

Cond.Chirp = {...
    {'02'},... FYS06
    {'04'},... FYE01
    {'03'},... FYE02
    {'03'},... FYE03
    {'04'},... FYE05
    {'05'},... FYE07
    {'06'},... FYE09
    {'03'},... FYE10
    {'05'},... FYE12
    {'07'},... FYE13
    };
