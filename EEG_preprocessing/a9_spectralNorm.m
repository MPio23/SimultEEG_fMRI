% Marek Piorecky
% 10. 5. 2020
% normalizated spectral power
% requires FieldTrip

close all;
clear all;
clc;
ft_defaults

FilePath =('XXXXXXXX\');
FileName = dir([FilePath '*.mat']);
nFiles = length(FileName);

load('shifted mat');

names = fieldnames(TR1.sample);


for i = 2:length(names)
 
  posName = ~cellfun('isempty',strfind({FileName.name},(names{i})));
    
  if sum(posName) == 1
      
    load([FilePath FileName(find(posName == 1)).name]);  
    
    pos_sample      = TR1.sample.(names{i}); 
    data.label      = data_filt.label;
    data.fsample    = data_filt.fsample;
    data.trial      = {data_filt.trial{1,1}(:,pos_sample:end)};
    data.time       = {data_filt.time{1,1}(:,pos_sample:end)};
     
    cfg         = [];
    cfg.length  = 1;
    
    data1sec = ft_redefinetrial(cfg,data);
    
    
    cfg = [];             
    cfg.trials       = 'all';     
    cfg.output       = 'pow';
    cfg.method       = 'mtmfft';
    cfg.taper        = 'dpss';
    cfg.keeptrials   = 'yes';
    
    % DELTA
    cfg.foi          = 2;
    cfg.tapsmofrq    = 2;
    freqdelta.(names{i}) = ft_freqanalysis(cfg,data1sec);
    
    % THETA
    cfg.foi          = 6;
    cfg.tapsmofrq    = 2;
    freqtheta.(names{i}) = ft_freqanalysis(cfg,data1sec);
    
    % ALFA
    cfg.foi          = 10.5;
    cfg.tapsmofrq    = 2.5;
    freqalfa.(names{i}) = ft_freqanalysis(cfg,data1sec);
    
    % BETA
    cfg.foi          = 16.5;
    cfg.tapsmofrq    = 3.5;
    freqbeta.(names{i}) = ft_freqanalysis(cfg,data1sec);
    
       
    suma = sum( freqdelta.(names{i}).powspctrm,1) ...
             + sum(freqtheta.(names{i}).powspctrm,1) ...
             + sum(freqalfa.(names{i}).powspctrm,1) ...
             + sum(freqbeta.(names{i}).powspctrm,1);

     
    GlobalPower.(names{i}) = suma;
    suma = [];
         
         R.delta = bsxfun(@rdivide,freqdelta.(names{i}).powspctrm,GlobalPower.(names{i}));
         R.theta = bsxfun(@rdivide,freqtheta.(names{i}).powspctrm,GlobalPower.(names{i}));
         R.alfa = bsxfun(@rdivide,freqalfa.(names{i}).powspctrm,GlobalPower.(names{i}));
         R.beta = bsxfun(@rdivide,freqbeta.(names{i}).powspctrm,GlobalPower.(names{i}));
         
    save(['XXXXXXXXXXXXXXXX\shiftFreq_' FileName(i).name(9:end-4) '.mat'], 'freqdelta', 'freqtheta', 'freqalfa', 'freqbeta', '-v7.3');    
    
    save(['XXXXXXXXXXXXXXXX\shiftNormFreq_' FileName(i).name(9:end-4) '.mat'], 'R', '-v7.3'); 
    
    
  end
  
end
