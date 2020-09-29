% Marek Piorecky
% 10. 5. 2020
% Downsampling from 1 kHz
% requires FieldTrip

close all;
clear all;
clc;
ft_defaults
%% load the data from matlab file

FilePath = 'XXXXXXX\';
FileName = dir([FilePath '*GA*.mat']);
nFiles   = length(FileName);

for i = 1:nFiles
    
cfg.channel     = 'all';
data            = load([FilePath FileName(i).name]);
data_raw        = data.dataRaw;


%% downsample

FsNew           = 250;
cfg             = [];
cfg.resamplefs  = FsNew;
cfg.detrend     = 'no';
data_raw = ft_resampledata(cfg, data_raw);    %for faster ICA


%%
save(['XXXXXXXX\' FileName(i).name(1:end-4) 'DOWN.mat'], 'data_raw', '-v7.3');

end