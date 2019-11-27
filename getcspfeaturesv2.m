function [trainFeatures, testFeatures]  = getcspfeaturesv2(algo,ch2keep,class2keep,nfb,low,high)


%To do : print the subject name too
%change subject file names to numbers
%print accuracy table
%code for online system



%WTR CSP From Fabian lotte RCSP toolbox%

%4 class MI classification by MOPA and Nickcool %

addpath '../RCSP_Toolbox_GPL/CSP_Algorithms/'
addpath '../RCSP_Toolbox_GPL/CSP_Algorithms/SR_CSP/';
addpath '../RCSP_Toolbox_GPL/CSP_Algorithms/DL_SR_CSP/';
addpath '../RCSP_Toolbox_GPL/CSP_Algorithms/CSP/';
addpath '../RCSP_Toolbox_GPL/CSP_Algorithms/DL_CSP_auto/';
addpath '../RCSP_Toolbox_GPL/CSP_Algorithms/DL_CSP_diff/';
addpath '../RCSP_Toolbox_GPL/CSP_Algorithms/DL_CSP/';
addpath '../RCSP_Toolbox_GPL/CSP_Algorithms/TR_CSP/';
addpath '../RCSP_Toolbox_GPL/CSP_Algorithms/WTR_CSP/';
addpath '../RCSP_Toolbox_GPL/CSP_Algorithms/TR_CCSP1/';
addpath '../RCSP_Toolbox_GPL/CSP_Algorithms/DL_TR_CSP/';
addpath '../RCSP_Toolbox_GPL/CSP_Algorithms/GL_TR_CSP/';
addpath '../RCSP_Toolbox_GPL/CSP_Algorithms/SSR_CSP/';
addpath '../RCSP_Toolbox_GPL/CSP_Algorithms/GLR_CSP/';
addpath '../RCSP_Toolbox_GPL/CSP_Algorithms/CCSP1/';
addpath '../RCSP_Toolbox_GPL/CSP_Algorithms/CCSP2/';
addpath '../RCSP_Toolbox_GPL/LDA_Classification';
addpath '../RCSP_Toolbox_GPL/Utilities';

%Load EEG signals%

read_data(class2keep,ch2keep);
load('trainingEEGSignals.mat');
load('testingEEGSignals.mat');
load('allEEGSignals.mat')
display('Loaded the data bitch - Nikhil Garg!!');

nbSubjects = length(trainingEEGSignals);
accuracy = zeros(1,nbSubjects);
nbFilterPairs = nfb; %we use 3 pairs of filters

%parameters for band pass filtering the signals in the mu+beta band (8-30 Hz)
% low = 8;
% high = 30;
order = 5; %we use a 5th-order butterworth filter

%variables to compute the computation time
trainingTime = zeros(nbSubjects,1);

%hyperparameters of the RCSP approaches
alphaExp = 10:-1:1;
alphaList = 10.^-alphaExp; %regularization parameter of the objective function
rList = [0.01 0.05 0.1 0.5 0.8 1.0 1.2 1.5]; %parameter of the SR_CSP
gammaList = 0:0.1:0.9; %first regularization parameter for covariance matrix regularization
betaList = 0:0.1:0.9; %second regularization parameter for covariance matrix regularization

k = 3; %for hyperparameter selecting using k-fold cross validation

