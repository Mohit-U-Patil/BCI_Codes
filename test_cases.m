folderpath = '../RCSP_Toolbox_GPL/MI_Data_Cleaned/CNS_MI_Data_Clean/Online_cal';
folderpath = fullfile(folderpath, '**');    % What is the meaning of "/**/" ???C
filelist   = dir(folderpath);
name       = {filelist.name};
name       = name(~strncmp(name, '.', 1));
nbSubjects = length(name);
result_matrix = cell(nbSubjects,1);

for l= [1:1:length(name)]
 label = [];
 disp('Analyzing file:');
 name(l)
%  stepwise_classification_features('WTR_CSP',3:6, 3,l,8,30);
 sub_no = l;
%read_data(1:4,3:6)
 load(cell2mat(name(l)));
 matObj = matfile(cell2mat(name(l)));
 RightLift = who(matObj, 'RightImg*')
 LeftLift = who(matObj, 'LeftImg*')
 RightCln = who(matObj, 'RightclenchImg*')
 LeftCln = who(matObj, 'LeftclenchImg*')
end