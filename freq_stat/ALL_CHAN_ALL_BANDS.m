close all;
clear all;
clc;

ft_defaults
load XXXXXXXXXXXXXXXXXX
pac = fieldnames(Normalized_freqERF_A); 
band = fieldnames(Normalized_freqERF_A.pac2);


cfg.elec = ft_read_sens('GSN-HydroCel-257.sfp');
cfg.layout = ft_prepare_layout(cfg);
cfg.channel = Normalized_freqERF_T.pac2.delta.label;
cfg.method = 'distance';
cfg.neighbourdist = 3;
neighbours = ft_prepare_neighbours(cfg);
ft_neighbourplot(cfg);


for i = 1:length(pac) %all subjects

    
    
   for j = 1:length(band) %all bands
       

    cfg = [];
    cfg.channel          = 'all';
    cfg.neighbours       = neighbours; 
    cfg.latency          = 'all';
    cfg.avgoverchan      = 'no'; 
    cfg.frequency        = 'all';
    cfg.parameter        = 'powspctrm';
    cfg.tail             = 0; 
    cfg.method           = 'montecarlo';
    cfg.correctm         = 'cluster';
    cfg.correcttail      = 'prob';
    cfg.statistic        = 'ft_statfun_indepsamplesT'; 
    cfg.numrandomization = 500;

    %nadefinovani, co je A a T
    design = zeros(1,size(Normalized_freqERF_T.(pac{i}).(band{j}).powspctrm,1) + size(Normalized_freqERF_A.(pac{i}).(band{j}).powspctrm,1));
    design(1,1:size(Normalized_freqERF_T.(pac{i}).(band{j}).powspctrm,1)) = 1;
    design(1,(size(Normalized_freqERF_T.(pac{i}).(band{j}).powspctrm,1)+1):(size(Normalized_freqERF_T.(pac{i}).(band{j}).powspctrm,1)+...
    size(Normalized_freqERF_A.(pac{i}).(band{j}).powspctrm,1))) = 2;
 
    cfg.design           = design;


    stat.(pac{i}).(band{j}) = ft_freqstatistics(cfg, Normalized_freqERF_T.(pac{i}).(band{j}), Normalized_freqERF_A.(pac{i}).(band{j}));
      
   end

end

save Statistic stat

%%
for i = 1:length(pac)

    
    try
   for j = 1:length(band) 
       
       data = stat.(pac{i}).(band{j});
       
        cfg = [];
        cfg.highlightsymbolseries = ['*','*','.','.','.'];
        cfg.elec = ft_read_sens('GSN-HydroCel-257.sfp');
        cfg.layout = ft_prepare_layout(cfg);
        cfg.contournum = 0;
        cfg.markersymbol = '.';
        cfg.alpha = 0.05;
        cfg.parameter='stat';
        ft_clusterplot(cfg,data);
       

   end
    catch
    end
end
