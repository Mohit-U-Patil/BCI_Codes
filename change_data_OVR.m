%by Nikcool and MoPa for OVA
%this script runs independently. Need to run once and new data collection
%is saved
%this function must run after read_data[1 4]. for this function, allEEGSignals
%must be calculated with all classes and saved. this function makes 4 new classes,
%RestData1, RestData2, RestData3, RestData4 each corresponding to comibined
%classes. RestData1 = Class 2+3+4, RestData2 = Class 1+3+4, etc.

function changed_data_OVR =  change_data_OVR(ch2keep)

% sub_no = 14;
classify = zeros(1,4);
load('allEEGSignals_bak.mat')

allEEGSignals_OVR = allEEGSignals_bak ;

channelList = {(ch2keep)};
nbSubjects = length(allEEGSignals_OVR);
changed_data_OVR = cell(nbSubjects,1);
% 
% EEGSignals_class1 = change_data(allEEGSignals_OVR, 1, 3:6);
% EEGSignals_class2 = change_data(allEEGSignals_OVR, 2, 3:6);
% EEGSignals_class3 = change_data(allEEGSignals_OVR, 3, 3:6);
% EEGSignals_class4 = change_data(allEEGSignals_OVR, 4, 3:6);
% save('..\RCSP_Toolbox_GPL\EEGSignals_class1.mat','EEGSignals_class1');
% load('EEGSignals_class1.mat')
% save('..\RCSP_Toolbox_GPL\EEGSignals_class2.mat','EEGSignals_class2');
% load('EEGSignals_class2.mat')
% save('..\RCSP_Toolbox_GPL\EEGSignals_class3.mat','EEGSignals_class3');
% load('EEGSignals_class3.mat')
% save('..\RCSP_Toolbox_GPL\EEGSignals_class4.mat','EEGSignals_class4');
% load('EEGSignals_class4.mat')

for subject = 1:1:length(allEEGSignals_OVR)
    label = allEEGSignals_OVR{subject}.y;
    
    %saving RestData1 in class 5 label
    j = length(allEEGSignals_OVR{subject}.y);
    for i = 1:1:length(label)

        if ismember(label(i),[2 3 4])                    
             allEEGSignals_OVR{subject}.x(:,:,j+1) = allEEGSignals_OVR{subject}.x(:,:,i);
%            allEEGSignals_OVR{subject}.x(:,:,j+1) = cat(3, allEEGSignals_OVR{subject}.x, EEGSignals_class2{subject}.x, EEGSignals_class3{subject}.x, EEGSignals_class4{subject}.x);
%            concatenatedSignals.x = cat(3,eegDataSet_A.x, eegDataSet_B.x);
             allEEGSignals_OVR{subject}.y(:,j+1) = 5;
             allEEGSignals_OVR{subject}.c = channelList;
             allEEGSignals_OVR{subject}.s = 250;
             j = j + 1;
        end 
    end
    
        %saving RestData2 in class 6 label
    j = length(allEEGSignals_OVR{subject}.y);
    for i = 1:1:length(label)

        if ismember(label(i),[1 3 4])                    
             allEEGSignals_OVR{subject}.x(:,:,j+1) = allEEGSignals_OVR{subject}.x(:,:,i);
%            allEEGSignals_OVR{subject}.x(:,:,j+1) = cat(3, allEEGSignals_OVR{subject}.x, EEGSignals_class2{subject}.x, EEGSignals_class3{subject}.x, EEGSignals_class4{subject}.x);
%            concatenatedSignals.x = cat(3,eegDataSet_A.x, eegDataSet_B.x);
             allEEGSignals_OVR{subject}.y(:,j+1) = 6;
             allEEGSignals_OVR{subject}.c = channelList;
             allEEGSignals_OVR{subject}.s = 250;
             j = j + 1;
        end 
    end
    
           %saving RestData3 in class 7 label
    j = length(allEEGSignals_OVR{subject}.y);
    for i = 1:1:length(label)

        if ismember(label(i),[2 3 4])                    
             allEEGSignals_OVR{subject}.x(:,:,j+1) = allEEGSignals_OVR{subject}.x(:,:,i);
%            allEEGSignals_OVR{subject}.x(:,:,j+1) = cat(3, allEEGSignals_OVR{subject}.x, EEGSignals_class2{subject}.x, EEGSignals_class3{subject}.x, EEGSignals_class4{subject}.x);
%            concatenatedSignals.x = cat(3,eegDataSet_A.x, eegDataSet_B.x);
             allEEGSignals_OVR{subject}.y(:,j+1) = 7;
             allEEGSignals_OVR{subject}.c = channelList;
             allEEGSignals_OVR{subject}.s = 250;
             j = j + 1;
        end 
    end
    
           %saving RestData4 in class 8 label
    j = length(allEEGSignals_OVR{subject}.y);
    for i = 1:1:length(label)

        if ismember(label(i),[2 3 4])                    
             allEEGSignals_OVR{subject}.x(:,:,j+1) = allEEGSignals_OVR{subject}.x(:,:,i);
