%this script saves training features and CSPMatrices for subject and helps
%reduce the classification time. This script is not called from other
%functions and has to be called previous to the main classification script.

function stepwise_classification_features(algo,ch2keep,nfb,sub_no,low,high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate)
classify = zeros(1,6);
CSPMatrix = cell(12,1);
trainFeatures = cell(12,1);
% load('allEEGSignals_bak.mat')
% allEEGSignals_copy = allEEGSignals_bak ;

allEEGSignals_OVR_bak = change_data_OVR(3:6);
allEEGSignals_copy = allEEGSignals_OVR_bak ;

%initiate the CSPMatrix and trainFeatures cell and save each of the
%following components to minimize variables

allEEGSignals = change_data(allEEGSignals_copy,[1 2], ch2keep);
save('../RCSP_Toolbox_GPL/allEEGSignals.mat','allEEGSignals');
[CSPMatrix12,trainFeatures12]  = csp_matrix_and_trainfeatures(algo,ch2keep,[1 2], nfb, sub_no, low,high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);
delete ('../RCSP_Toolbox_GPL/allEEGSignals.mat');


allEEGSignals = change_data(allEEGSignals_copy,[1 3], ch2keep);
save('../RCSP_Toolbox_GPL/allEEGSignals.mat','allEEGSignals');
[CSPMatrix13,trainFeatures13]  = csp_matrix_and_trainfeatures(algo,ch2keep,[1 3], nfb, sub_no, low,high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);
delete ('../RCSP_Toolbox_GPL/allEEGSignals.mat');

allEEGSignals = change_data(allEEGSignals_copy,[1 4], ch2keep);
save('../RCSP_Toolbox_GPL/allEEGSignals.mat','allEEGSignals');
[CSPMatrix14,trainFeatures14]  = csp_matrix_and_trainfeatures(algo,ch2keep,[1 4], nfb, sub_no, low,high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);
delete ('../RCSP_Toolbox_GPL/allEEGSignals.mat');

allEEGSignals = change_data(allEEGSignals_copy,[2 3], ch2keep);
save('../RCSP_Toolbox_GPL/allEEGSignals.mat','allEEGSignals');
[CSPMatrix23,trainFeatures23]  = csp_matrix_and_trainfeatures(algo,ch2keep,[2 3], nfb, sub_no, low,high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);
delete ('../RCSP_Toolbox_GPL/allEEGSignals.mat');

allEEGSignals = change_data(allEEGSignals_copy,[2 4], ch2keep);
save('../RCSP_Toolbox_GPL/allEEGSignals.mat','allEEGSignals');
[CSPMatrix24,trainFeatures24]  = csp_matrix_and_trainfeatures(algo,ch2keep,[2 4], nfb, sub_no, low,high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);
delete ('../RCSP_Toolbox_GPL/allEEGSignals.mat');

allEEGSignals = change_data(allEEGSignals_copy,[3 4], ch2keep);
save('../RCSP_Toolbox_GPL/allEEGSignals.mat','allEEGSignals');
[CSPMatrix34,trainFeatures34]  = csp_matrix_and_trainfeatures(algo,ch2keep,[3 4], nfb,sub_no,low,high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);
delete ('../RCSP_Toolbox_GPL/allEEGSignals.mat');


allEEGSignals = change_data(allEEGSignals_copy,[1 5], 3:6);
save('../RCSP_Toolbox_GPL/allEEGSignals.mat','allEEGSignals');
[CSPMatrix1R,trainFeatures1R]  = csp_matrix_and_trainfeatures(algo,ch2keep,[1 5], nfb,sub_no,low,high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);
delete ('../RCSP_Toolbox_GPL/allEEGSignals.mat');

allEEGSignals = change_data(allEEGSignals_copy,[2 6], 3:6);
save('../RCSP_Toolbox_GPL/allEEGSignals.mat','allEEGSignals');
[CSPMatrix2R,trainFeatures2R]  = csp_matrix_and_trainfeatures(algo,ch2keep,[2 6], nfb,sub_no,low,high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);
delete ('../RCSP_Toolbox_GPL/allEEGSignals.mat');

allEEGSignals = change_data(allEEGSignals_copy,[3 7], 3:6);
save('../RCSP_Toolbox_GPL/allEEGSignals.mat','allEEGSignals');
[CSPMatrix3R,trainFeatures3R]  = csp_matrix_and_trainfeatures(algo,ch2keep,[3 7], nfb,sub_no,low,high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);
delete ('../RCSP_Toolbox_GPL/allEEGSignals.mat');

allEEGSignals = change_data(allEEGSignals_copy,[4 8], 3:6);
save('../RCSP_Toolbox_GPL/allEEGSignals.mat','allEEGSignals');
[CSPMatrix4R,trainFeatures4R]  = csp_matrix_and_trainfeatures(algo,ch2keep,[4 8], nfb,sub_no,low,high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);
delete ('../RCSP_Toolbox_GPL/allEEGSignals.mat');


%CSPMatrixRL stands for CSPMatrix Right vs Left
allEEGSignals = change_data(allEEGSignals_copy,[9 10], 3:6);
save('../RCSP_Toolbox_GPL/allEEGSignals.mat','allEEGSignals');
[CSPMatrixRL,trainFeaturesRL]  = csp_matrix_and_trainfeatures(algo,ch2keep,[9 10], nfb,sub_no,low,high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);
delete ('../RCSP_Toolbox_GPL/allEEGSignals.mat');


%CSPMatrixLC stands for CSPMatrix Lift vs Clench
allEEGSignals = change_data(allEEGSignals_copy,[11 12], 3:6);
save('../RCSP_Toolbox_GPL/allEEGSignals.mat','allEEGSignals');
[CSPMatrixLC,trainFeaturesLC]  = csp_matrix_and_trainfeatures(algo,ch2keep,[11 12], nfb,sub_no,low,high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);
delete ('../RCSP_Toolbox_GPL/allEEGSignals.mat');

CSPMatrix{1} = CSPMatrix12;
CSPMatrix{2} = CSPMatrix13;
CSPMatrix{3} = CSPMatrix14;
CSPMatrix{4} = CSPMatrix23;
CSPMatrix{5} = CSPMatrix24;
CSPMatrix{6} = CSPMatrix34;
CSPMatrix{7} = CSPMatrix1R;
CSPMatrix{8} = CSPMatrix2R;
CSPMatrix{9} = CSPMatrix3R;
CSPMatrix{10} = CSPMatrix4R;
CSPMatrix{11} = CSPMatrixRL;
CSPMatrix{12} = CSPMatrixLC;
save('../RCSP_Toolbox_GPL/CSPMatrix.mat','CSPMatrix');

trainFeatures{1} = trainFeatures12;
trainFeatures{2} = trainFeatures13;
trainFeatures{3} = trainFeatures14;
trainFeatures{4} = trainFeatures23;
trainFeatures{5} = trainFeatures24;
trainFeatures{6} = trainFeatures34;
trainFeatures{7} = trainFeatures1R;
trainFeatures{8} = trainFeatures2R;
trainFeatures{9} = trainFeatures3R;
trainFeatures{10} = trainFeatures4R;
trainFeatures{11} = trainFeaturesRL;
trainFeatures{12} = trainFeaturesLC;
save('../RCSP_Toolbox_GPL/trainFeatures.mat','trainFeatures');

end