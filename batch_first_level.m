% List of open inputs
addpath(genpath('~/Documents/MATLAB/spm_utilities'))
directory = ('/Volumes/Luria/CONTE_OCD');
%sessions = {'BL_MRI','Post-tx_MRI'};       % For patients
sessions = {'BL_MRI'};
analysis = 'MSIT_BK_010918';
bpath = [directory,'/MSIT_SSRT-EPRIME/Controls'];  % Path to behavioral files
subjects = num2cell(dlmread('/Volumes/Luria/CONTE_OCD/scripts/con_msit_subjects.txt'))';
%subjects = {'101'};

%% Task-specific modifiers
slices = 64;
refslice = 1;
TR = 1.0;
func = 'swumsit.nii';
highpass = 128;     % 2 times the longest task event cycle or default 128

for i=1:length(subjects)
    clear matlabbatch
    subject = num2str(subjects{i});
    
    subfile=[directory,'/',subject];
    cd(subfile);
    mkdir MSIT_BK_010918;
    
    for j=1:length(sessions)
        cd(fullfile(subfile,sessions{j}));
        files = fullfile(directory,subject,sessions{j},'swumsit.nii');              % Functional vols
        mask = fullfile(directory,subject,sessions{j},'c3art_mean_umsit.nii');      % CSF mask
        
        [csf] = getTC(files,mask);                                                  % Extracts CSF tc - make sure function is on path
        save(['csf',num2str(j),'.mat'],'csf');
    end
     
    cd([directory,'/scripts']);
    msit_block_con;                                                                     % Analysis script
    
    spm_jobman('initcfg')
    spm('defaults', 'FMRI');
    spm_jobman('run', matlabbatch);
end