%            allEEGSignals_OVR{subject}.x(:,:,j+1) = cat(3, allEEGSignals_OVR{subject}.x, EEGSignals_class2{subject}.x, EEGSignals_class3{subject}.x, EEGSignals_class4{subject}.x);
%            concatenatedSignals.x = cat(3,eegDataSet_A.x, eegDataSet_B.x);
             allEEGSignals_OVR{subject}.y(:,j+1) = 8;
             allEEGSignals_OVR{subject}.c = channelList;
             allEEGSignals_OVR{subject}.s = 250;
             j = j + 1;
        end 
    end   
    
    %saving Right directional data in class 9 label
    j = length(allEEGSignals_OVR{subject}.y);
    for i = 1:1:length(label)

        if ismember(label(i),[1 3])                    
             allEEGSignals_OVR{subject}.x(:,:,j+1) = allEEGSignals_OVR{subject}.x(:,:,i);
%            allEEGSignals_OVR{subject}.x(:,:,j+1) = cat(3, allEEGSignals_OVR{subject}.x, EEGSignals_class2{subject}.x, EEGSignals_class3{subject}.x, EEGSignals_class4{subject}.x);
%            concatenatedSignals.x = cat(3,eegDataSet_A.x, eegDataSet_B.x);
             allEEGSignals_OVR{subject}.y(:,j+1) = 9;
             allEEGSignals_OVR{subject}.c = channelList;
             allEEGSignals_OVR{subject}.s = 250;
             j = j + 1;
        end 
    end   
    
    %saving Left directional data in class 10 label
    j = length(allEEGSignals_OVR{subject}.y);
    for i = 1:1:length(label)

        if ismember(label(i),[2 4])                    
             allEEGSignals_OVR{subject}.x(:,:,j+1) = allEEGSignals_OVR{subject}.x(:,:,i);
%            allEEGSignals_OVR{subject}.x(:,:,j+1) = cat(3, allEEGSignals_OVR{subject}.x, EEGSignals_class2{subject}.x, EEGSignals_class3{subject}.x, EEGSignals_class4{subject}.x);
%            concatenatedSignals.x = cat(3,eegDataSet_A.x, eegDataSet_B.x);
             allEEGSignals_OVR{subject}.y(:,j+1) = 10;
             allEEGSignals_OVR{subject}.c = channelList;
             allEEGSignals_OVR{subject}.s = 250;
             j = j + 1;
        end 
    end   
    
    %saving Lift action data in class 11 label
    j = length(allEEGSignals_OVR{subject}.y);
    for i = 1:1:length(label)

        if ismember(label(i),[1 2])                    
             allEEGSignals_OVR{subject}.x(:,:,j+1) = allEEGSignals_OVR{subject}.x(:,:,i);
%            allEEGSignals_OVR{subject}.x(:,:,j+1) = cat(3, allEEGSignals_OVR{subject}.x, EEGSignals_class2{subject}.x, EEGSignals_class3{subject}.x, EEGSignals_class4{subject}.x);
%            concatenatedSignals.x = cat(3,eegDataSet_A.x, eegDataSet_B.x);
             allEEGSignals_OVR{subject}.y(:,j+1) = 11;
             allEEGSignals_OVR{subject}.c = channelList;
             allEEGSignals_OVR{subject}.s = 250;
             j = j + 1;
        end 
    end   
    
    %saving Clench action data in class 12 label
    j = length(allEEGSignals_OVR{subject}.y);
    for i = 1:1:length(label)

        if ismember(label(i),[3 4])                    
             allEEGSignals_OVR{subject}.x(:,:,j+1) = allEEGSignals_OVR{subject}.x(:,:,i);
%            allEEGSignals_OVR{subject}.x(:,:,j+1) = cat(3, allEEGSignals_OVR{subject}.x, EEGSignals_class2{subject}.x, EEGSignals_class3{subject}.x, EEGSignals_class4{subject}.x);
%            concatenatedSignals.x = cat(3,eegDataSet_A.x, eegDataSet_B.x);
             allEEGSignals_OVR{subject}.y(:,j+1) = 12;
             allEEGSignals_OVR{subject}.c = channelList;
             allEEGSignals_OVR{subject}.s = 250;
             j = j + 1;
        end 
    end   
end
changed_data_OVR = allEEGSignals_OVR;
end
