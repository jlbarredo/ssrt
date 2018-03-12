%% STUDY-SPECIFIC PARAMETERS
STUDY_DIR = '/Volumes/Luria/CONTE_OCD';
TR=1.0;
SUBJECTS = {'101'};
% SUBJECTS = {'101','102','103','104','105','106','108','109','111',...
%     '112','113','405','406','410','411','413','414','415','416','417','420'};
SCAN = 'Post-tx_MRI';        
SESSIONS = {'SSRT1','SSRT2'};
NSUBJECTS = length(SUBJECTS); 
NSESSIONS = length(SESSIONS);
cwd=pwd;


%% SUBJECT LOOP FOR FILE ARRAYS
STRUCTURAL_FILE = cell(NSUBJECTS,1);
FUNCTIONAL_FILE = cell(NSUBJECTS,NSESSIONS);

for i = 1:NSUBJECTS
    subject = SUBJECTS(i);
    STRUCTURAL_FILE(i,1) = cellstr(fullfile(STUDY_DIR,subject,SCAN,'T1.nii'));
    
    for j = 1:NSESSIONS
    session = SESSIONS(j);
    FUNCTIONAL_FILE(i,j) = cellstr(fullfile(STUDY_DIR,subject,[SCAN,'/ssrt',num2str(j),'.nii']));
    end    
end
 

%% CREATES CONN BATCH STRUCTURE
clear batch;
cd(STUDY_DIR);
batch.filename=fullfile(cwd,[SCAN,'_SSRT_post_prepro.mat']);            % New conn_*.mat experiment name


%% SETUP BATCH   
batch.Setup.nsubjects=NSUBJECTS;
batch.Setup.RT=TR;


%% SETUP CONDITION STRUCTS
batch.Setup.conditions.names = {'SSRT'}; %arrayfun(@(n)sprintf('Session%d',n),1:nconditions,'uni',0);

for nsub=1:NSUBJECTS
    for ncond=1:length(batch.Setup.conditions.names)
        for nses=1:NSESSIONS 
            batch.Setup.conditions.onsets{ncond}{nsub}{nses}=0;
            batch.Setup.conditions.durations{ncond}{nsub}{nses}=inf;
        end
    end
end


%% POINT TO FUNCTIONAL IMAGES & 1ST LEVEL COVARIATES
batch.Setup.functionals=repmat({{}},[NSUBJECTS,1]);  

for nsub=1:NSUBJECTS 
    for nses=1:NSESSIONS
        batch.Setup.functionals{nsub}{nses}{1}=FUNCTIONAL_FILE{nsub,nses}; 
    end 
end


%% POINT TO ANATOMICALS & MASKS
batch.Setup.structurals=STRUCTURAL_FILE;   


%% BL_MRIPROCESSING
batch.Setup.preprocessing.steps={'functional_realign&unwarp','functional_center',...
    'functional_art','functional_segment&normalize_direct',...
    'structural_center' 'structural_segment&normalize' 'functional_smooth'};

batch.Setup.preprocessing.art_thresholds(1)=3; % Conservative, liberal = 9
batch.Setup.preprocessing.art_thresholds(2)=0.5; % Conservative, liberal = 2
batch.Setup.preprocessing.art_thresholds(3)=1;
batch.Setup.preprocessing.art_thresholds(4)=1;
batch.Setup.preprocessing.art_thresholds(5)=0;
batch.Setup.preprocessing.art_thresholds(6)=0;
batch.Setup.preprocessing.art_thresholds(7)=0.02;
batch.Setup.preprocessing.art_thresholds(8)=0;
batch.Setup.preprocessing.FWHM = 6;


%% RUN SETUP AND BL_MRIPROCESSING
batch.Setup.overwrite='Yes'; 
batch.Setup.done=1;


%% Run all analyses                           
conn_batch(batch);


%% CONN Display
% launches conn gui to explore results
% conn
% conn('load',fullfile(cwd,[SCAN,'_prepro.mat']));
% conn gui_results

