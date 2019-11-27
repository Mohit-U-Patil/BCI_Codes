warning('off','all')
clean_up_script;
read_data(1:4, 3:6);

csp_algo = {'DL_CSP_auto'};
classifier = {'RLDA'};

for i=1:length(classifier)
    for j=1:length(csp_algo)
        folder_run_calculate_result_4class_OVR_OVO(classifier{i},csp_algo{j} ,3:6, 3, 8, 30, 'sym9', 6, 'SURE', 'Soft', 'LevelIndependent')
    end
end


% clean_up_script;
% read_data(1:4, 1:32);
% 
% for i=1:length(classifier)
%     for j=1:length(csp_algo)
%         folder_run_calculate_result_4class_OVR_OVO(classifier{i},csp_algo{j} ,1:32, 3, 8, 30, 'sym9', 6, 'SURE', 'Soft', 'LevelIndependent')
%     end
% end