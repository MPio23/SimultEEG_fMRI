close all;
clear all;
clc;

ft_defaults
load D:\Marek_P\256EEG_dp\results\freqAbsolutSpctrm
pac = fieldnames(Normalized_freqERF_A); %pacienti maji vsechny znacky, je jedno, co vybereme na delku
band = fieldnames(Normalized_freqERF_A.pac2);


cfg.elec = ft_read_sens('GSN-HydroCel-257.sfp');
cfg.layout = ft_prepare_layout(cfg);
cfg.channel = Normalized_freqERF_T.pac2.delta.label;
cfg.method = 'distance';
cfg.neighbourdist = 3;
neighbours = ft_prepare_neighbours(cfg);
ft_neighbourplot(cfg);


for i = 1:length(pac) %pres vsechny pacienty

    
    
   for j = 1:length(band) %pro vsechna pasma
       

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
for i = 1:length(pac) %pres vsechny pacienty

    
    try
   for j = 1:length(band) %pro vsechna pasma
       
       data = stat.(pac{i}).(band{j});
       
        cfg = [];
        cfg.highlightsymbolseries = ['*','*','.','.','.'];
        %cfg.highlightchannel = find(data.negclusterslabelmat | data.posclusterslabelmat);
        cfg.elec = ft_read_sens('GSN-HydroCel-257.sfp');
        cfg.layout = ft_prepare_layout(cfg);
        cfg.contournum = 0;
        cfg.markersymbol = '.';
        cfg.alpha = 0.05;
        cfg.parameter='stat';
        % cfg.zlim = [-5 5];
        ft_clusterplot(cfg,data);
       

   end
    catch
    end
end
