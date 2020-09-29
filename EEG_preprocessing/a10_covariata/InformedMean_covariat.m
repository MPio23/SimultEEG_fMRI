% Marek Piorecky
% 10. 5. 2020
% covarita for GLM from infromed mean of PSD
% requires SPM12

close all;
clear;
clc;

%data
FilePath = 'XXXXXXXXX\';
FileName = dir([FilePath '*Norm*.mat']);
nFiles = length(FileName);

addpath('to spm12\')

RT = 1;
HRF = spm_hrf(RT);

for i= 1:nFiles


    load([FilePath FileName(i).name])
    allChan = {'E1'	'E2'	'E3'	'E4'	'E5'	'E6'	'E7'	'E8'	'E9'	'E10'	'E11'	'E12'	'E13'	'E14'	'E15'	'E16'	'E17'	'E18'	'E19'	'E20'	'E21'	'E22'	'E23'	'E24'	'E25'	'E26'	'E27'	'E28'	'E29'	'E30'	'E31'	'E32'	'E33'	'E34'	'E35'	'E36'	'E37'	'E38'	'E39'	'E40'	'E41'	'E42'	'E43'	'E44'	'E45'	'E46'	'E47'	'E48'	'E49'	'E50'	'E51'	'E52'	'E53'	'E54'	'E55'	'E56'	'E57'	'E58'	'E59'	'E60'	'E61'	'E62'	'E63'	'E64'	'E65'	'E66'	'E67'	'E68'	'E69'	'E70'	'E71'	'E72'	'E73'	'E74'	'E75'	'E76'	'E77'	'E78'	'E79'	'E80'	'E81'	'E82'	'E83'	'E84'	'E85'	'E86'	'E87'	'E88'	'E89'	'E90'	'E91'	'E92'	'E93'	'E94'	'E95'	'E96'	'E97'	'E98'	'E99'	'E100'	'E101'	'E102'	'E103'	'E104'	'E105'	'E106'	'E107'	'E108'	'E109'	'E110'	'E111'	'E112'	'E113'	'E114'	'E115'	'E116'	'E117'	'E118'	'E119'	'E120'	'E121'	'E122'	'E123'	'E124'	'E125'	'E126'	'E127'	'E128'	'E129'	'E130'	'E131'	'E132'	'E133'	'E134'	'E135'	'E136'	'E137'	'E138'	'E139'	'E140'	'E141'	'E142'	'E143'	'E144'	'E145'	'E146'	'E147'	'E148'	'E149'	'E150'	'E151'	'E152'	'E153'	'E154'	'E155'	'E156'	'E157'	'E158'	'E159'	'E160'	'E161'	'E162'	'E163'	'E164'	'E165'	'E166'	'E167'	'E168'	'E169'	'E170'	'E171'	'E172'	'E173'	'E174'	'E175'	'E176'	'E177'	'E178'	'E179'	'E180'	'E181'	'E182'	'E183'	'E184'	'E185'	'E186'	'E187'	'E188'	'E189'	'E190'	'E191'	'E192'	'E193'	'E194'	'E195'	'E196'	'E197'	'E198'	'E199'	'E200'	'E201'	'E202'	'E203'	'E204'	'E205'	'E206'	'E207'	'E208'	'E209'	'E210'	'E211'	'E212'	'E213'	'E214'	'E215'	'E216'	'E217'	'E218'	'E219'	'E220'	'E221'	'E222'	'E223'	'E224'	'E225'	'E226'	'E227'	'E228'	'E229'	'E230'	'E231'	'E232'	'E233'	'E234'	'E235'	'E236'	'E237'	'E238'	'E239'	'E240'	'E241'	'E242'	'E243'	'E244'	'E245'	'E246'	'E247'	'E248'	'E249'	'E250'	'E251'	'E252'	'E253'	'E254'	'E255'	'E256'	'ECG'};
   
    % DELTA
    
    if isempty(isnan(R.delta)) == 0
        R.delta(isnan(R.delta)) = 0;
    end
    
    
    help = [];
    for j = 1:256
       help = conv(R.delta(:,j),HRF);
       RR.delta(:,j) = help(1:end-32);
    end
    
    delta = {'E23'	'E31'	'E35'	'E36'	'E39'	'E40'	'E41'	'E44'	'E46'	'E47'	'E48'	'E49'	'E50'	'E52'	'E55'	'E56'	'E57'	'E58'	'E59'	'E62'	'E63'	'E65'	'E66'	'E69'	'E70'	'E71'	'E72'	'E74'	'E75'	'E76'	'E77'	'E83'	'E84'	'E85'	'E86'	'E87'	'E88'	'E93'	'E94'	'E95'	'E96'	'E97'	'E98'	'E99'	'E102'	'E103'	'E104'	'E105'	'E106'	'E107'	'E108'	'E109'	'E111'	'E112'	'E113'	'E114'	'E115'	'E116'	'E117'	'E119'	'E120'	'E123'	'E124'	'E125'	'E134'	'E135'	'E137'	'E146'};
    selectedChann = find(ismember(allChan,delta)==1);
    InformMean.delta = mean(RR.delta(:,selectedChann),2);
    selectedChann = [];
    
    % TEHTA
      
    if isempty(isnan(R.theta)) == 0
        R.theta(isnan(R.theta)) = 0;
    end
    
    help = [];
    for j = 1:256
       help = conv(R.theta(:,j),HRF);
       RR.theta(:,j) = help(1:end-32);
    end
    
    theta = {'E1'	'E2'	'E8'	'E9'	'E10'	'E14'	'E15'	'E18'	'E22'	'E31'	'E32'	'E33'	'E44'	'E45'	'E54'	'E60'	'E61'	'E66'	'E67'	'E73'	'E77'	'E78'	'E79'	'E80'	'E81'	'E82'	'E85'	'E86'	'E87'	'E88'	'E89'	'E91'	'E96'	'E97'	'E98'	'E99'	'E100'	'E101'	'E102'	'E105'	'E106'	'E107'	'E108'	'E109'	'E110'	'E112'	'E115'	'E116'	'E117'	'E118'	'E119'	'E120'	'E121'	'E122'	'E123'	'E124'	'E125'	'E126'	'E127'	'E128'	'E129'	'E130'	'E133'	'E134'	'E136'	'E137'	'E139'	'E145'	'E146'	'E147'	'E148'	'E149'	'E156'	'E157'	'E165'	'E166'	'E167'	'E168'	'E169'	'E174'	'E175'	'E176'	'E178'	'E187'	'E189'	'E193'	'E199'	'E200'	'E210'	'E211'	'E218'	'E219'	'E220'	'E222'	'E225'	'E227'	'E230'	'E241'	'E242'	'E243'	'E244'	'E245'	'E246'	'E248'	'E249'	'E250'	'E251'	'E252'	'E253'	'E255'	'E256'};
    selectedChann = find(ismember(allChan,theta)==1);
    InformMean.theta = mean(RR.theta(:,selectedChann),2);
    selectedChann = [];
    
    % ALFA
    
    if isempty(isnan(R.alfa)) == 0
        R.alfa(isnan(R.alfa)) = 0;
    end
    
    help = [];
    for j = 1:256
       help = conv(R.alfa(:,j),HRF);
       RR.alfa(:,j) = help(1:end-32);
    end
    
    alfa = {'E1' 'E2'	'E3'	'E5'	'E6'	'E7'	'E8'	'E10'	'E11'	'E13'	'E14'	'E15'	'E18'	'E19'	'E20'	'E22'	'E25'	'E26'	'E46'	'E47'	'E48'	'E54'	'E55'	'E58'	'E60'	'E61'	'E62'	'E63'	'E64'	'E65'	'E67'	'E68'	'E69'	'E70'	'E71'	'E72'	'E73'	'E74'	'E75'	'E76'	'E77'	'E78'	'E82'	'E83'	'E84'	'E85'	'E86'	'E87'	'E88'	'E89'	'E91'	'E92'	'E93'	'E94'	'E95'	'E96'	'E97'	'E98'	'E99'	'E100'	'E102'	'E103'	'E104'	'E105'	'E106'	'E107'	'E108'	'E109'	'E110'	'E111'	'E112'	'E113'	'E114'	'E115'	'E116'	'E117'	'E118'	'E119'	'E120'	'E121'	'E122'	'E123'	'E124'	'E125'	'E133'	'E134'	'E135'	'E136'	'E137'	'E145'	'E146'	'E147'	'E148'	'E149'	'E150'	'E151'	'E152'	'E156'	'E157'	'E158'	'E159'	'E160'	'E161'	'E162'	'E165'	'E166'	'E167'	'E168'	'E169'	'E170'	'E171'	'E172'	'E174'	'E175'	'E176'	'E177'	'E178'	'E179'	'E180'	'E187'	'E188'	'E189'	'E190'	'E191'	'E192'	'E193'	'E198'	'E199'	'E200'	'E201'	'E202'	'E203'	'E207'	'E208'	'E209'	'E210'	'E211'	'E212'	'E213'	'E216'	'E217'	'E218'	'E219'	'E220'	'E221'	'E222'	'E223'	'E225'	'E226'	'E227'	'E228'	'E229'	'E230'	'E231'	'E232'	'E233'	'E234'	'E235'	'E236'	'E237'	'E238'	'E239'	'E240'	'E241'	'E242'	'E243'	'E244'	'E245'	'E246'	'E247'	'E248'	'E249'	'E250'	'E251'	'E252'	'E253'	'E254'	'E255'	'E256'};
    selectedChann = find(ismember(allChan,alfa)==1);
    InformMean.alfa = mean(RR.alfa(:,selectedChann),2);
    selectedChann = [];

    % BETA
    
    if isempty(isnan(R.beta)) == 0
        R.beta(isnan(R.delta)) = 0;
    end

    
    help = [];
    for j = 1:256
       help = conv(R.beta(:,j),HRF);
       RR.beta(:,j) = help(1:end-32);
    end
    
    beta = {'E1'	'E2'	'E3'	'E6'	'E8'	'E9'	'E10'	'E14'	'E15'	'E31'	'E32'	'E33'	'E34'	'E35'	'E36'	'E37'	'E38'	'E39'	'E41'	'E45'	'E46'	'E48'	'E49'	'E50'	'E54'	'E55'	'E58'	'E59'	'E60'	'E61'	'E64'	'E65'	'E66'	'E67'	'E68'	'E69'	'E70'	'E71'	'E72'	'E73'	'E74'	'E75'	'E76'	'E77'	'E79'	'E80'	'E81'	'E82'	'E83'	'E84'	'E85'	'E86'	'E87'	'E88'	'E89'	'E91'	'E92'	'E93'	'E94'	'E95'	'E96'	'E97'	'E98'	'E99'	'E100'	'E101'	'E102'	'E103'	'E104'	'E105'	'E106'	'E107'	'E108'	'E109'	'E110'	'E111'	'E112'	'E113'	'E114'	'E115'	'E116'	'E117'	'E118'	'E119'	'E120'	'E121'	'E122'	'E123'	'E124'	'E125'	'E126'	'E127'	'E128'	'E129'	'E130'	'E133'	'E134'	'E135'	'E136'	'E137'	'E138'	'E139'	'E140'	'E141'	'E142'	'E143'	'E145'	'E146'	'E147'	'E148'	'E149'	'E150'	'E151'	'E152'	'E153'	'E154'	'E155'	'E156'	'E157'	'E158'	'E159'	'E160'	'E161'	'E162'	'E163'	'E164'	'E165'	'E166'	'E167'	'E168'	'E169'	'E170'	'E171'	'E172'	'E173'	'E174'	'E175'	'E176'	'E177'	'E178'	'E179'	'E180'	'E181'	'E182'	'E183'	'E187'	'E188'	'E189'	'E190'	'E191'	'E192'	'E193'	'E194'	'E195'	'E199'	'E200'	'E201'	'E202'	'E203'	'E204'	'E205'	'E208'	'E209'	'E210'	'E211'	'E212'	'E213'	'E216'	'E218'	'E219'	'E220'	'E221'	'E222'	'E225'	'E226'	'E227'	'E228'	'E229'	'E230'	'E231'	'E232'	'E233'	'E234'	'E235'	'E236'	'E237'	'E238'	'E239'	'E240'	'E241'	'E242'	'E243'	'E244'	'E245'	'E246'	'E247'	'E248'	'E249'	'E250'	'E251'	'E252'	'E253'	'E254'	'E255'	'E256'};
    selectedChann = find(ismember(allChan,beta)==1);
    InformMean.beta = mean(RR.beta(:,selectedChann),2);
    selectedChann = [];



save(['XXXXXXXXXXXX\' FileName(i).name 'InformMean.mat'],'InformMean')

clear RR

end