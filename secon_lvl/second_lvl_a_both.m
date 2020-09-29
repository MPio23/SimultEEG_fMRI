

clear ; clc
addpath('to spm12\')
clear classes
spm('defaults', 'fmri')
spm_jobman('initcfg')

%patient a
scans_group1 = { ...
'XXXXXXXX/con_0001.nii'
'XXXXXXXX/con_0001.nii'
.
.
.
};

%control a
scans_group2 =   { ...
'XXXXXXXX/con_0001.nii'
'XXXXXXXX/con_0001.nii'
.
.
.
};

matlabbatch{1}.spm.stats.factorial_design.dir = cellstr('XXXXXXX');
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = scans_group1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = scans_group2;
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
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

