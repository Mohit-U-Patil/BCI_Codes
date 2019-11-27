function calculate_result_Cln() 


folderpath = '../RCSP_Toolbox_GPL/MI_Data_Cleaned/CNS_MI_Data_Clean/Online_cal';
folderpath = fullfile(folderpath, '**');    % What is the meaning of "/**/" ???C
filelist   = dir(folderpath);
name       = {filelist.name};
name       = name(~strncmp(name, '.', 1));
nbSubjects = length(name);
result_matrix = cell(nbSubjects,1);

% read_data(1:4,ch2keep);


for l= [1:1:length(name)]
 load(cell2mat(name(l)))   
 matObj = matfile(cell2mat(name(l)));
 RightCln = who(matObj, 'RightclenchImg*');
 LeftCln = who(matObj, 'LeftclenchImg*');
 nbChannels = 32;
 segmentLength = 5;
 fs = 250;


 for k=1:length(RightCln)
   label = vertcat(label, 3);
 end
 for k=1:length(LeftCln)
   label = vertcat(label, 4);
 end
 
nbTrials = length(label)
onlinedata = zeros(1250, 33, nbTrials); 

disp(['nbTrials' num2str(nbTrials)]);
disp(['Number of Right Lift segments' num2str(length(RightCln))]);
disp(['Number of Left Lift segments' num2str(length(LeftCln))]);

for k = 1:1:length(RightCln)  
    onlinedata(:,:,k) = eval((RightCln{k}))'; 
end
for k = length(RightCln)+1:1: nbTrials 
    onlinedata(:,:,k) = eval((LeftCln{k-length(RightCln)}))'; 
end 

 result = zeros(nbTrials,2);
for n = 1:1:nbTrials
    result(n,1) = label(n);
    [results, ~]  = online_csp(onlinedata(:,:,n),2,'WTR_CSP',3:6,3:4,3,sub_no,8,30);
    result(n,2) = results.classes;
   
    %result(n,2) = results.labels;
end
%saving the results to the appropriate matlab files
save('../RCSP_Toolbox_GPL/result_matrix.mat','result');                                            
aa = who(matObj);
clear(aa{:})
end

