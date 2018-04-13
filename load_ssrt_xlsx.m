function [pGCOR,pGNR,mgoRT,pINR,SSRT]  = load_ssrt_xlsx(filename,outfolder,run)
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
% Columns in trials: onsets in seconds, accuracy, RT. Adjust RTs for Eprime
% clock.

events = {'Go.OnsetTime','Go.ACC','Go.RT','Go1s.OnsetTime','Inhs.ACC',...
          'Go1s.OnsetToOnsetTime','Inhs.OnsetTime','Inhs.RTTime','Go1s2.OnsetTime',...
          'Inhs2.ACC','Go1s2.OnsetToOnsetTime','Inhs2.OnsetTime','Inhs2.RTTime'};

idx = zeros(1,length(events));

for x = 1:length(events)
    idx(x) = find(strcmp(BL1(1,:),events{x}));
end


%% Remove non-numeric data and make trial type arrays
goOnset=[];inhOnset1=[];inhOnset2=[];
for x = 1:length(idx)
    tmp = BL1(:,idx(x));
    tmp(cellfun(@ischar,tmp))=[];
    
    if x < 4
        goOnset(:,x)=cell2mat(tmp);
    elseif x >3 && x<9
        inhOnset1(:,(x-3))=cell2mat(tmp);
    elseif x > 8
        inhOnset2(:,(x-8))=cell2mat(tmp);
    end
end


%% Concatenate staircases,split coditions by accuracy, adjust timing
goOnset(:,1) = (goOnset(:,1)-adjOnset)./1000;
goOnset(:,3) = goOnset(:,3)./1000;
goCorr = goOnset(find(goOnset(:,2)==1),:);
goErr = goOnset(find(goOnset(:,2)==0),:);
goRT = sort(goOnset(:,3).*1000);
mgoRT = mean(goRT);

%%
inhOnset = vertcat(inhOnset1,inhOnset2);
inhOnset(:,6) = inhOnset(:,5)-inhOnset(:,1);
inhOnset(inhOnset(:,6)<0,6) = 0;


%% Behavioral metrics: directional accuracy, go omissions, Stop trial accuracy, and SSRT
pGCOR = sum(goOnset(:,2))/length(goOnset(:,2));
pGNR = (length(goErr(:,3))-length(find(goErr(:,3)>0)))/length(goOnset(:,2));
pINR = sum(inhOnset(:,2))/length(inhOnset(:,2));

% Calculate SSRT
pInhFail = (length(inhOnset(:,2))-sum(inhOnset(:,2)))/length(inhOnset(:,2));
ssd = inhOnset(:,3);
[f,x] = ecdf(goRT);
[~,idx] = min(abs(f-pInhFail));
qRT = x(idx);
SSRT = qRT - mean(ssd);

%% Write onset files
dlmwrite([outfolder,'/goOnset',num2str(run),'.txt'],goCorr,'delimiter','\t')
dlmwrite([outfolder,'/goError',num2str(run),'.txt'],goErr,'delimiter','\t')

inhCorr = inhOnset(find(inhOnset(:,2)==1),:);
inhCorr(:,1) = (inhCorr(:,1)-adjOnset)./1000;
inhCorr(:,7) = (inhCorr(:,3)+SSRT)./1000;
idx = [3:6];
inhCorr(:,idx)=[];
dlmwrite([outfolder,'/StopInhibit',num2str(run),'.txt'],inhCorr,'delimiter','\t')

inhErr = inhOnset(find(inhOnset(:,2)==0),:);
inhErr(:,1) = (inhErr(:,1)-adjOnset)./1000;
inhErr(:,7) = (inhErr(:,3)+inhErr(:,6))./1000;
idx = [3:6];
inhErr(:,idx)=[];
dlmwrite([outfolder,'/StopResp',num2str(run),'.txt'],inhErr,'delimiter','\t')





