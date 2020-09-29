% Marek Piorecky
% 10. 5. 2020
% Artifacet rejection if it is required
% requires FieldTrip

close all;
clear all;
clc;

ft_defaults
addpath('fieldtrip plugin');
%% Select files

FilePath    =('XXXXXXXX\'); 
FileName    = dir([FilePath '*DOWN*.mat']);
nFiles      = length(FileName);


for i = 1:nFiles
%% load the data from matlab file

data        = load([FilePath FileName(i).name]);
data_raw    = data.data_raw;

%% Raw data inspection

cfg                 = [];
cfg.preproc.demean  = 'yes';
cfg.preproc.detrend = 'yes';
cfg.blocksize       = 10;
cfg.ylim            = [-500 500];
cfg.channel         = {'XX'};

artf = ft_databrowser(cfg, data_raw); %artf.artfctdef.visual.artifact = [begartf endartf]


%% segments removal

cfg                           = [];
cfg                           = artf;
cfg.artfctdef.reject          = 'partial';
cfg.artfctdef.minaccepttim    = 2;

dataReject = ft_rejectartifact(cfg, data_raw);


%%
save(['XXXXXXXXX\' FileName(i).name(1:end-4) 'ARTF.mat'], 'dataReject','artf', '-v7.3');

end