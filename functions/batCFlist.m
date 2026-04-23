function batCFlist(homedir,Group)

cd(homedir); cd output/batCF/
run([Group '.m'])
clear channels Cond Layer % just want animals
tones = {'5' '10' '15' '20' '25' '30' '35'};

if ~exist([Group '_CFlist.csv'],'file')

    % initiate a table for the CF
    CFlist = table('Size',[length(animals) 2],'VariableTypes',{'string','double'});
    CFlist.Properties.VariableNames = ["Subject", "CF"];

    for iSub = 1:length(animals)
        Name = animals{iSub};
        load([Name '_CF.mat'],'PAdat','BaseAVG','BaseSTD')
        
        % PAdat is in level x tone x layer
        % just look at layer IV
        PAdat = PAdat(:,:,2);
        Thresh = BaseAVG+BaseSTD;
        Overthresh = PAdat > Thresh;

        % find the lowest dB with data, then the max response at that dB
        thisCFpre = NaN;
        for ilev = 4:-1:1 % 30 dB at the bottom
            if ~isnan(thisCFpre)
                continue
            end
            thisPA = Overthresh(ilev,:);
            if sum(thisPA) == 0 % no responses
                continue
            elseif sum(thisPA) > 1 % multiple responses
                maxPA = max(PAdat(ilev,thisPA));
                thisCFpre = PAdat(ilev,:) == maxPA;
            else % only one response
                thisCFpre = thisPA;
            end
        end
    
        % give us the actual tone frequency as an answer
        if sum(Overthresh) == 0 % no detections at all
            thisCF = 0;
        else
            thisCF = str2num(tones{thisCFpre});
        end
        % automated check of detected CF correctness
        thisCF = icheckCF(homedir,thisCF,Name);
        % now fill it in
        CFlist.Subject(iSub) = Name;
        CFlist.CF(iSub) = thisCF;

    end

    writetable(CFlist,[Group '_CFlist.csv']);

else
    % open the current list and check which subjects already have data rows
    CFlist = readtable([Group '_CFlist.csv']);
    
     for iSub = 1:length(animals)
        Name = animals{iSub};
        % skip if subject is already in list
        if matches(Name,CFlist.Subject)
            continue
        end

        % append the new subjects onto the list
        load([Name '_CF.mat'],'PAdat','BaseAVG','BaseSTD')
        
        % PAdat is in level x tone x layer
        % just look at layer IV
        PAdat = PAdat(:,:,2);
        Thresh = BaseAVG+BaseSTD;
        Overthresh = PAdat > Thresh;

        % find the lowest dB with data, then the max response at that dB
        thisCFpre = NaN;
        for ilev = 4:-1:1 % 30 dB at the bottom
            if ~isnan(thisCFpre)
                continue
            end
            thisPA = Overthresh(ilev,:);
            if sum(thisPA) == 0 % no responses
                continue
            elseif sum(thisPA) > 1 % multiple responses
                maxPA = max(PAdat(ilev,thisPA));
                thisCFpre = PAdat(ilev,:) == maxPA;
            else % only one response
                thisCFpre = thisPA;
            end
        end
    
        % give us the actual tone frequency as an answer
        if sum(Overthresh) == 0 % no detections at all
            thisCF = 0;
        else
            thisCF = str2num(tones{thisCFpre});
        end
        % automated check of detected CF correctness
        thisCF = icheckCF(homedir,thisCF,Name);
        % now fill it in
        NewRow = {Name,thisCF};
        CFlist = [CFlist;NewRow];
     end
     % overwrite table 
     writetable(CFlist,[Group '_CFlist.csv']);
end