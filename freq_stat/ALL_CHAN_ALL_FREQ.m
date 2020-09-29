close all;
clear all;
clc;

ft_defaults
load D:\Marek_P\256EEG_dp\results\freqRelatSpctrm1Hz
pac = fieldnames(Normalized_freqERF_A); %pacienti maji vsechny znacky, je jedno, co vybereme na delku

cfg.elec = ft_read_sens('GSN-HydroCel-257.sfp');
cfg.layout = ft_prepare_layout(cfg);
cfg.channel = Normalized_freqERF_T.pac2.freq.label;
cfg.method = 'distance';
cfg.neighbourdist = 3;
neighbours = ft_prepare_neighbours(cfg);
ft_neighbourplot(cfg);


for i = 1:length(pac) %pres vsechny pacienty

    
    
   %for j = 1:size(patientA.freq.powspctrm,1)        

    cfg = [];
    cfg.channel          = 'all';%{'E1','E2','E3'};
    cfg.neighbours       = neighbours; 
    cfg.latency          = 'all';
    cfg.avgoverchan      = 'no'; %prumer pres kanaly
    cfg.frequency        = 'all';
    cfg.parameter        = 'powspctrm';
    cfg.tail             = 0; %oboustranny test (neptam se vetsi mensi)
    cfg.method           = 'montecarlo';
    cfg.correctm         = 'cluster';
    cfg.correcttail      = 'prob';
    cfg.statistic        = 'ft_statfun_indepsamplesT'; 
    cfg.numrandomization = 1000;

    %nadefinovani, co je A a T
    design = zeros(1,size(Normalized_freqERF_T.(pac{i}).freq.powspctrm,1) + size(Normalized_freqERF_A.(pac{i}).freq.powspctrm,1));
    design(1,1:size(Normalized_freqERF_T.(pac{i}).freq.powspctrm,1)) = 1;
    design(1,(size(Normalized_freqERF_T.(pac{i}).freq.powspctrm,1)+1):(size(Normalized_freqERF_T.(pac{i}).freq.powspctrm,1)+...
    size(Normalized_freqERF_A.(pac{i}).freq.powspctrm,1))) = 2;
 
    cfg.design           = design;


    stat.(pac{i}).freq = ft_freqstatistics(cfg, Normalized_freqERF_T.(pac{i}).freq, Normalized_freqERF_A.(pac{i}).freq);
      
   %end

end

save Statistic stat

%%
cfg.elec = ft_read_sens('GSN-HydroCel-257.sfp');
cfg.layout = ft_prepare_layout(cfg);
% scatter3(cfg.layout.pos(:,1),cfg.layout.pos(:,2), ones(1,262))
% hold on

x = cfg.layout.pos(:,1);
y = cfg.layout.pos(:,2);
z = ones(1,262);

for i = 1:length(pac) %pres vsechny pacienty
     figure(i)
   for j = 1:size(stat.(pac{i}).freq.prob,2) %pro 17 dilku po 1 Hz
                 
        statDif1 = find(stat.(pac{i}).freq.prob(:,j)<0.5);
        scatter3(x(statDif1),y(statDif1),j*ones(1,size(statDif1,1)),[],'r','filled')
        hold on
        statDif = find(stat.(pac{i}).freq.prob(:,j)>=0.5);
        scatter3(x(statDif),y(statDif),j*ones(1,size(statDif,1)),[],'c','filled')

   end

end
