%% Reads in a text file list of subject numbers and makes onset text files 
%  for later fMRI or behavioral analyses. This script and the function that
%  loads and sorts the onset need to be in the script folder.

studyfolder = '/Volumes/Luria/CONTE_OCD';
scriptfolder = '/Volumes/Luria/CONTE_OCD/scripts';
subjectlist = '/Volumes/Luria/CONTE_OCD/scripts/subjects.txt';
subjects = num2cell(dlmread(subjectlist))';

for i = 1:length(subjects)
    subject = num2str(subjects{i})
    for run = 1:2
        if run==1
            outfolder = fullfile(studyfolder,subject,'BL_MRI');
            filename = fullfile(studyfolder,'SSRT-behavior',[subject,'_BL_1.xlsx']);
            load_ssrt_xlsx(filename,outfolder,run)
        elseif run==2 
            outfolder = fullfile(studyfolder,subject,'BL_MRI');
            filename = fullfile(studyfolder,'SSRT-behavior',[subject,'_BL_2.xlsx']);
            load_ssrt_xlsx(filename,outfolder,run)
        end
        
    end
end
