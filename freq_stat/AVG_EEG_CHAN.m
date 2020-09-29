close all;
clear all;
clc;

ft_defaults
load XXXXXXXXXX
pac = fieldnames(Normalized_freqERF_A);
band = fieldnames(Normalized_freqERF_A.pac2);

for i = 1:length(pac) 

    
    
   for j = 1:length(band) 
       

cfg = [];
cfg.channel          = 'all';
cfg.latency          = 'all';
cfg.avgoverchan      = 'yes'; 
cfg.frequency        = 'all';
cfg.parameter        = 'powspctrm';
cfg.tail             = 0;
cfg.method           = 'montecarlo';
cfg.statistic        = 'indepsamplesT';
cfg.numrandomization = 500;

    design = zeros(1,size(Normalized_freqERF_T.(pac{i}).(band{j}).powspctrm,1) + size(Normalized_freqERF_A.(pac{i}).(band{j}).powspctrm,1));
    design(1,1:size(Normalized_freqERF_T.(pac{i}).(band{j}).powspctrm,1)) = 1;
    design(1,(size(Normalized_freqERF_T.(pac{i}).(band{j}).powspctrm,1)+1):(size(Normalized_freqERF_T.(pac{i}).(band{j}).powspctrm,1)+...
    size(Normalized_freqERF_A.(pac{i}).(band{j}).powspctrm,1))) = 2;
 
    cfg.design           = design;


    stat.(pac{i}).(band{j}) = ft_freqstatistics(cfg, Normalized_freqERF_T.(pac{i}).(band{j}), Normalized_freqERF_A.(pac{i}).(band{j}));
      
   end

end

save Statistic stat
