function calculate_result_4class_pair() 


folderpath = '../RCSP_Toolbox_GPL/MI_Data_Cleaned/CNS_MI_Data_Clean/Online_cal';
folderpath = fullfile(folderpath, '**');    % What is the meaning of "/**/" ???C
filelist   = dir(folderpath);
name       = {filelist.name};
name       = name(~strncmp(name, '.', 1));
nbTrials = length(name);
OnlineEEGSignals = cell(nbTrials,1);
sub_no = 14;
label = [];
for l= [1:1:length(name)]
 
%read_data(1:4,3:6)
 load(cell2mat(name(l)))   
 matObj = matfile(cell2mat(name(l)));
 RightLift = who(matObj, 'RightImg*');
 LeftLift = who(matObj, 'LeftImg*'); 
 RightCln = who(matObj, 'RightclenchImg*');
 LeftCln = who(matObj, 'LeftclenchImg*');
 nbChannels = 32;
 segmentLength = 5;
 fs = 250;


 for k=1:length(RightLift)
   label = vertcat(label, 1);
 end
 for k=1:length(LeftLift)
   label = vertcat(label, 2);
 end
 for k=1:length(RightCln)
   label = vertcat(label, 3);
 end
 for k=1:length(LeftCln)
   label = vertcat(label, 4);
 end
 
 
 
nbTrials = length(label);
onlinedata = zeros(1250, 33, nbTrials); 


for k = 1:1:length(RightLift)
    onlinedata(:,:,k) = eval((RightLift{k}))'; 
end
for k = length(RightLift)+1 :1: length(RightLift) + length(LeftLift)
    onlinedata(:,:,k) = eval((LeftLift{k-(length(RightLift))}))'; 
end 
for k = length(RightLift)+length(LeftLift)+1 :1: length(RightLift)+length(LeftLift)+length(RightCln)
    onlinedata(:,:,k) = eval((RightCln{k-length(RightLift)-length(LeftLift)}))'; 
end
for k = (length(RightLift)+length(LeftLift)+length(RightCln)+1):1: nbTrials 
    onlinedata(:,:,k) = eval((LeftCln{k-length(RightLift)-length(LeftLift)-length(RightCln)}))'; 
end 


save('../RCSP_Toolbox_GPL/onlinedata.mat','onlinedata');   

%in four class classification, multiple class training signal is causing
%problems, error is CSP can be used with only 2 classes. Following block
%changes allEEGSignals into EEGSignals12,
%EEGSignals13,EEGSignals14,EEGSignals23,EEGSignals24,EEGSignals34. after
%this before calling online_csp inside Pair_4class, allEEGSignals will be
%replaced by one of the 6 EEGSignal combinations respectively before the
%call so multiclass issue is solved.

result = zeros(nbTrials,3);
for n = 1:1:nbTrials
    result(n,1) = label(n);
    result(n,2) = Pair_4class(onlinedata(:,:,n));
   %result(n,2) = results.labels;
end

%saving the results to the appropriate matlab files
save('../RCSP_Toolbox_GPL/result_matrix.mat','result'); 
aa = who(matObj);
clear(aa{:})
end

