function read_data(class2keep,ch2keep)

folderpath = '..\RCSP_Toolbox_GPL\MI_Data_Cleaned\CNS_MI_Data_Clean\train';
folderpath = fullfile(folderpath, '**');    % What is the meaning of "/**/" ???
filelist   = dir(folderpath);
name       = {filelist.name};
name       = name(~strncmp(name, '.', 1));
nbSubjects = length(name);
trainingEEGSignals = cell(nbSubjects,1);
testingEEGSignals = cell(nbSubjects,1);

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
 disp(['Number of segments- RightLift: ' num2str(length(RightLift)) ]);
 disp(['Number of segments- LeftLift: ' num2str(length(LeftLift)) ]);
 disp(['Number of segments- RightCln: ' num2str(length(RightCln)) ]);
 disp(['Number of segments- LeftCln: ' num2str(length(LeftCln)) ]);


   

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


 % find max length out of all classes
 % for k=1:length(max length)
%     if k >= length(Rightlift)
%         t = eval((RightLift{k - length(RightLift)}));
%    t = eval((RightLift{k}));  
%    EEGdata.x(:,:,currenttrial) = t(ch2keep,:)';
%    currenttrial = currenttrial + 1;
%  end
 
 
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


j =1;
for i = 1:2:length(label)
    
 if ismember(label(i),class2keep)                    
     EEGdataTrain.x(:,:,j) = EEGdata.x(:,:,i);
     EEGdataTrain.y(:,j) = label(i);
     j = j + 1;
 end 
end


lengthall = length(1:1:length(label_sel));
EEGdataall.c = channelList;
EEGdataall.s = 250;
EEGdataall.y = zeros(1,lengthall);
EEGdataall.x = zeros(1250, nbChannels, lengthall);
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

%saving the results to the appropriate matlab files
save('..\RCSP_Toolbox_GPL\trainingEEGSignals.mat','trainingEEGSignals');
save('..\RCSP_Toolbox_GPL\testingEEGSignals.mat','testingEEGSignals');
save('..\RCSP_Toolbox_GPL\allEEGSignals.mat','allEEGSignals');
%following line to match with calculate_result_4class
allEEGSignals_bak = allEEGSignals;
save('..\RCSP_Toolbox_GPL\allEEGSignals_bak.mat','allEEGSignals_bak');
end