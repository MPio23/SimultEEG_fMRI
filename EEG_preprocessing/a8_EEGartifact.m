% Marek Piorecky
% 10. 5. 2020
% artifacts clear
% requires FieldTrip


close all;
clear all;
clc;

%% define dataset
ft_defaults

load('XXXXXXXXXXX') %shift mat

FilePath=('XXXXXXXXXXXX\'); %filtred data
FileName = dir([FilePath '*.mat']);
nFiles = length(FileName);


for i = 1:nFiles
   
    load([FilePath FileName(i).name])

%% define trials
cfg                         = [];
cfg.trialdef.triallength    = 1;

data = ft_redefinetrial(cfg, data_filt);

%% JUMP artifacts
    cfg             = [];
    cfg.trl         = [1 size(data_filt.trial{1},2) 0];
    cfg.continuous  = 'yes';
    
    cfg.artfctdef.zvalue.channel    = 'EEG';
    cfg.artfctdef.zvalue.cutoff     = 20;
    cfg.artfctdef.zvalue.trlpadding = 0;
    cfg.artfctdef.zvalue.artpadding = 0;
    cfg.artfctdef.zvalue.fltpadding = 0;
    
    % algorithmic parameters
    cfg.artfctdef.zvalue.cumulative     = 'yes';
    cfg.artfctdef.zvalue.medianfilter   = 'yes';
    cfg.artfctdef.zvalue.medianfiltord  = 9;
    cfg.artfctdef.zvalue.absdiff        = 'yes';

    % make the process interactive
    cfg.artfctdef.zvalue.interactive    = 'yes';

    jumpArt = ft_artifact_zvalue(cfg, data_filt);
    
    %% EMG artifacts
    cfg             = [];
    cfg.trl         = [1 size(data_filt.trial{1},2) 0];
    cfg.continuous  = 'yes';
    
    cfg.artfctdef.zvalue.channel      = 'EEG'; %vybrat to na celisti
    cfg.artfctdef.zvalue.cutoff       = 4;
    cfg.artfctdef.zvalue.trlpadding   = 0;
    cfg.artfctdef.zvalue.fltpadding   = 0;
    cfg.artfctdef.zvalue.artpadding   = 0.1;

    % algorithmic parameters
    cfg.artfctdef.zvalue.bpfilter     = 'yes';
    cfg.artfctdef.zvalue.bpfreq       = [20 30];
    cfg.artfctdef.zvalue.bpfiltord    = 9;
    cfg.artfctdef.zvalue.bpfilttype   = 'but';
    cfg.artfctdef.zvalue.hilbert      = 'yes';
    cfg.artfctdef.zvalue.boxcar       = 0.2;

    % make the process interactive
    cfg.artfctdef.zvalue.interactive = 'yes';

    EMGArt = ft_artifact_zvalue(cfg, data_filt);
    
    %% EOG
    cfg             = [];
    cfg.trl         = [1 size(data_filt.trial{1},2) 0];
    cfg.continuous  = 'yes';
    
    cfg.artfctdef.zvalue.channel     = {'E28', 'E29', 'E11', 'E12', 'E32'};
    cfg.artfctdef.zvalue.cutoff      = 4;
    cfg.artfctdef.zvalue.trlpadding  = 0;
    cfg.artfctdef.zvalue.artpadding  = 0.1;
    cfg.artfctdef.zvalue.fltpadding  = 0;

    % algorithmic parameters
    cfg.artfctdef.zvalue.bpfilter   = 'yes';
    cfg.artfctdef.zvalue.bpfilttype = 'but';
    cfg.artfctdef.zvalue.bpfreq     = [2 15];
    cfg.artfctdef.zvalue.bpfiltord  = 4;
    cfg.artfctdef.zvalue.hilbert    = 'yes';

    % feedback
    cfg.artfctdef.zvalue.interactive = 'yes';

    EOGArt = ft_artifact_zvalue(cfg, data_filt);
    
%%
cfg                             =[];
cfg.artfctdef.reject            = 'complete'; 
cfg.artfctdef.eog.artifact      = artifact_EOG; 
cfg.artfctdef.jump.artifact     = artifact_jump;
cfg.artfctdef.muscle.artifact   = artifact_muscle;

data_no_artifacts = ft_rejectartifact(cfg,data);
  
end

FilePathT =('XXXXXXXXXXXX');
FileNameT = dir([FilePathT '*Relfreq_T*.mat']);
nFilesT   = length(FileNameT);

FileNameA = dir([FilePathT '*Relfreq_A*.mat']);
nFilesA = length(FileNameA);
