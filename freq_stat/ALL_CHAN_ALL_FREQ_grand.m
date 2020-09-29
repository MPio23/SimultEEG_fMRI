close all;
clear all;
clc;

ft_defaults
FilePathT=('D:\Marek_P\256EEG_dp\freq_analysis\');
FileNameT = dir([FilePathT '*Relfreq_T*.mat']);
nFilesT = length(FileNameT);

FileNameA = dir([FilePathT '*Relfreq_A*.mat']);
nFilesA = length(FileNameA);

load([FilePathT FileNameT(1).name]);

cfg.elec = ft_read_sens('GSN-HydroCel-257.sfp');
cfg.layout = ft_prepare_layout(cfg);
cfg.channel = freq_Talfa.pac2.label;
cfg.method = 'distance';
cfg.neighbourdist = 10;
neighbours = ft_prepare_neighbours(cfg);
ft_neighbourplot(cfg);

for i = 1:1%nFilesT
    
    data = load([FilePathT FileNameT(i).name]);
    name = FileNameT(i).name(4:end-4);
    datpre = struct2cell(data.([name]));
    cfg = [];
    GA_freq_T = ft_freqgrandaverage(cfg, datpre{:});
 
    data = load([FilePathT FileNameA(i).name]);
    name = FileNameA(i).name(4:end-4);
    datpre = struct2cell(data.([name]));
    GA_freq_A = ft_freqgrandaverage(cfg, datpre{:});
    
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
    cfg.ivar = 2;

    %nadefinovani, co je A a T
    design = zeros(2,2);
    design(1,:) = 1;
    design(2,:) = [1,2];
    cfg.design           = design;
    cgf.design = [1 2];
    statfreq = ft_freqstatistics(cfg, GA_freq_T, GA_freq_A);
      

end

%%
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
