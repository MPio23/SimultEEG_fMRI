% Marek Piorecky
% 10. 5. 2020
% convolution with hemodynamic response
% requires 

close all;
clear;
clc;

%data
FilePath = 'XXXXXXXXXXXX\';
FileName = dir([FilePath '*Norm*.mat']);
nFiles = length(FileName);

addpath('to smp12\')

RT = 1;
HRF = spm_hrf(RT);

for i= 1:nFiles

    load([FilePath FileName(i).name])
    
    % delta
    for j = 1:256
        
        B.help = conv(R.delta(:,j),HRF);
        RR.delta(:,j) = B.help(1:end-32);
        
    end
    
        % theta
    for j = 1:256
        
        B.help = conv(R.theta(:,j),HRF);
        RR.theta(:,j) = B.help(1:end-32);
        
    end
        % alfa
    for j = 1:256
        
        B.help = conv(R.alfa(:,j),HRF);
        RR.alfa(:,j) = B.help(1:end-32);
        
    end
        % beta
    for j = 1:256
        
        B.help = conv(R.beta(:,j),HRF);
        RR.beta(:,j) = B.help(1:end-32);
        
    end
    
    save(['XXXXXXXXXX\' 'Conv_' FileName(i).name],'RR')

    
end