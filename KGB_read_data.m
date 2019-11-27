function KGB_read_data(ch2keep, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate)
%ch2keep =  number of channels in the input datafiles
%file reader
folderpath = '../RCSP_Toolbox_GPL/MI_Data_Cleaned/CNS_MI_Data_Clean/Online_cal';
folderpath = fullfile(folderpath, '**');    % What is the meaning of "/**/" ???
folderpath_denoised = '../RCSP_Toolbox_GPL/MI_Data_Cleaned/CNS_MI_Data_Clean/denoised/';
filelist   = dir(folderpath);
name       = {filelist.name};
name       = name(~strncmp(name, '.', 1));
nbSubjects = length(name);
trainingEEGSignals = cell(nbSubjects,1);
testingEEGSignals = cell(nbSubjects,1);
allEEGSignals = cell(nbSubjects,1);
Segment_length = cell(nbSubjects,1);
nbChannels = 33; %we need here the value of standard number of electrodes in 
%any given dataset

save('../RCSP_Toolbox_GPL/name.mat','name');


for l= [1:1:length(name)]
 filename_denoised = cell2mat(strcat(folderpath_denoised, '_denoised' , name(l)));
 a = [];
 save(filename_denoised,'a');
 segment = [];
 label = [];
 subjectNo = l;
 load(cell2mat(name(l)))   
 matObj = matfile(cell2mat(name(l)));
 allsegments = who(matObj , '*'); 
 size_catalog = [];
 size_1 = [];
 size_2 = [];
 channelList = {(ch2keep)};

 for i=1:1:length(allsegments)
     t = eval((allsegments{i}));
     shape = size(t)
     if ismember(shape(1,1),nbChannels)
         
        EEGdata.c = channelList;
        EEGdata.s = 250;
        EEGdata.y = zeros(1,1);
%         EEGdata.x = zeros(shape(1,2), shape(1,1), 1); 
        EEGdata.x = zeros(shape(1,2), length(ch2keep), 1); 
        EEGdata.x(:,:,1) = t(ch2keep,:)';
        
        EEGdata_denoised = denoise_eeg_wavelet(EEGdata, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);

        name_old = allsegments{i};
        assignin('base',name_old,EEGdata_denoised.x) ; 
        save(filename_denoised,name_old ,'-append'); 
        
     else
         
        name_old = allsegments{i};
        assignin('base',name_old,eval((allsegments{i}))) ; 
        save(filename_denoised,name_old ,'-append'); 
        
     end
 end
 
% %  record all the sizes of the segments within the file.
%  for i = 1:2:length(size_catalog)
%      size_1 = vertcat(size_1, size_catalog(i,1));
%      size_2 = vertcat(size_2, size_catalog(i,2));
%  end
%  
%  %checks how many segments of interest are there
%   counter = 0;
%  for k=1:length(size_catalog)
%     if ismember(size_catalog(k,1),nbChannels)                    
%         counter = counter + 1;
%     end
%  end
% 
% dimention_2 = [];
% dimention_2 = unique(size_2);
% 
%  
% %  find unique dimension 2
% %  and loop over it
% %  if channel = 33
% %      if unique 1
% %          save
% %          denoise
% %          save
% %  append all uniques and save
% %  
% 
% for i = 1:1:length(dimention_2)
% nbTrials = counter;
% channelList = {(ch2keep)};
% EEGdata.c = channelList;
% EEGdata.s = 250;
% EEGdata.y = zeros(1,nbTrials);
% EEGdata.x = zeros(dimention_2(i), nbChannels, nbTrials);
%  
% t = [];
% currenttrial = 1;
%  for k=1:length(size_catalog)  
%         t = eval((allsegments{k}));   
%     if ismember(size_catalog(k,1),nbChannels)                    
%         EEGdata.x(:,:,currenttrial) = t(ch2keep,:)';
%     end
%     currenttrial = currenttrial + 1;
%  end
%  
%   for k=1:length(LeftLift)  
%         t = eval((LeftLift{k}));  
%    EEGdata.x(:,:,currenttrial) = t(ch2keep,:)';
%    currenttrial = currenttrial + 1;
%   end
%  
%    for k=1:length(RightCln)  
%         t = eval((RightCln{k}));  
%    EEGdata.x(:,:,currenttrial) = t(ch2keep,:)';
%    currenttrial = currenttrial + 1;
%    end
%  
%     for k=1:length(LeftCln)    
%         t = eval((LeftCln{k}));  
%    EEGdata.x(:,:,currenttrial) = t(ch2keep,:)';
%    currenttrial = currenttrial + 1;
%     end
%  
%  
% lengthTrain = length(1:2:length(label_sel));
% EEGdataTrain.c = channelList;
% EEGdataTrain.s = 250;
% EEGdataTrain.y = zeros(1,lengthTrain);
% EEGdataTrain.x = zeros(1250, nbChannels, lengthTrain);
% 
% 
% lengthall = length(1:1:length(label_sel));
% EEGdataall.c = channelList;
% EEGdataall.s = 250;
% EEGdataall.y = zeros(1,lengthall);
% EEGdataall.x = zeros(1250, nbChannels, lengthall);
% 
% 
% j =1;
% for i = 1:2:length(label)
%     
%  if ismember(label(i),class2keep)                    
%      EEGdataTrain.x(:,:,j) = EEGdata.x(:,:,i);
%      EEGdataTrain.y(:,j) = label(i);
%      j = j + 1;
%  end 
% end
% 
% j = 1;
% for i = 1:1:length(label)
%     
%  if ismember(label(i),class2keep)                    
%      EEGdataall.x(:,:,j) = EEGdata.x(:,:,i);
%      EEGdataall.y(:,j) = label(i);
%      j = j + 1;
%  end 
% end
% 
% lengthTest = length(2:2:length(label_sel));
% EEGdataTest.c = channelList;
% EEGdataTest.s = 250;
% EEGdataTest.y = zeros(1,lengthTest);
% EEGdataTest.x = zeros(1250, nbChannels, lengthTest);
% j = 1;
% for i = 2:2:length(label) 
%     
%     if ismember(label(i),class2keep)
%         EEGdataTest.x(:,:,j) = EEGdata.x(:,:,i);
%         EEGdataTest.y(:,j) = label(i);
%         j = j + 1;
%     end    
% end
% 
% 
% 
% trainingEEGSignals{subjectNo} = EEGdataTrain;
% testingEEGSignals{subjectNo} = EEGdataTest;
% allEEGSignals{subjectNo} = EEGdataall;

                                              
aa = who(matObj);
clear(aa{:})
end

% disp('segment numbers');
% segment_count  
% %saving the results to the appropriate matlab files
% save('../RCSP_Toolbox_GPL/trainingEEGSignals.mat','trainingEEGSignals');
% save('../RCSP_Toolbox_GPL/testingEEGSignals.mat','testingEEGSignals');
% save('../RCSP_Toolbox_GPL/allEEGSignals.mat','allEEGSignals');
% %following line to match with calculate_result_4class
% allEEGSignals_bak = allEEGSignals;
% save('../RCSP_Toolbox_GPL/allEEGSignals_bak.mat','allEEGSignals_bak');

end