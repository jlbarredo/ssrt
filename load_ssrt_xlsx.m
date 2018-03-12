function load_ssrt_xlsx(filename,outfolder,run)
% filename = '/Volumes/Luria/CONTE_OCD/scripts';
% outfolder = '/Volumes/Luria/CONTE_OCD/422/BL_MRI';

%% Import data from spreadsheet
% Script for importing data from SSRT Excel spreadsheet.

%% Import the data
[~, ~, BL1] = xlsread(filename,'Sheet1');
BL1(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),BL1)) = {''};


%% First event - trigger. E prime starts the experiment clock as soon as the 
% script is started. The adjOnset variable adjusts all reference times to
% account for the lag between script start and MRI trigger pulse.
trigRT = find(strcmp(BL1(1,:),'SayWaiting.RTTime'));
adjOnset = cell2mat(BL1(cellfun(@isnumeric,BL1(:,trigRT)),trigRT));


%% Make folder for output files if it does not exist 
% will hold onset text files and fmri data.
if ~exist(outfolder),mkdir(outfolder),end


%% Make trial event onset files
% Columns: onsets in seconds, accuracy, RT 

% Fixation - 1st event in trial sequence. If left commented, null events are 
% treated as an implicit baseline by SPM.
% f1 = find(strcmp(BL1(1,:),'Fix.OnsetTime'));
% fixOnset = cell2mat(BL1(cellfun(@isnumeric,BL1(:,f1)),f1))-adjOnset;

%% Go trials
go = find(strcmp(BL1(1,:),'Go.OnsetTime'));
goACC = find(strcmp(BL1(1,:),'Go.ACC'));
goRT = find(strcmp(BL1(1,:),'Go.RT'));
goOnset(:,1) = (cell2mat(BL1(cellfun(@isnumeric,BL1(:,go)),go))-adjOnset)./1000;
goOnset(:,2) = cell2mat(BL1(cellfun(@isnumeric,BL1(:,goACC)),goACC));
goOnset(:,3) = cell2mat(BL1(cellfun(@isnumeric,BL1(:,goRT)),goRT));
dlmwrite([outfolder,'/goOnset',num2str(run),'.txt'],goOnset(find(goOnset(:,2)==1),:),'delimiter','\t')
dlmwrite([outfolder,'/goError',num2str(run),'.txt'],goOnset(find(goOnset(:,2)==0),:),'delimiter','\t')


%% Stop trials, staircase 1 - unclear what the Go2S series models...
g1 = find(strcmp(BL1(1,:),'Go1s.OnsetTime'));
iACC = find(strcmp(BL1(1,:),'Inhs.ACC'));
iRT = find(strcmp(BL1(1,:),'Inhs.RT'));
g1Onset(:,1) = (cell2mat(BL1(cellfun(@isnumeric,BL1(:,g1)),g1))-adjOnset)./1000;
g1Onset(:,2) = cell2mat(BL1(cellfun(@isnumeric,BL1(:,iACC)),iACC));
g1Onset(:,3) = cell2mat(BL1(cellfun(@isnumeric,BL1(:,iRT)),iRT));

i1 = find(strcmp(BL1(1,:),'Inhs.OnsetTime'));
inhsOnset = cell2mat(BL1(cellfun(@isnumeric,BL1(:,i1)),i1))-adjOnset;
% g11 = find(strcmp(BL1(1,:),'Go2S.OnsetTime'));
% g2SOnset = cell2mat(BL1(cellfun(@isnumeric,BL1(:,g11)),g11))-adjOnset;


%% Stop trials, staircase 2 - unclear what the Go2S series models...
g2 = find(strcmp(BL1(1,:),'Go1s2.OnsetTime'));
i2ACC = find(strcmp(BL1(1,:),'Inhs2.ACC'));
i2RT = find(strcmp(BL1(1,:),'Inhs2.RT'));
g2Onset(:,1) = (cell2mat(BL1(cellfun(@isnumeric,BL1(:,g2)),g2))-adjOnset)./1000;
g2Onset(:,2) = cell2mat(BL1(cellfun(@isnumeric,BL1(:,i2ACC)),i2ACC));
g2Onset(:,3) = cell2mat(BL1(cellfun(@isnumeric,BL1(:,i2RT)),i2RT));

i2 = find(strcmp(BL1(1,:),'Inhs2.OnsetTime'));
inhsOnset = cell2mat(BL1(cellfun(@isnumeric,BL1(:,i2)),i2))-adjOnset;
% g22 = find(strcmp(BL1(1,:),'Go2s2.OnsetTime'));
% g2s2Onset = cell2mat(BL1(cellfun(@isnumeric,BL1(:,g22)),g22))-adjOnset;


%% Collapse the staircases and write onset files
sOnset = sortrows(vertcat(g1Onset,g2Onset));
dlmwrite([outfolder,'/StopInhibit',num2str(run),'.txt'],sOnset(find(sOnset(:,2)==1),:),'delimiter','\t')
dlmwrite([outfolder,'/StopResp',num2str(run),'.txt'],sOnset(find(sOnset(:,2)==0),:),'delimiter','\t')


%% For re-analysis, StopResp-GoTrim. Go distribution is trimmed to 
%  control for differences in response speed.


%% Parametric analysis w/SSD. Examine difference in stopping activation 
%  between trials where stopping initiated early vs. late. Mean-normalized
%  SSD for StopInhibit trials.


%% For SSRT
% Subtract avg. SSD from median no-signal RT
% Compute avg. SSD as the avg. of avg. SSD for each staircase.









