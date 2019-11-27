function read_data_and_denoise_subject_matrix(class2keep,ch2keep,low, high, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate)

%file reader
folderpath = '../RCSP_Toolbox_GPL/MI_Data_Cleaned/CNS_MI_Data_Clean/subject_matrix';
folderpath = fullfile(folderpath, '**');    % What is the meaning of "/**/" ???
filelist   = dir(folderpath);
name       = {filelist.name};
name       = name(~strncmp(name, '.', 1));
nbSubjects = length(name);
trainingEEGSignals = cell(nbSubjects,1);
testingEEGSignals = cell(nbSubjects,1);
allEEGSignals = cell(nbSubjects,1);
Segment_length = cell(nbSubjects,1);

save('../RCSP_Toolbox_GPL/name.mat','name');


for l= [1:1:length(name)]
 segment = [];
 label = [];
 subjectNo = l;
 load(cell2mat(name(l)))   
 matObj = matfile(cell2mat(name(l)));
 RightLift = who(matObj, 'RightImg*');
 LeftLift = who(matObj, 'LeftImg*'); 
 RightCln = who(matObj, 'RightclenchImg*');
 LeftCln = who(matObj, 'LeftclenchImg*');
 %class2keep is an array of 2 classes
 disp(['Subject Name: ' name(l) ]);
 disp(['Number of segments- RightLift: ' num2str(length(RightLift)) ]);
 disp(['Number of segments- LeftLift: ' num2str(length(LeftLift)) ]);
 disp(['Number of segments- RightCln: ' num2str(length(RightCln)) ]);
 disp(['Number of segments- LeftCln: ' num2str(length(LeftCln)) ]);
max_length = max([length(RightLift) length(LeftLift) length(RightCln) length(LeftCln)]);
segment_count = zeros(nbSubjects,5);
segment_count(l,1) = length(RightLift); 
segment_count(l,2) = length(LeftLift); 
segment_count(l,3) = length(RightCln); 
segment_count(l,4) = length(LeftCln); 
segment_count(l,5) = length(RightLift) + length(LeftLift) + length(RightCln) + length(LeftCln); 

   

nbChannels = length(ch2keep);
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
 
 
 
 label_sel = [];
 for k=1:length(label)
 if ismember(label(k),class2keep)                    
    label_sel = vertcat(label(k),label_sel);
 end
 end

 
nbTrials = length(label_sel);
channelList = {(ch2keep)};
EEGdata.c = channelList;
EEGdata.s = 250;
EEGdata.y = zeros(1,nbTrials);
EEGdata.x = zeros(1250, nbChannels, nbTrials);
 
t = [];
currenttrial = 1;
 for k=1:length(RightLift)  
        t = eval((RightLift{k}));   
   EEGdata.x(:,:,currenttrial) = t(ch2keep,:)';
   currenttrial = currenttrial + 1;
 end
 
  for k=1:length(LeftLift)  
        t = eval((LeftLift{k}));  
   EEGdata.x(:,:,currenttrial) = t(ch2keep,:)';
   currenttrial = currenttrial + 1;
  end
 
   for k=1:length(RightCln)  
        t = eval((RightCln{k}));  
   EEGdata.x(:,:,currenttrial) = t(ch2keep,:)';
   currenttrial = currenttrial + 1;
   end
 
    for k=1:length(LeftCln)    
        t = eval((LeftCln{k}));  
   EEGdata.x(:,:,currenttrial) = t(ch2keep,:)';
   currenttrial = currenttrial + 1;
    end
 
 
lengthTrain = length(1:2:length(label_sel));
EEGdataTrain.c = channelList;
EEGdataTrain.s = 250;
EEGdataTrain.y = zeros(1,lengthTrain);
EEGdataTrain.x = zeros(1250, nbChannels, lengthTrain);


lengthall = length(1:1:length(label_sel));
EEGdataall.c = channelList;
EEGdataall.s = 250;
EEGdataall.y = zeros(1,lengthall);
EEGdataall.x = zeros(1250, nbChannels, lengthall);


j =1;
for i = 1:2:length(label)
    
 if ismember(label(i),class2keep)                    
     EEGdataTrain.x(:,:,j) = EEGdata.x(:,:,i);
     EEGdataTrain.y(:,j) = label(i);
     j = j + 1;
 end 
end

j = 1;
for i = 1:1:length(label)
    
 if ismember(label(i),class2keep)                    
     EEGdataall.x(:,:,j) = EEGdata.x(:,:,i);
     EEGdataall.y(:,j) = label(i);
     j = j + 1;
 end 
end

lengthTest = length(2:2:length(label_sel));
EEGdataTest.c = channelList;
EEGdataTest.s = 250;
EEGdataTest.y = zeros(1,lengthTest);
EEGdataTest.x = zeros(1250, nbChannels, lengthTest);
j = 1;
for i = 2:2:length(label) 
    
    if ismember(label(i),class2keep)
        EEGdataTest.x(:,:,j) = EEGdata.x(:,:,i);
        EEGdataTest.y(:,j) = label(i);
        j = j + 1;
    end    
end



trainingEEGSignals{subjectNo} = EEGdataTrain;
testingEEGSignals{subjectNo} = EEGdataTest;
allEEGSignals{subjectNo} = EEGdataall;

                                              
aa = who(matObj);
clear(aa{:})
end

 for s=1:nbSubjects
     order = 10;
      
     trainingEEGSignals{s} = eegButterFilter(trainingEEGSignals{s}, low, high, order);
     testingEEGSignals{s} = eegButterFilter(testingEEGSignals{s}, low, high, order);
     allEEGSignals{s} = eegButterFilter(allEEGSignals{s}, low, high, order);
 
    trainingEEGSignals{s} = denoise_eeg_wavelet(trainingEEGSignals{s}, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);
    testingEEGSignals{s} = denoise_eeg_wavelet(testingEEGSignals{s}, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);
    allEEGSignals{s} = denoise_eeg_wavelet(allEEGSignals{s}, mother_wavelet, decomposition_level, denoising_method, ThresholdRule, NoiseEstimate);
 end

disp('segment numbers');
segment_count  
%saving the results to the appropriate matlab files
save('../RCSP_Toolbox_GPL/trainingEEGSignals.mat','trainingEEGSignals');
save('../RCSP_Toolbox_GPL/testingEEGSignals.mat','testingEEGSignals');
save('../RCSP_Toolbox_GPL/allEEGSignals.mat','allEEGSignals');
%following line to match with calculate_result_4class
allEEGSignals_bak = allEEGSignals;
save('../RCSP_Toolbox_GPL/allEEGSignals_bak.mat','allEEGSignals_bak');

end