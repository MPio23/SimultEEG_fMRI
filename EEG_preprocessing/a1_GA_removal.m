% Marek Piorecky
% 10. 5. 2020
% Batch Gradient Artifact Removal 
% requires EEGLab, FMRIB plugin, FieldTrip, EGI MFF read

%% defaults

close all;
clear all;
clc;
ft_defaults
addpath('plugin fmrib');

% figure
% ft_plot_sens(dataRaw.hdr.elec, 'elecsize', 30);
% grid on
% rotate3d
%% Select files
FilePath    =('XXXXXXXXX\'); 
FileName    = dir([FilePath 'XXXXXXX.mff']);
nFiles      = length(FileName);
%mff_setup
%% main loop

for i = 1:nFiles 
 
% load .mff native files    
    cfg             = [];
    cfg.dataset     = [FilePath FileName(i).name];
    cfg.dataformat  = 'egi_mff_v3';
    cfg.headerformat = 'egi_mff_v3';
    cfg.channels    = {'all'};
   
    event = ft_read_event([FilePath FileName(i).name], 'headerformat', 'egi_mff_v3', 'dataformat', 'egi_mff_v3');

% Load events from .mff and create EEGlab structures
    Trigs = [];
    for j = 1:length(event)
        if strcmp('TREV',event(j).value)
            roundEve = round([ event(j).sample]);
            Trigs = [Trigs;roundEve];
        end
    end
    
    %% to Fieldtrip
    
    cfg             = [];
    cfg.channel     = {'all', '-E257'}; %'-VREF'};
    dataRawSel      = ft_selectdata(cfg,dataRaw);
    
    EEG.data    = dataRawSel.trial{1};
    EEG.srate   = dataRawSel.fsample;
    EEG.pnts    = length(dataRawSel.time{1});

    lpf     = 0; %no filter
    L       = 20; %times higher sample rate after interpolation
    Window  = 10;
    tc_chk  = 0; %correct triggers
    strig   = 0; %1 for slice triggers, 0 for volume / section triggers.
    anc_chk = 0; %Adaptive noise cancellation
    Volumes = length(Trigs);
    
    EEG = fmrib_fastr(EEG,lpf,L,Window,Trigs,strig,anc_chk,tc_chk,Volumes);

% Data back to the fieldtrip

    dataRawSel.trial{1} = single(EEG.data);
    dataRaw             = dataRawSel;

    save(['XXXXXX\' FileName(i).name(1:end-4) 'GA.mat'],'dataRaw','event','-v7.3')

    clear EEG dataRawSel
    clear dataRaw
end





