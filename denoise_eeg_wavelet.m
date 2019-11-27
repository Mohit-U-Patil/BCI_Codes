function [EEGData_denoised]  = denoise_eeg_wavelet(EEGData_raw, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate)

%input params:
%EEGData_raw : extracted EEG signals
%mother_wavelet
%decomposition_level
%order: filter order
%sorh
%crit
%par
%keepapp
%
% mother_wavelet = 'sym9';
% decomposition_level = 6 ;
% denoising_method = 'SURE' ; 
% ThresholdRule = 'Soft';
% NoiseEstimate = 'LevelIndependent';

%output
%EEGData_denoised: the EEG data band-pass filtered in the specified
%by Nikhil Garg & Mohit Patil
%created: 04/02/2019
%last revised: 04/02/2019

%identifying various constants
nbSamples = size(EEGData_raw.x,1);
nbChannels = size(EEGData_raw.x,2);
nbTrials = size(EEGData_raw.x,3);

%preparing the output data
EEGData_denoised.x = zeros(nbSamples, nbChannels, nbTrials);
EEGData_denoised.c = EEGData_raw.c;
EEGData_denoised.s = EEGData_raw.s;
EEGData_denoised.y = EEGData_raw.y;

%designing the wavelet packet denoiser



%denoising all channels in this frequency band, for the raw data
for i=1:nbTrials %all trials
    for j=1:nbChannels %all channels
      EEGData_denoised.x(:,j,i) =  wdenoise(EEGData_raw.x(:,j,i),decomposition_level, ...
        'Wavelet', mother_wavelet, ...
        'DenoisingMethod', denoising_method, ...
        'ThresholdRule', ThresholdRule, ... 
        'NoiseEstimate', NoiseEstimate);
       
    end
end
end