root = ['..\GeneratedData\Pictures' algo '\']; %to save the filter topography pictures

%filtering each trial in the mu+beta frequency band
%Note: Dieter Devlaminck made me realize (thank you Dieter!) that this
%filtering scheme was not optimal. It would be indeed better to filter the
%whole signal first, rather than each trial individually. I have added this
%possibility in the read_BCIXX_DSXX functions (see the function header). 
%The results presented in the IEEE-TBME paper are based on a filtering of each trial individually.
for s=1:nbSubjects
    trainingEEGSignals{s} = eegButterFilter(trainingEEGSignals{s}, low, high, order);
    testingEEGSignals{s} = eegButterFilter(testingEEGSignals{s}, low, high, order);
    allEEGSignals{s} = eegButterFilter(allEEGSignals{s}, low, high, order);
end

for s=1:nbSubjects    
    %Learning the Regularized CSP filters, depending on the algorithm chosen
    tic; %to evaluate the learning time
    
    otherSubjects = [1:(s-1) (s+1):nbSubjects];
    
    if strcmp(algo,'CSP')
        disp('Learning CSP filters assuming invertible covariance matrices');
        CSPMatrix = learnCSPLagrangian(trainingEEGSignals{s});
    elseif strcmp(algo,'CSPJointDiag')
        disp('Learning CSP filters with joint diagonalization');
        CSPMatrix = learnCSP(trainingEEGSignals{s});
    elseif strcmp(algo, 'DL_CSP_auto')
        disp('Learning CSP filters with automatic Diagonal Loading regularization (Ledoit & Wolf method)');
        CSPMatrix = learn_DL_CSPLagrangian_auto(trainingEEGSignals{s});
    elseif strcmp(algo, 'DL_CSP_diff')
        disp('Learning CSP filters with Diagonal Loading and different regularization parameter values for each class');
        bestGamma = DL_CSP_diffWithBestParams(trainingEEGSignals{s}, [gammaList;gammaList], k, nbFilterPairs);
        disp('bestGamma: '); disp(bestGamma);
        CSPMatrix = learn_DL_CSP_diff(trainingEEGSignals{s}, bestGamma);
    elseif strcmp(algo, 'DL_CSP')
        disp('Learning CSP filters with Diagonal Loading regularization (cross validation)');
        bestGamma = DL_CSPWithBestParams(trainingEEGSignals{s}, gammaList, k, nbFilterPairs);
        CSPMatrix = learn_DL_CSP(trainingEEGSignals{s}, bestGamma);
    elseif strcmp(algo,'TR_CSP')            
        disp('Learning Tikhonov Regularized CSP filters');    
        %step 1: find the optimal hyperparameters        
        bestAlpha = TR_CSPWithBestParams(trainingEEGSignals{s}, alphaList, k, nbFilterPairs); 
        %step 2: learn the TR CSP with the best hyperparameters
        CSPMatrix = learn_TR_CSP(trainingEEGSignals{s}, bestAlpha);
    elseif strcmp(algo,'WTR_CSP')            
        disp('Learning Weighted Tikhonov Regularized CSP filters');    
        %learning the weight from other subjects        
        weightVector = learnWTR_CSP_WeightVector(allEEGSignals(otherSubjects), nbFilterPairs);
        disp(['Channel Weight vector : ' num2str(weightVector) 'subject : ' num2str(s)]);
        %step 1: find the optimal hyperparameters        
        bestAlpha = WTR_CSPWithBestParams(trainingEEGSignals{s}, weightVector, alphaList, k, nbFilterPairs);
        %disp(['BestAlpha: ' num2str(bestAlpha)]);
        %step 2: learn the WTR CSP with the best hyperparameters
        CSPMatrix = learn_WTR_CSP(trainingEEGSignals{s}, weightVector, bestAlpha);
    elseif strcmp(algo,'DL_TR_CSP')
        disp('Learning Tikhonov Regularized CSP filters with Diagonal Loading');
        %step 1: find the optimal hyperparameters        
        [bestAlpha bestGamma] = DL_TR_CSPWithBestParams(trainingEEGSignals{s}, alphaList, gammaList, k, nbFilterPairs);
        disp(['BestAlpha: ' num2str(bestAlpha) ' - bestGamma: ' num2str(bestGamma)]);
        %step 2: learn the DL TR CSP with the best hyperparameters
        CSPMatrix = learn_DL_TR_CSP(trainingEEGSignals{s}, bestAlpha, bestGamma);
    elseif strcmp(algo,'SR_CSP')        
        disp('Learning Spatially Regularized CSP filters');    
        %step 1: find the optimal hyperparameters        
        [bestAlpha bestR] = SR_CSPWithBestParams(trainingEEGSignals{s}, elecCoord, alphaList, rList, k, nbFilterPairs);
        disp(['Best r: ' num2str(bestR)]);
        %step 2: learn the SR CSP with the best hyperparameters
        CSPMatrix = learn_SR_CSP(trainingEEGSignals{s}, elecCoord, bestAlpha, bestR);
    elseif strcmp(algo,'DL_SR_CSP')
        disp('Learning Spatially Regularized CSP filters with Diagonal Loading');    
        %step 1: find the optimal hyperparameters        
        [bestAlpha bestGamma bestR] = DL_SR_CSPWithBestParams(trainingEEGSignals{s}, elecCoord, alphaList, gammaList, rList, k, nbFilterPairs);
        disp(['Best r: ' num2str(bestR) ' - bestAlpha: ' num2str(bestAlpha) ' - bestGamma: ' num2str(bestGamma)]);
        %step 2: learn the SR CSP with the best hyperparameters
        CSPMatrix = learn_DL_SR_CSP(trainingEEGSignals{s}, elecCoord, bestAlpha, bestGamma, bestR);
    elseif strcmp(algo,'SSR_CSP')
        disp('Learning Subjects Subset Regularized CSP filters');         
        otherTrainingEEGSignals = trainingEEGSignals(otherSubjects);        
        %step 1: identifying the subset of subjects to use
        bestSubset = SSR_CSP_SelectSubjects(trainingEEGSignals{s}, otherTrainingEEGSignals, nbFilterPairs);
        %step 2: identifying the best regularization parameter
        bestBeta = SSR_CSPWithBestParams(trainingEEGSignals{s}, otherTrainingEEGSignals(bestSubset), betaList, k, nbFilterPairs);
        %step 3: learning the SSR CSP with the best hyperparameter
        CSPMatrix = learn_SSR_CSP_fixedSelection(trainingEEGSignals{s}, otherTrainingEEGSignals(bestSubset), bestBeta);
        clear otherTrainingEEGSignals;
    elseif strcmp(algo,'GLR_CSP')
        disp('Learning Generic Learning Regularized CSP filters');         
        [bestGamma bestBeta] = GLR_CSPWithBestParams(trainingEEGSignals{s}, trainingEEGSignals(otherSubjects), gammaList, betaList, k, nbFilterPairs);
        CSPMatrix = learn_GLR_CSP(trainingEEGSignals{s}, trainingEEGSignals(otherSubjects), bestGamma, bestBeta);
    elseif strcmp(algo,'GL_TR_CSP')
        disp('Learning Generic Learning Tikhonov Regularized CSP filters');         
        [bestAlpha bestBeta] = GL_TR_CSPWithBestParams(trainingEEGSignals{s}, trainingEEGSignals(otherSubjects), alphaList, betaList, k, nbFilterPairs);
        disp(['BestAlpha: ' num2str(bestAlpha) ' - bestBeta: ' num2str(bestBeta)]);
        CSPMatrix = learn_GLR_CSP(trainingEEGSignals{s}, trainingEEGSignals(otherSubjects), bestAlpha, bestBeta);
    elseif strcmp(algo,'TR_CCSP1')
        disp('Learning Tikhonov Regularized Composite CSP method 1 filters');         
        [bestAlpha bestBeta] = TR_CCSP1WithBestParams(trainingEEGSignals{s}, trainingEEGSignals(otherSubjects), alphaList, betaList, k, nbFilterPairs);
        disp(['BestAlpha: ' num2str(bestAlpha) ' - bestBeta: ' num2str(bestBeta)]);
        CSPMatrix = learn_TR_CCSP1(trainingEEGSignals{s}, trainingEEGSignals(otherSubjects), bestAlpha, bestBeta);
    elseif strcmp(algo, 'CCSP1')
        disp('Learning Composite CSP method 1');            
        bestBeta = CCSP1WithBestParams(trainingEEGSignals{s}, trainingEEGSignals(otherSubjects), betaList, k, nbFilterPairs);
        CSPMatrix = learn_CCSP1(trainingEEGSignals{s}, trainingEEGSignals(otherSubjects), bestBeta);
    elseif strcmp(algo, 'CCSP2')
        disp('Learning Composite CSP method 2');        
        bestBeta = CCSP2WithBestParams(trainingEEGSignals{s}, trainingEEGSignals(otherSubjects), betaList, k, nbFilterPairs);
        CSPMatrix = learn_CCSP2(trainingEEGSignals{s}, trainingEEGSignals(otherSubjects), bestBeta);
    else
        disp('!! ERROR !! Incorrect CSP algorithm !');
        disp('Possible algorithms are: CSP, CSPJointDiag, DL_CSP_auto, DL_CSP, TR_CSP, WTR_CSP, DL_TR_CSP, SR_CSP, DL_SR_CSP, SSR_CSP, GLR_CSP, GL_TR_CSP, TR_CCSP1, CCSP1, CCSP2');
        return;
    end
    trainingTime(s) = toc;
    
%     %plotting the best CSP filter, if needed
%     if printTopo==1
%         %creating the map of channel location                
%         elecIndex = ismember(emap(1,:),trainingEEGSignals{s}.c);    
%         emap = emap(:,elecIndex);        
%         for f=1:nbFilterPairs
%             plotElecPotentials(emap,CSPMatrix(f,:));
%             filenameFig = ['' root 'S' num2str(s) '_FilterPair' num2str(f) '_C1.fig'];
%             filenameEPS = ['' root 'S' num2str(s) '_FilterPair' num2str(f) '_C1.eps'];
%             filenameJPG = ['' root 'S' num2str(s) '_FilterPair' num2str(f) '_C1.jpeg'];            
%             print(filenameFig);
%             print('-depsc',filenameEPS);
%             print('-djpeg',filenameJPG);
%             close;
% 
%             plotElecPotentials(emap,CSPMatrix(end-f+1,:));
%             filenameFig = ['' root 'S' num2str(s) '_FilterPair' num2str(f) '_C2.fig'];
%             filenameEPS = ['' root 'S' num2str(s) '_FilterPair' num2str(f) '_C2.eps'];
%             filenameJPG = ['' root 'S' num2str(s) '_FilterPair' num2str(f) '_C2.jpeg'];
%             print(filenameFig);
%             print('-depsc',filenameEPS);
%             print('-djpeg',filenameJPG);
%             close;
%         end
%     end
     
    %extracting CSP features from the training set
    trainFeatures = extractCSPFeatures(trainingEEGSignals{s}, CSPMatrix, nbFilterPairs);
    %extracting CSP features from the testing set
    testFeatures = extractCSPFeatures(testingEEGSignals{s}, CSPMatrix, nbFilterPairs);
    %training a LDA classifier on these features
    
%     
%     ldaParams = LDA_Train(trainFeatures);
%     %classifying the test features with the learnt LDA
%     result = LDA_Test(testFeatures, ldaParams);    
%     accuracy(s) = result.accuracy
%   
   accuracy(s) =  classify(trainFeatures, testFeatures);
     
end

%computing average time needed for training
meanTrain = mean(trainingTime); stdTrain = std(trainingTime);
disp(['Training time: ' num2str(meanTrain) ' - std: ' num2str(stdTrain)]);


load('name.mat') ;
for l= [1:1:length(name)]
 disp(['test set accuracy for subject '  name(l)  accuracy(l) ])
end 
end
