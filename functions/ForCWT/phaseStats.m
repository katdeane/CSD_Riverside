function [obs_stat, effectsize, obs_clusters] = phaseStats(Grp1, Grp2, grpsize1, grpsize2)

% data coming in is shaped like : measurement x spectral frequency x time
% do it matrix-wise

% data out is the Z stat, r effect size, clusters where p < 0.05

%% Mann Whitney U Test (ranksum)

NP=grpsize1*grpsize2; 
N=grpsize1+grpsize2; 
% N1=N+1; 
% k=min([grpsize1 grpsize2]);

X = cat(1, Grp1, Grp2);

[r,adj]=tiedrank(X); %compute the ranks and the ties
R1=r(1:grpsize1,:,:); %R2=r(grpsize1+1:end); 
T1=sum(R1); %T2=sum(R2);
U1=NP+(grpsize1*(grpsize1+1))/2-T1; %U2=NP-U1;

% corrected sd based on rank ties
sU=realsqrt((NP/(N^2-N)).*((N^3-N-2*adj)/12));

% extra things
% W=[T1 T2];
% mr=[T1/n1 T2/n2];
% U=[U1 U2];

% round(exp(gammaln(N1)-gammaln(k+1)-gammaln(N1-k))) > 20000 -> should be
% true to assume normal distribution and calculate the next steps

% method=Normal approximation:
mU=NP/2;
% Z results of mww test
obs_stat = (abs(U1-mU)-0.5)./sU;
obs_stat = squeeze(obs_stat);
p=1-normcdf(obs_stat); % one tailed; two tailed: p*2

% mark where significant
obs_clusters = zeros(size(obs_stat,1),size(obs_stat,2),size(obs_stat,3));
obs_clusters(obs_stat>0) = 1; % directional
obs_clusters(obs_stat<0) = -1;
obs_clusters(p>0.05)     = 0; % not significant

% effect size of mwwtest is r = abs(z/sqrt(n1+n2)) / 0.1 is small, 0.3 is
% medium, 0.5 is large
effectsize = abs(obs_stat/sqrt(grpsize1+grpsize2));
effectsize(effectsize<0.1  & effectsize>-0.1) = 0; % negligeable
effectsize(effectsize>0.1  & effectsize<0.3)  = 0.2; % small
effectsize(effectsize<-0.1 & effectsize>-0.3) = 0.2; % small
effectsize(effectsize>0.3  & effectsize<0.5)  = 0.4; % medium
effectsize(effectsize<-0.3 & effectsize>-0.5) = 0.4; % medium
effectsize(effectsize>0.5)                    = 0.6; % large
effectsize(effectsize<-0.5)                   = 0.6; % large

% method=Exact distribution;
% T=w;
% p=[p 2*p];
% no Z

end