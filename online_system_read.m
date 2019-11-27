function online_system_read(sub_no, algo_name, ch2keep, nfb, low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate)
% function folder_run_calculate_result_4class_OVR_OVO(classifier_name, ch2keep, nfb, low, high, 'sym9', 6, 'SURE', 'Soft', 'LevelIndependent')
% decomposition_level = 6 ;
% denoising_method = 'SURE' ; 
% ThresholdRule = 'Soft';
% NoiseEstimate = 'LevelIndependent';
l = sub_no;

read_data_and_denoise(1:4,ch2keep, 8, 30, 'sym9', 6, 'SURE', 'Soft', 'LevelIndependent');
stepwise_classification_features(algo_name,ch2keep, nfb,l,low,high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);

end

