function KGB_Denoise(ch2keep, nfb, fs, segmentLength, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate)
% function folder_run_calculate_result_4class_OVR_OVO(classifier_name, ch2keep, nfb, low, high, 'sym9', 6, 'SURE', 'Soft', 'LevelIndependent')
% decomposition_level = 6 ;
% denoising_method = 'SURE' ; 
% ThresholdRule = 'Soft';
% NoiseEstimate = 'LevelIndependent';
folderpath = '../RCSP_Toolbox_GPL/MI_Data_Cleaned/CNS_MI_Data_Clean/Online_cal';
folderpath = fullfile(folderpath, '**');    % What is the meaning of "/**/" ???C
filelist   = dir(folderpath);
name       = {filelist.name};
name       = name(~strncmp(name, '.', 1));
nbSubjects = length(name);
allEEGSignals = cell(nbSubjects,1);

for l= [1:1:length(name)]
label = [];
disp('Analyzing file:');
name(l)
nbFilterPairs = nfb; %we use 3 pairs of filters

%parameters for band pass filtering the signals in the mu+beta band (8-30 Hz)
% low = 8;
% high = 30;
order = 10; %we use a 5th-order butterworth filter

%hyperparameters of the RCSP approaches
alphaExp = 10:-1:1;
alphaList = 10.^-alphaExp; %regularization parameter of the objective function
rList = [0.01 0.05 0.1 0.5 0.8 1.0 1.2 1.5]; %parameter of the SR_CSP
gammaList = 0:0.1:0.9; %first regularization parameter for covariance matrix regularization
betaList = 0:0.1:0.9; %second regularization parameter for covariance matrix regularization
k = 3; %for hyperparameter selecting using k-fold cross validation
%filtering each trial in the mu+beta frequency band

label = [];
subjectNo = l;
load(cell2mat(name(l)))   
matObj = matfile(cell2mat(name(l)));
allsegments = who(matObj , '*');  

nbChannels = length(ch2keep);
nbTrials = length(allsegments);
channelList = {(ch2keep)};

EEGdata.c = channelList;
EEGdata.s = fs;
EEGdata.y = zeros(1,nbTrials);
EEGdata.x = zeros(fs * segmentLength, nbChannels, nbTrials);

EEGdataall.c = channelList;
EEGdataall.s = fs;
EEGdataall.y = zeros(1,nbTrials);
EEGdataall.x = zeros(fs * segmentLength, nbChannels, nbTrials);

t = [];
for i = 1:1:length(allsegments)
     t = eval((allsegments{i})); 
     EEGdataall.x(:,:,i) = t(ch2keep,:)';
%      EEGdataall.y(:,j) = label(i);
end

allEEGSignals{subjectNo} = EEGdataall;
allEEGSignals_butter{subjectNo} = eegButterFilter(allEEGSignals{subjectNo}, low, high, order);
allEEGSignals_denoised{subjectNo} = denoise_eeg_wavelet(allEEGSignals{subjectNo}, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);                          

aa = who(matObj);
clear(aa{:})
end

disp('segment numbers');
%saving the results to the appropriate matlab files
%following line to match with calculate_result_4class



save('../RCSP_Toolbox_GPL/allEEGSignals.mat','allEEGSignals');
save('../RCSP_Toolbox_GPL/allEEGSignals_bak.mat','allEEGSignals_denoised');
save('../RCSP_Toolbox_GPL/allEEGSignals_bak.mat','allEEGSignals_butter');
end