%-----------------------------------------------------------------------
% First-level model for the SSRT task
% spm SPM - SPM12 (6470)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
%% Nuisance regressor weights
drift = 0;
CSF = 0;
numsess = 0;
motion = [0 0 0 0 0 0];

%%
matlabbatch{1}.spm.stats.fmri_spec.dir = {fullfile(subfile,analysis)};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = slices;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = refslice;

%% Load session 1 scans and csf regressor
V = spm_vol(fullfile(directory,subject,sessions{1},func));
numScans=length(V);
for k=1:numScans
matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans {k,1} = [directory,'/',subject,'/',sessions{1},'/',func,',',num2str(k)];
end
load(fullfile(directory,subject,sessions{1},'csf1.mat'));


%% Load session timing files (in order of session appearance)
tmp = dlmread(fullfile(bpath,subject,sessions{1},['goOnset',num2str(j),'.txt']));
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).name = 'Go';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).onset = tmp(:,1);
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).duration = tmp(:,3);
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).orth = 1;

tmp = dlmread(fullfile(bpath,subject,sessions{1},['StopInh',num2str(j),'.txt']));
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).name = 'StopInh';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).onset = tmp(:,1);
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).duration = tmp(:,3);
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).orth = 1;

tmp = dlmread(fullfile(bpath,subject,sessions{1},['StopResp',num2str(j),'.txt']));
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).name = 'StopResp';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).onset = tmp(:,1);
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).duration = tmp(:,3);
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).orth = 1;

fileID = fopen(fullfile(bpath,subject,sessions{1},['goError',num2str(j),'.txt'],'r'));
tmp = textscan(fileID,'%f %f %f');
fclose(fileID);
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).name = 'goError';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).onset = tmp{1,1}(:,1);
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).duration = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {'Drift','CSF'}, 'val', {linspace(-1,1,numScans),csf});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {fullfile(directory,subject,sessions{1},rpfile)};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = highpass;  % 2 times the longest task event cycle 


%% Clear empty coditions and make error regressors - start at end!
if isempty(matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(4).onset)
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(4)=[];
end

% Check for errors
x = length(matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond)-4;
if x>0
    err1=0;
else
    err1=[];
end


%%
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {'/Applications/spm12/canonical/mask.nii,1'};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
matlabbatch{2}.spm.stats.fmri_est.spmmat = {fullfile(directory,subject,analysis,'SPM.mat')};
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;


%%
matlabbatch{3}.spm.stats.con.spmmat = {fullfile(directory,subject,analysis,'SPM.mat')};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'PRE All';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1/3,1/3,1/3,err1,drift,CSF,motion,numsess];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'PRE Go';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [1,0,0,err1,drift,CSF,motion,numsess];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'PRE StopInh';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0,1,0,err1,drift,CSF,motion,numsess];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'PRE StopResp';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [0,0,1,err1,drift,CSF,motion,numsess];
matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'PRE StopInh-Go';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [-1,1,0,err1,drift,CSF,motion,numsess];
matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'PRE StopInh-StopResp';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.weights = [0,1,-1,err1,drift,CSF,motion,numsess];
matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

