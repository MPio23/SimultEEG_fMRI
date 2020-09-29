% Marek Piorecky
% 10. 5. 2020
% covarita for GLM from mean PSD
% requires -

close all;
clear;
clc;

%data
FilePath = 'XXXXXXX\';
FileName = dir([FilePath '*Norm*.mat']);
nFiles = length(FileName);



RT = 1;
HRF = spm_hrf(RT);

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
    
    mean256.delta = mean(RR.delta(:,1:256),2);
    
    % TEHTA
      
    if isempty(isnan(R.theta)) == 0
        R.theta(isnan(R.theta)) = 0;
    end

    help = [];
    for j = 1:256
       help = conv(R.theta(:,j),HRF);
       RR.theta(:,j) = help(1:end-32);
    end
    
    mean256.theta = mean(RR.theta(:,1:256),2);
    
    % ALFA
    
    if isempty(isnan(R.alfa)) == 0
        R.alfa(isnan(R.alfa)) = 0;
    end
    
    help = [];
    for j = 1:256
       help = conv(R.alfa(:,j),HRF);
       RR.alfa(:,j) = help(1:end-32);
    end
    
    mean256.alfa = mean(RR.alfa(:,1:256),2);

    % BETA
    
    if isempty(isnan(R.beta)) == 0
        R.beta(isnan(R.delta)) = 0;
    end

    help = [];
    for j = 1:256
       help = conv(R.beta(:,j),HRF);
       RR.beta(:,j) = help(1:end-32);
    end
    
    mean256.beta = mean(RR.beta(:,1:256),2);
    
save(['XXXXXXXX\' FileName(i).name 'mean256.mat'],'mean256')

clear RR
end