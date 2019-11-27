
function [cwt_features]  = feature_extraction_cwt(input_signal, wname, fs,frequency_limits,voices_per_octave)
%input_signal is one dimension signal 
%wname is wavelet name 
%fs and ts have to be passed as input argument of the main function. the
%default value according to our experiment is 250 and seconds(0.0040)
%respectively. 


% the output dimension of cwt_feature is
% (2*voices_per_octave,number_of_data_points(1250))

% sample call : feature_extraction_cwt(input_signal, 'amor', 250, [8 30], 10)
%Insert the below line in place of TimeBandwith name value pair input
%argument
%'WaveletParameters', (3,60)


%Default arguments to put
%wname : 'amor'
%fs = 250
%ts = seconds(0.0040)
%frequency_limits = [8 30]
%period_limits = [seconds(0.2) seconds(4)]
%voices_per_octave = 10
%time_bandwith = 60

[wt] = cwt(input_signal, wname, fs,... 
'FrequencyLimits',frequency_limits ,...
'VoicesPerOctave',voices_per_octave);
cwt_features = wt;
end
