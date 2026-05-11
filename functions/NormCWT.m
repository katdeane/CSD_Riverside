% background normalization of CWT plots. 

% does this make sense to even do with inter-trial phase coherence? I don't
% think so, so it wouldn't really help with that aspect of the California
% mice. There's a trending difference there, but it isn't significant.


% for power though, if there's a background difference, it makes sense to 
% normalize.The Ray Maunsell 2011 paper normalized spike triggered
% time-frequency average (STTFA) by taking log(STTFA) - log(rSTTFA), where
% the r means a randomized area of randomization, basically taking the
% background. 
% We have a 25 second pup call CWT, which we can get power or single trial
% power from. That has a 400 ms baseline. We also have 2 minutes of
% spontaneous activity. We probably want to normalize by one value per
% frequency row. The baseline probably isn't long enough for the lower
% frequencies before hitting edge effects. So we can take 25 seconds out of
% the spontaneous measurement for each subject, get a vector to normalize
% by, log it. Log the power scalograms, subtract the log(spont) from each
% column. Then we'll have normalization to rest. 

