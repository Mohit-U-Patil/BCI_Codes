folderpath = '../10_subs';
folderpath = fullfile(folderpath, '**');    % What is the meaning of "/**/" ???
filelist   = dir(folderpath);
name_files       = {filelist.name};
name_files       = name(~strncmp(name_files, '.', 1));



nbSubjects = 22;
B1_accu_print = zeros(nbSubjects,1);
B2_accu_print = zeros(nbSubjects,1);
B3_accu_print = zeros(nbSubjects,1);
B4_accu_print = zeros(nbSubjects,1);
B5_accu_print = zeros(nbSubjects,1);
B6_accu_print = zeros(nbSubjects,1);
AD_accu_print = zeros(nbSubjects,1);
DA_accu_print = zeros(nbSubjects,1);
all_accuracies = cell(23, 337);
accuracy_counter = 1;

for ii=1:length(name_files)
    
        load(cell2mat(name_files(l)))              
                for n = 1:1:nbSubjects
                   all_accuracies(n+1,1)= name(n);
                    size_of_result = size(result_matrix{n});
                   
                    B1_accu_print(n,1) = result_matrix{n}(size_of_result(1),13);
                    
                    i = 0;
                    j = 0;
                    result = result_matrix{n};
                    size_of_result = size(result_matrix{n});
                    for k = 1:1:size_of_result(1)
                            if result(k,1) == result(k,18)
                                i = i + 1;
                            else
                                j = j + 1;
                            end
                    end

                    B2_accuracy = i/(i+j);
                   
                    B2_accu_print(n,1) = B2_accuracy;
                    
                                        i = 0;
                    j = 0;
                    result = result_matrix{n};
                    size_of_result = size(result_matrix{n});
                    for k = 1:1:size_of_result(1)
                            if result(k,1) == result(k,19)
                                i = i + 1;
                            else
                                j = j + 1;
                            end
                    end

                    B3_accuracy = i/(i+j);
                  
                    B3_accu_print(n,1) = B3_accuracy;
                    
                     i = 0;
                    j = 0;
                    result = result_matrix{n};
                    size_of_result = size(result_matrix{n});
                    for k = 1:1:size_of_result(1)
                            if result(k,1) == result(k,20)
                                i = i + 1;
                            else
                                j = j + 1;                        
                            end
                    end

                    B4_accuracy = i/(i+j);
                    B4_accu_print(n,1) = B4_accuracy;

                    i = 0;
                    j = 0;
                    result = result_matrix{n};
                    size_of_result = size(result_matrix{n});
                    for k = 1:1:size_of_result(1)
                            if result(k,1) == result(k,21)
                                i = i + 1;
                            else
                                j = j + 1;                            
                            end
                    end

                    B5_accuracy = i/(i+j);
                    B5_accu_print(n,1) = B5_accuracy;
                    i = 0;
                    j = 0;
                    result = result_matrix{n};
                    size_of_result = size(result_matrix{n});
                    for k = 1:1:size_of_result(1)
                            if result(k,1) == result(k,22)
                                i = i + 1;
                            else
                                j = j + 1;
                            end
                    end

                    B6_accuracy = i/(i+j);
                    B6_accu_print(n,1) = B6_accuracy;
                    
                    %disp('Direction-Action accuracy');
                    
                  
                        i = 0;
                        j = 0;
                        result = result_matrix{n};
                        size_of_result = size(result_matrix{n});
                        for k = 1:1:size_of_result(1)
                                if result(k,1) == result(k,16)
                                    i = i + 1;
                                else
                                    j = j + 1;
                                 %result(n,2) = results.labels;
                                end
                        end

                        AD_accuracy = i/(i+j);
                        AD_accu_print(n,1) = AD_accuracy;

                        i = 0;
                        j = 0;
                        result = result_matrix{n};
                        size_of_result = size(result_matrix{n});
                        for k = 1:1:size_of_result(1)
                                if result(k,1) == result(k,17)
                                    i = i + 1;
                                else
                                    j = j + 1;
                                 %result(n,2) = results.labels;
                                end
                        end
                        DA_accuracy = i/(i+j);
                        DA_accu_print(n,1) = DA_accuracy;
                end
    all_accuracies(1, accuracy_counter+1) = {strcat(classifier_name, '+', algo_name, '+', 'Block_1')};
    all_accuracies(2:23, accuracy_counter+1) = num2cell(B1_accu_print);   
    accuracy_counter = accuracy_counter+1;
    
    all_accuracies(1, accuracy_counter+1) = {strcat(classifier_name, '+', algo_name, '+', 'Block_2')};
    all_accuracies(2:23, accuracy_counter+1) = num2cell(B2_accu_print);  
    accuracy_counter = accuracy_counter+1;
     
    all_accuracies(1, accuracy_counter+1) = {strcat(classifier_name, '+', algo_name, '+', 'Block_3')};
    all_accuracies(2:23, accuracy_counter+1) = num2cell(B3_accu_print);  
    accuracy_counter = accuracy_counter+1;
     
    all_accuracies(1, accuracy_counter+1) = {strcat(classifier_name, '+', algo_name, '+', 'Block_4')};
    all_accuracies(2:23, accuracy_counter+1) = num2cell(B4_accu_print);  
    accuracy_counter = accuracy_counter+1;
    
    all_accuracies(1, accuracy_counter+1) = {strcat(classifier_name, '+', algo_name, '+', 'Block_5')};
    all_accuracies(2:23, accuracy_counter+1) = num2cell(B5_accu_print);  
    accuracy_counter = accuracy_counter+1;
    
    all_accuracies(1, accuracy_counter+1) = {strcat(classifier_name, '+', algo_name, '+', 'Block_6')};
    all_accuracies(2:23, accuracy_counter+1) = num2cell(B6_accu_print);  
    accuracy_counter = accuracy_counter+1;     
    
    all_accuracies(1, accuracy_counter+1) = {strcat(classifier_name, '+', algo_name, '+', 'Block_7_AD')};
    all_accuracies(2:23, accuracy_counter+1) = num2cell(AD_accu_print);  
    accuracy_counter = accuracy_counter+1;  
    
    all_accuracies(1, accuracy_counter+1) = {strcat(classifier_name, '+', algo_name, '+', 'Block_8_DA')};
    all_accuracies(2:23, accuracy_counter+1) = num2cell(DA_accu_print);  
    accuracy_counter = accuracy_counter+1;  
end
    
%     for i = 2:1:23
%         find maximum of (column i)
%         ismember (get all indexes of max accuracy)
%         save table column 1 subject number (row 0)
%         save table column 2 column 0 (max accuracy index related combos)
%     end
%     print table

