% Marek Piorecky
% 10. 5. 2020
% sample shift
% requires FieldTrip, EEGLab, fmrib Toolbox

close all;
clear all;
clc;

ft_defaults

addpath('toeeglab');
FilePath=('XXXXXXXXXXXX');
FileName = dir([FilePath '*.mff']);
nFiles = length(FileName);

for i = 1:nFiles
 
    
    event           = ft_read_event([FilePath FileName(i).name], 'headerformat', 'egi_mff_v2', 'dataformat', 'egi_mff_v2');
    SamplesTR       = strcmp({event.value},'TREV');
    event           = cell2mat({event.sample})';
    eventTRsamples  = event(SamplesTR);
    firstSampleTR   = eventTRsamples(1,1);
    firstTimeTR     = firstSampleTR./1000;
    firstSampleTR   = firstSampleTR./4;
    
    TR1.time.(FileName(i).name(1:end-4)) = firstTimeTR;
    TR1.sample.(FileName(i).name(1:end-4)) = firstSampleTR;
end