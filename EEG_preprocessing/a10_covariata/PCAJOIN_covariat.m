% Marek Piorecky
% 10. 5. 2020
% covarita for GLM from mean PSD
% requires SPM12

%%
close all;
clear;
clc;

%data
FilePath = 'XXXXXXXXX\';
FileName = dir([FilePath '*.mat']);
nFiles = length(FileName);

addpath('to spm12\')

RT = 1;
HRF = spm_hrf(RT);

data.delta = [];
data.theta = [];
data.alfa = [];
data.beta = [];

for i= 1:nFiles

load([FilePath FileName(i).name])
    
    % DELTA
    
    if isempty(isnan(R.delta)) == 0
        R.delta(isnan(R.delta)) = 0;
    end

    help = [];
    for j = 1:256
       help = conv(R.delta(:,j),HRF);
       RR.delta(:,j) = help(1:end-32);
    end
    
    mean256 = mean(RR.delta(:,1:256),2);
    demean256 = bsxfun(@minus,RR.delta,mean256);
    data.delta = [data.delta; demean256];
    delka(i).delta = size(RR.delta(:,1:256),1);
    demean256 = [];
    
    % TEHTA
      
    if isempty(isnan(R.theta)) == 0
        R.theta(isnan(R.theta)) = 0;
    end
    
    help = [];
    for j = 1:256
       help = conv(R.theta(:,j),HRF);
       RR.theta(:,j) = help(1:end-32);
    end
    
    mean256 = mean(RR.theta(:,1:256),2);
    demean256 = bsxfun(@minus,RR.theta,mean256);
    data.theta = [data.theta; demean256];
    delka(i).theta = size(RR.theta(:,1:256),1);
    demean256 = [];
    
    
    % ALFA
    
    if isempty(isnan(R.alfa)) == 0
        R.alfa(isnan(R.alfa)) = 0;
    end

    help = [];
    for j = 1:256
       help = conv(R.alfa(:,j),HRF);
       RR.alfa(:,j) = help(1:end-32);
    end
    
    mean256 = mean(RR.alfa(:,1:256),2);
    demean256 = bsxfun(@minus,RR.alfa,mean256);
    data.alfa = [data.alfa; demean256];
    delka(i).alfa = size(RR.theta(:,1:256),1);
    demean256 = [];
    
    
    % BETA
    
    if isempty(isnan(R.beta)) == 0
        R.beta(isnan(R.delta)) = 0;
    end

    help = [];
    for j = 1:256
       help = conv(R.beta(:,j),HRF);
       RR.beta(:,j) = help(1:end-32);
    end
    
    mean256 = mean(RR.beta(:,1:256),2);
    demean256 = bsxfun(@minus,RR.beta,mean256);
    data.beta = [data.beta; demean256];
    delka(i).beta = size(RR.beta(:,1:256),1);
    demean256 = [];

    clear RR
end


%group PCA
[coeffD,scoreD,latentX,tsquaredX,explainedD,muX]= pca(data.delta); 
[coeffT,scoreT,latentX,tsquaredX,explainedT,muX]= pca(data.theta); 
[coeffA,scoreA,latentX,tsquaredX,explainedA,muX]= pca(data.alfa); 
[coeffB,scoreB,latentX,tsquaredX,explainedB,muX]= pca(data.beta); 

dobaTrv = [delka.delta];
leng = dobaTrv(dobaTrv~=0);
leng = [1 leng];

%% Save each PCA parth
a=1;
for i= 1:nFiles %7

 % delta
doba = dobaTrv(i);
score.delta = scoreD(a:(a+doba-1),:);

 % theta

score.theta = scoreT(a:(a+doba-1),:);

 % alfa

score.alfa = scoreA(a:(a+doba-1),:);

 % beta

score.beta = scoreB(a:(a+doba-1),:);


save(['XXXXXXXXXXX' 'jPCAzscore' FileName(i).name], 'score')

a = a+doba;

score.delta = [];
score.beta = [];
score.theta =[];
score.alfa = [];


end

