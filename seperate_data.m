folderpath = '../RCSP_Toolbox_GPL/MI_Data_Cleaned/CNS_MI_Data_Clean/shortlisted';
    folderpath = fullfile(folderpath, '**');    % What is the meaning of "/**/" ???
    filelist   = dir(folderpath);
    name       = {filelist.name};
    name       = name(~strncmp(name, '.', 1));
    nbSubjects = length(name);

for l= (1:1:length(name))
    
    load(cell2mat(name(l))) 
    matObj = matfile(cell2mat(name(l)));
    allsegment = who(matObj, '*');
 %please create this path in your folder as well. 
    Path_train = '../RCSP_Toolbox_GPL/MI_Data_Cleaned/CNS_MI_Data_Clean/data_seperate/train/ ';
    Path_test = '../RCSP_Toolbox_GPL/MI_Data_Cleaned/CNS_MI_Data_Clean/data_seperate/test/ ';
    filename1 = cell2mat(strcat(Path_train, '_train' , name(l))) ;
    filename2 = cell2mat(strcat(Path_test, '_test', name(l))) ;
    length_train = length(1:2:length(allsegment));
    length_test = length(2:2:length(allsegment));
    a = [];
    save(filename1,'a');
    save(filename2,'a');
     for k=2:2:length(allsegment)
           save(filename1,allsegment{k},'-append');
           save(filename2,allsegment{k-1},'-append');    
     end
aa = who(matObj);
clear(aa{:})
end