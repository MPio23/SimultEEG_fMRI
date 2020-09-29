% Marek Piorecky
% 10. 5. 2020
% filtration
% requires FieldTrip


close all;
clear all;
clc;
ft_defaults

FilePath=('XXXXXXXXXXXXXX\');
FileName = dir([FilePath '*aOBS*.mat']);
nFiles = length(FileName);

%% all subjects

for i = 1:nFiles
    

load([FilePath FileName(i).name]);

%% Z - stat and interpolation

k       = 1.5;         
ElStd   = std(data_raw.trial{1,1},[],2);
Q       = quantile(ElStd,[0.25 0.75]);
IQR     = Q(2) - Q(1);

ElInterp = find(ElStd > Q(2)+IQR*k);    %interpolation index

if ~isempty(ElInterp)
    
    cfg                 = [];
    cfg.elecfile        = 'GSN-HydroCel-257.sfp';
    cfg.channel         =  data_raw.label(1:256)';
    cfg.method          = 'distance';
    cfg.neighbourdist   = 2.8;
    
    neighbours = ft_prepare_neighbours(cfg);

    cfg             = [];
    cfg.method      = 'spline';
    cfg.neighbours  = neighbours;
    cfg.badchannel  = data_raw.label(ElInterp);
    cfg.elecfile    = 'GSN-HydroCel-257.sfp';
    
    data_interp = ft_channelrepair(cfg, data_raw);
    
    disp(['Channel for interp: ',int2str(ElInterp')]);
end


%% Filtration

if ~isempty(ElInterp)
    
 cfg    = [];
 cfg    = filtering('bp', [0.5 100]);
 
 data_filt = ft_preprocessing(cfg, data_interp);
 
else
    
 cfg    = [];
 cfg    = filtering('bp', [0.5 100]);
 %demean
 %detrend
 data_filt = ft_preprocessing(cfg, data_raw);
end


%% clear ref

if isempty(ElInterp)   
    
    for j=1:length(data_filt.trial)

    data2 = data_filt.trial{1,j};
    data_filt.trial{1,j} = data2(1:end-1,:);
    data2 = [];

    end

    data_filt.label(end) = [];
end


save(['XXXXXXXXXX\' FileName(i).name(1:end-4) '.mat'], 'data_filt', '-v7.3');


end