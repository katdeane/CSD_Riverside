function cordata = icorrectartifacts(data,thresh,durlength)
% this function performs a rough artifact correction, wherein the channels
% are averaged, rectified, and then gaussian filtered to a factor of 10. The
% input thresh is a multiplier on the std of the data, setting how many
% standard deviations from the mean the data can be before the cut-off. If
% thresh == 3 then there will be a threshold line of 3 standard deviations.
% The guassian filtered trace will have intercept points checked against
% this threshold. Any part of the trace that remains above threshold for at
% least the durlength variable in seconds will be counted as artifact and 
% replaced with nan. Identical data will be returned except with NaN'd artifacts. 

% changing the thresh input and the duration over which the signal must
% stay above threshold will determine how strict artifact correction is

% the downside to this method is that if there is a piece of data extremely
% riddled with artifacts, the std will be higher and true artifacts may be
% left in. Vice versa with very clean data counting false artifacts. The
% upside is uniform treatment of the data with no tedious manual
% correction.

% mean all channels and rectify trace
trace      = abs(mean(data,1));
% gaussian filter the data to get better detection windows
gaustrace  = imgaussfilt(trace,10);
% find the std of the rectified data
tracestd   = nanstd(trace);
tracemean  = nanmean(trace);
% multiply by the threshold. This will determine how aggressive artifact
% correction will be
datathresh = tracemean + (tracestd*thresh);
%find intercept points 
location   = datathresh < gaustrace; % 1 is above, 0 is below

% sanity check - raw data trace vs std threshold
% plot every 3 seconds
% tiledlayout('flow')
% nexttile
% yline(datathresh)
% hold on 
% for itra = 1:ceil(length(trace)/3000)
%     if itra == ceil(length(trace)/3000)
%         plot(trace((itra - 1)*3000 + 1:end))
%     else
%         plot(trace((itra - 1)*3000 + 1:(itra - 1)*3000 +3000))
%     end
% end
% 
% nexttile
% yline(datathresh)
% hold on 
% for itra = 1:ceil(length(gaustrace)/3000)
%     if itra == ceil(length(gaustrace)/3000)
%         plot(gaustrace((itra - 1)*3000 + 1:end))
%     else
%         plot(gaustrace((itra - 1)*3000 + 1:(itra - 1)*3000 +3000))
%     end
% end
% 
% nexttile 
% plot(location)

% detect when signal crosses
crossover   = diff(location);
onsets      = find(crossover == 1); %ABOVE threshold
offsets     = find(crossover == -1); %BELOW threshold
if length(offsets) < length(onsets)
    offsets = [offsets length(trace)];
end

% which of these is longer than 5 seconds above threshold (rectifying and
% gaussian filtering avoid the trace bouncing far above and below
% threshold)
durations = offsets - onsets;
durbool   = durations > durlength;
onsets    = onsets(durbool);
offsets   = offsets(durbool);

% figure
% nexttile
% yline(datathresh)
% hold on 
% plot(trace(onsets(1)-100:offsets(1)+100))
% plot(gaustrace(onsets(1)-100:offsets(1)+100))
% 
% nexttile
% yline(datathresh)
% hold on 
% plot(trace(onsets(2)-100:offsets(2)+100))
% plot(gaustrace(onsets(2)-100:offsets(2)+100))
% 
% nexttile
% yline(datathresh)
% hold on 
% plot(trace(onsets(3)-100:offsets(3)+100))
% plot(gaustrace(onsets(3)-100:offsets(3)+100))

% now nan all detected artifacts in raw data
cordata = data;
for iart = 1:length(onsets)
    window = onsets(iart):offsets(iart);
    cordata(:,window) = nan(size(data,1),length(window));
end

% nexttile
% plot(trace)
% hold on
% cortrace = abs(mean(cordata,1));
% plot(cortrace)

