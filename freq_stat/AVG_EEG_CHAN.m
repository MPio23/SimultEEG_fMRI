close all;
clear all;
clc;

ft_defaults
load C:\Users\piorecky\Desktop\DP\results\freqAbsolutSpctrm
pac = fieldnames(Normalized_freqERF_A); %pacienti maji vsechny znacky, je jedno, co vybereme na delku
band = fieldnames(Normalized_freqERF_A.pac2);

for i = 1:length(pac) %pres vsechny pacienty

    
    
   for j = 1:length(band) %pro vsechna pasma
       

cfg = [];
cfg.channel          = 'all';%{'E1','E2','E3'};
cfg.latency          = 'all';
cfg.avgoverchan      = 'yes'; %prumer pres kanaly
cfg.frequency        = 'all';
cfg.parameter        = 'powspctrm';
cfg.tail             = 0; %oboustranny test (neptam se vetsi mensi)
cfg.method           = 'montecarlo';
cfg.statistic        = 'indepsamplesT' ;%'ft_statfun_depsamplesT';
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