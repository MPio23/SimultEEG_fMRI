% Marek Piorecky
% 10. 5. 2020
% NaN clear
% requires -


close all;
clear all;
clc;

% Select GA free data
MrrPath=('XXXXXXXXX\');
MrrName=dir([MrrPath '*aOBS*.mat']); %Gradient artifact free data


for i = 1:length(MrrName)

    load([MrrPath MrrName(i).name]);
    A = find(isnan(data_raw.trial{1,1}));

    if isempty(A)==0 

        save(['XXXXXXXXX\' MrrName(i).name(1:end-10) '_NaN.mat'],'A','-v7.3');

    end

end
