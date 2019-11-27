    folderpath_to_combine = '../RCSP_Toolbox_GPL/MI_Data_Cleaned/CNS_MI_Data_Clean/data_seperate/to_combine';
    folderpath_combined = '../RCSP_Toolbox_GPL/MI_Data_Cleaned/CNS_MI_Data_Clean/data_seperate/combined/ ';
    folderpath_to_combine = fullfile(folderpath_to_combine, '**');    % What is the meaning of "/**/" ???
    filelist_to_combine   = dir(folderpath_to_combine);
    name_to_combine       = {filelist_to_combine.name};
    name_to_combine       = name_to_combine(~strncmp(name_to_combine, '.', 1));
    nbSubjects = length(name_to_combine); 
    allsegment_to_combine = [];
    filename_combined = cell2mat(strcat(folderpath_combined, '_combined' , name_to_combine(1))) ;
    
    a = [];
    save(filename_combined,'a');
    
for l= (1:1:length(name_to_combine))
    
    load(cell2mat(name_to_combine(l))) 
    matObj_to_combine = matfile(cell2mat(name_to_combine(l)));
    allsegment_to_combine = who(matObj_to_combine, '*');    

    
     for k=1:1:length(allsegment_to_combine)
         name_old = allsegment_to_combine{k};
         %append name of allsegment_to_combine{k} with "_l" %
         str = sprintf('%s_%d', (allsegment_to_combine{k}),l);
         name_new = str;
         variable_data = eval(allsegment_to_combine{k});
         assignin('base',name_new,variable_data) ; 
         save(filename_combined,name_new ,'-append');              
     end
aa = who(matObj_to_combine);
clear(aa{:})
end
