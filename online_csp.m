function [result,accuracy]  = online_csp(amp_data_collect,true_class,algo,ch2keep,class2keep,nfb,sub_no,low,high)
%WTR CSP From Fabian lotte RCSP toolbox%
%MI classification onlineby MOPA and Nickcool %

addpath '..\RCSP_Toolbox_GPL\CSP_Algorithms\'
addpath '..\RCSP_Toolbox_GPL\CSP_Algorithms\SR_CSP\';
addpath '..\RCSP_Toolbox_GPL\CSP_Algorithms\DL_SR_CSP\';
addpath '..\RCSP_Toolbox_GPL\CSP_Algorithms\CSP\';
addpath '..\RCSP_Toolbox_GPL\CSP_Algorithms\DL_CSP_auto\';
addpath '..\RCSP_Toolbox_GPL\CSP_Algorithms\DL_CSP_diff\';
addpath '..\RCSP_Toolbox_GPL\CSP_Algorithms\DL_CSP\';
addpath '..\RCSP_Toolbox_GPL\CSP_Algorithms\TR_CSP\';
addpath '..\RCSP_Toolbox_GPL\CSP_Algorithms\WTR_CSP\';
addpath '..\RCSP_Toolbox_GPL\CSP_Algorithms\TR_CCSP1\';
addpath '..\RCSP_Toolbox_GPL\CSP_Algorithms\DL_TR_CSP\';
addpath '..\RCSP_Toolbox_GPL\CSP_Algorithms\GL_TR_CSP\';
addpath '..\RCSP_Toolbox_GPL\CSP_Algorithms\SSR_CSP\';
addpath '..\RCSP_Toolbox_GPL\CSP_Algorithms\GLR_CSP\';
addpath '..\RCSP_Toolbox_GPL\CSP_Algorithms\CCSP1\';
addpath '..\RCSP_Toolbox_GPL\CSP_Algorithms\CCSP2\';
addpath '..\RCSP_Toolbox_GPL\LDA_Classification';
addpath '..\RCSP_Toolbox_GPL\Utilities';

%Load EEG signals%
% run read_data only once at the begining
% read_data(class2keep,ch2keep);

load('trainingEEGSignals.mat');
load('allEEGSignals.mat')
display('Loaded the data - Nikhil Garg!!');
nbSubjects = length(trainingEEGSignals);
accuracy = [];
nbFilterPairs = nfb; %we use 3 pairs of filters

%parameters for band pass filtering the signals in the mu+beta band (8-30 Hz)
% low = 8;
% high = 30;
order = 5; %we use a 5th-order butterworth filter

%hyperparameters of the RCSP approaches
alphaExp = 10:-1:1;
alphaList = 10.^-alphaExp; %regularization parameter of the objective function
rList = [0.01 0.05 0.1 0.5 0.8 1.0 1.2 1.5]; %parameter of the SR_CSP
gammaList = 0:0.1:0.9; %first regularization parameter for covariance matrix regularization
betaList = 0:0.1:0.9; %second regularization parameter for covariance matrix regularization
k = 3; %for hyperparameter selecting using k-fold cross validation
%filtering each trial in the mu+beta frequency band
for s=1:nbSubjects
    trainingEEGSignals{s} = eegButterFilter(trainingEEGSignals{s}, low, high, order);
    allEEGSignals{s} = eegButterFilter(allEEGSignals{s}, low, high, order);
end

s = sub_no;
   
%Learning the Regularized CSP filters, depending on the algorithm chosen
    otherSubjects = [1:(s-1) (s+1):nbSubjects];
%to do: redefine the trainingEEGSignal{i} by the online system 

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
        bestAlpha = WTR_CSPWithBestParams(allEEGSignals{s}, weightVector, alphaList, k, nbFilterPairs);
        %disp(['BestAlpha: ' num2str(bestAlpha)]);
        %step 2: learn the WTR CSP with the best hyperparameters
        CSPMatrix = learn_WTR_CSP(allEEGSignals{s}, weightVector, bestAlpha);
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
    
    %extracting CSP features from the training set  
    trainFeatures = extractCSPFeatures(allEEGSignals{s}, CSPMatrix, nbFilterPairs);
    lengthTest = 1;
  %  testingEEGSignal = cell(1,1);
%     EEGdataTest = cell(1,1);
    channelList = {(ch2keep)};
    EEGdataTest.c = channelList;
    EEGdataTest.s = 250;
    ampdata = [];
    %an infinite loop to collect ampdata, storing it, classifying it,
    %showing the accuracy and generate the output as well!! Isn't that
    %awesome??
% i = counter;
nbChannels = length(ch2keep);

EEGdataOnline.c = channelList;
EEGdataOnline.s = 250;
EEGdataOnline.y = zeros(1,1);
EEGdataOnline.x = zeros(1250, nbChannels, 1);

    EEGdataOnline.y = true_class ; %todo:insert the true label here;
    EEGdataOnline.x = amp_data_collect(:, ch2keep ,1); %todo:insert the data here%(1250, nbChannels, 1);
    %assigning the true label here
    %filtering the data
    EEGdataOnline = eegButterFilter(EEGdataOnline, low, high, order); 
    
    
    %extracting test features
    testFeatures = extractCSPFeatures(EEGdataOnline, CSPMatrix, nbFilterPairs);
    %training a LDA classifier on these features & classifying the test features with the learnt LDA
    [result,accuracy] =  classify(trainFeatures, testFeatures);
    %find out the output of the classifier ar this point {i}
    %disp(['EEG_data_online.x dimension' num2str(size(EEGdataOnline.x))]);

    %output = predict(testFeatures,trainFeatures);
    %%print the output and accuracy here 
    result;


end
