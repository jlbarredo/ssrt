%% Batch script for first-level analysis of the SSRT task. 'getTC' and 'ssrt_patients' must be in your scripts 
%  folder or on your path.
addpath(genpath('/Volumes/Luria/CONTE_OCD/scripts'))
directory = ('/Volumes/Luria/CONTE_OCD');
%sessions = {'BL_MRI','Post-tx_MRI'};               % Folders where pre-tx and post-tx data are kept
sessions = {'BL_MRI'};
analysis = 'SSRT_040218';                           % Name of the analysis folder created for each subject
bpath = [directory,'/MSIT_SSRT-EPRIME/Controls'];   % Path to behavioral files
subjects = num2cell(dlmread('/Volumes/Luria/CONTE_OCD/scripts/subjects.txt'))';
%subjects = {'101'};

%% Task-specific modifiers
slices = 64;
refslice = 1;
TR = 1.0;
func = 'swussrt.nii';
highpass = 128;     % 2 times the longest task event cycle or default 128

for i=1:length(subjects)
    clear matlabbatch
    subject = num2str(subjects{i});
    
    subfile=[directory,'/',subject];
    cd(subfile);
    mkdir SSRT_040218;
    
    for j=1:length(sessions)
        cd(fullfile(subfile,sessions{j}));
        files = fullfile(directory,subject,sessions{j},['swussrt',num2str(j),'.nii']);  % Functional vols
        mask = fullfile(directory,subject,sessions{j},'c3art_mean_ssrt.nii');           % CSF mask
        
        [csf] = getTC(files,mask);                                                      % Extracts CSF tc - make sure function is on path
        save(['csf',num2str(j),'.mat'],'csf');
    end
     
    cd([directory,'/scripts']);
    ssrt_patients;                                                                      % Analysis script
    
    spm_jobman('initcfg')
    spm('defaults', 'FMRI');
    spm_jobman('run', matlabbatch);
end



