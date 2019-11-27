function[result,accuracy]   = classify_RLDA(trainFeatures, testFeatures)    

% folderpath = '/Users/Anonymous/Downloads/RCSP_Toolbox_GPL/MI_Data_Cleaned/CNS_MI_Data_Clean/train';
% folderpath = fullfile(folderpath, '**');    % What is the meaning of "/**/" ???
% filelist   = dir(folderpath);
% name       = {filelist.name};
% name       = name(~strncmp(name, '.', 1));
% nbSubjects = length(name);

% load('trainFeatures.mat');
% load('testFeatures.mat');


% for s=1:nbSubjects 
    ldaParams = RLDA_Train(trainFeatures);
    %classifying the test features with the learnt LDA
    result = LDA_Test(testFeatures, ldaParams);    
    accuracy = result.accuracy;   

%     disp(['test set accuracy for subject' name(s) ' = ' num2str(accuracy(s)\) ' %']);    
% end
% end 