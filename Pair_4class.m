%4 class MI classifier by Nikhil Garg and Mohit Patil using OVA

function result_4class =  Pair_4class(segment)
sub_no = 14;
classify = zeros(1,6);
load('allEEGSignals_bak.mat')
allEEGSignals_copy = allEEGSignals_bak ;

allEEGSignals = change_data(allEEGSignals_copy,[1 2], 3:6);
save('..\RCSP_Toolbox_GPL\allEEGSignals.mat','allEEGSignals');
[results, ~] = online_csp(segment,2,'WTR_CSP',3:6,[1 2],3,sub_no,8,30);
classify(1) = results.classes;
delete ('..\RCSP_Toolbox_GPL\allEEGSignals.mat');

allEEGSignals = change_data(allEEGSignals_copy,[1 3], 3:6);
save('..\RCSP_Toolbox_GPL\allEEGSignals.mat','allEEGSignals');
[results, ~] = online_csp(segment,2,'WTR_CSP',3:6,[1 3],3,sub_no,8,30);
classify(2) = results.classes;
delete ('..\RCSP_Toolbox_GPL\allEEGSignals.mat');

allEEGSignals = change_data(allEEGSignals_copy,[1 4], 3:6);
save('..\RCSP_Toolbox_GPL\allEEGSignals.mat','allEEGSignals');
[results, ~] = online_csp(segment,2,'WTR_CSP',3:6,[1 4],3,sub_no,8,30);
classify(3) = results.classes;
delete ('..\RCSP_Toolbox_GPL\allEEGSignals.mat');

allEEGSignals = change_data(allEEGSignals_copy,[2 3], 3:6);
save('..\RCSP_Toolbox_GPL\allEEGSignals.mat','allEEGSignals');
[results, ~] = online_csp(segment,2,'WTR_CSP',3:6,[2 3],3,sub_no,8,30);
classify(4) = results.classes;
delete ('..\RCSP_Toolbox_GPL\allEEGSignals.mat');

allEEGSignals = change_data(allEEGSignals_copy,[2 4], 3:6);
save('..\RCSP_Toolbox_GPL\allEEGSignals.mat','allEEGSignals');
[results, ~] = online_csp(segment,2,'WTR_CSP',3:6,[2 4],3,sub_no,8,30);
classify(5) = results.classes;
delete ('..\RCSP_Toolbox_GPL\allEEGSignals.mat');

allEEGSignals = change_data(allEEGSignals_copy,[3 4], 3:6);
save('..\RCSP_Toolbox_GPL\allEEGSignals.mat','allEEGSignals');
[results, ~] = online_csp(segment,2,'WTR_CSP',3:6,[3 4],3,sub_no,8,30);
classify(6) = results.classes;
delete ('..\RCSP_Toolbox_GPL\allEEGSignals.mat');

result_4class = mode(classify);
end


