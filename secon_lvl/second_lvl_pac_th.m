

clear ; clc
%addpath('/usr/local/spm12')
addpath('D:\Marek_P\spm12\spm12\')
clear classes
spm('defaults', 'fmri')
spm_jobman('initcfg')

scans_group1 = { ...
'Z:\simult_sleep_data_MRcorrect\patient\PARS_P02412_20180228_1203_1\first_lvl_func_20200701_173603/con_0001.nii'
'Z:\simult_sleep_data_MRcorrect\patient\PARS_P02413_20180321_1216_1\first_lvl_func_20200703_132839_th/con_0001.nii'
'Z:\simult_sleep_data_MRcorrect\patient\PARS_P02416_20171018_1217_1\first_lvl_func_20200703_142621_th/con_0001.nii'
'Z:\simult_sleep_data_MRcorrect\patient\PARS_P02419_20171128_1714_1\first_lvl_func_20200703_172017_th/con_0001.nii'
'Z:\simult_sleep_data_MRcorrect\patient\PARS_P02421_20180207_1206_1\first_lvl_func_20200703_203750_th/con_0001.nii'
'Z:\simult_sleep_data_MRcorrect\patient\PARS_P02431_20170815_1219_1\first_lvl_func_20200706_081646_th/con_0001.nii'
};

matlabbatch{1}.spm.stats.factorial_design.dir = cellstr('D:\Marek_P\disert\para\result\patient\th\');
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = scans_group1;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

spm('defaults', 'fmri')
spm_jobman('initcfg')
spm_jobman('run',matlabbatch)

