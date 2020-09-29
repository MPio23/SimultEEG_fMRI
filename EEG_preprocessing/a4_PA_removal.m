% Marek Piorecky
% 10. 5. 2020
% Cardiobalistic artifact suppresion
% requires FieldTrip, aOBS algorithm from Marco Marino
% (DOI: 10.1038/s41595-018-27187-6)

close all;
clear all;
clc;
ft_defaults

addpath('./aOBS');

% Select GA free data
MrrPath=('XXXXXXXX\');
MrrName=dir([MrrPath '*DOWN.mat']); %Gradient artifact free data

InspPath=('XXXXXXXX\');
InspName=dir([InspPath '*ARTF*.mat']);   %Raw Inspection data
%% aOBS

for i = 1:length(MrrName)
    load([MrrPath MrrName(i).name]);
    load([InspPath InspName(i).name],'artf');

    % aOBS
    eeg_data_aOBS = AOBSmethod(data_raw,artf);

    % Data back to the fieldtrip
    data_raw.trial{1}(1:256,:) = eeg_data_aOBS;
    clear eeg_data_aOBS
    save(['D:\Vlasta\SPANEK_MRI\PA_clear\' MrrName(i).name(1:end-4) '_aOBS.mat'],'data_raw','artf','-v7.3');
end

    