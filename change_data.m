%4 class MI classifier by Nikcool and MoPa using OVA
%in four class classification, multiple class training signal is causing
%problems, error is CSP can be used with only 2 classes. Following block
%changes allEEGSignals into EEGSignals12,
%EEGSignals13,EEGSignals14,EEGSignals23,EEGSignals24,EEGSignals34. after
%this before calling online_csp inside Pair_4class, allEEGSignals will be
%replaced by one of the 6 EEGSignal combinations respectively before the
%call so multiclass issue is solved.

function changed_data =  change_data(allEEGSignals, class2keep, ch2keep)

allEEGSignals_original = allEEGSignals ;

channelList = {(ch2keep)};
nbSubjects = length(allEEGSignals_original);
changed_data = cell(nbSubjects,1);

for subject = 1:1:length(allEEGSignals_original)
    label = allEEGSignals_original{subject}.y;
    j = 1;
    for i = 1:1:length(label)

        if ismember(label(i),class2keep)                    
             EEGdataall.x(:,:,j) = allEEGSignals_original{subject}.x(:,:,i);
             EEGdataall.y(:,j) = label(i);
             EEGdataall.c = channelList;
             EEGdataall.s = 250;
             j = j + 1;
        end 
    end
changed_data{subject} = EEGdataall;
end
end
