%% Reads in a text file list of subject numbers and makes onset text files 
%  for later fMRI or behavioral analyses. This script and the function that
%  loads and sorts the onset need to be in the script folder.

studyfolder = '/Users/jenniferbarredo/Desktop/CONTE_OCD';
scriptfolder = '/Users/jenniferbarredo/Desktop/CONTE_OCD/scripts';
subjectlist = '/Users/jenniferbarredo/Desktop/CONTE_OCD/scripts/subjects.txt';

addpath(genpath(scriptfolder));
subjects = num2cell(dlmread(subjectlist))';

%% Blockwise statistics and onsets
stats = zeros(length(subjects),8);

for i = 1:length(subjects)
    subject = num2str(subjects{i})
    for run = 1:2
        if run==1
            outfolder = fullfile(studyfolder,subject,'BL_MRI');
            filename = fullfile(studyfolder,'SSRT-behavior',[subject,'_BL_1.xlsx']);
            [stats(i,1),stats(i,2),stats(i,3),stats(i,4)] = load_ssrt_xlsx(filename,outfolder,run);
        elseif run==2 
            outfolder = fullfile(studyfolder,subject,'BL_MRI');
            filename = fullfile(studyfolder,'SSRT-behavior',[subject,'_BL_2.xlsx']);
            [stats(i,5),stats(i,6),stats(i,7),stats(i,8)] = load_ssrt_xlsx(filename,outfolder,run);
        end
        
    end
end

dlmwrite([studyfolder,'/groupstats.txt'],stats,'delimiter','\t')
