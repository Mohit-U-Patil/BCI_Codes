function calculate_result_Lift() 


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
 
%read_data(1:2,3:6)
 load(cell2mat(name(l)))   
 matObj = matfile(cell2mat(name(l)));
 RightLift = who(matObj, 'RightImg*');
 LeftLift = who(matObj, 'LeftImg*'); 
 nbChannels = 32;
 segmentLength = 5;
 fs = 250;


 for k=1:length(RightLift)
   label = vertcat(label, 1);
 end
 for k=1:length(LeftLift)
   label = vertcat(label, 2);
 end
 

nbTrials = length(label);
onlinedata = zeros(1250, 33, nbTrials); 

disp(['nbTrials' num2str(nbTrials)]);
disp(['Number of Right Lift segments' num2str(length(RightLift))]);
disp(['Number of Left Lift segments' num2str(length(LeftLift))]);

for k = 1:1:length(RightLift)  
    onlinedata(:,:,k) = eval((RightLift{k}))'; 
end
for k = length(RightLift)+1:1: nbTrials 
    onlinedata(:,:,k) = eval((LeftLift{k-length(RightLift)}))'; 
end 

save('../RCSP_Toolbox_GPL/onlinedata.mat','onlinedata');                                            

 result = zeros(nbTrials,2);
for n = 1:1:nbTrials
    result(n,1) = label(n);
    [results, ~]  = online_csp(onlinedata(:,:,n),2,'WTR_CSP',3:6,1:2,3,sub_no,8,30);
    result(n,2) = results.classes;
   
    %result(n,2) = results.labels;
end
%saving the results to the appropriate matlab files
save('../RCSP_Toolbox_GPL/result_matrix.mat','result');        
aa = who(matObj);
clear(aa{:})
end

