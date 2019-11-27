%4 class MI classifier by Nikcool and MoPa using binary pairs One vs Rest
function [results_4class, score_results] = OVR_4class(segment)
sub_no = 14; %make this into an input argument
classify = zeros(1,4);
load('allEEGSignals_bak.mat')
results_4class = classify;
score= classify;
allEEGSignals_OVR_bak = change_data_OVR(3:6);
allEEGSignals_copy = allEEGSignals_OVR_bak ;

allEEGSignals = change_data(allEEGSignals_copy,[1 5], 3:6);
save('..\RCSP_Toolbox_GPL\allEEGSignals.mat','allEEGSignals');
[results, ~] = online_csp(segment,2,'WTR_CSP',3:6,[1 5],3,sub_no,8,30);
classify(1) = results.classes;
score(1) = results.output;
delete ('..\RCSP_Toolbox_GPL\allEEGSignals.mat');

allEEGSignals = change_data(allEEGSignals_copy,[2 6], 3:6);
save('..\RCSP_Toolbox_GPL\allEEGSignals.mat','allEEGSignals');
[results, ~] = online_csp(segment,2,'WTR_CSP',3:6,[2 6],3,sub_no,8,30);
classify(2) = results.classes;
score(2) = results.output;
delete ('..\RCSP_Toolbox_GPL\allEEGSignals.mat');

allEEGSignals = change_data(allEEGSignals_copy,[3 7], 3:6);
save('..\RCSP_Toolbox_GPL\allEEGSignals.mat','allEEGSignals');
[results, ~] = online_csp(segment,2,'WTR_CSP',3:6,[3 7],3,sub_no,8,30);
classify(3) = results.classes;
score(3) = results.output;
delete ('..\RCSP_Toolbox_GPL\allEEGSignals.mat');

allEEGSignals = change_data(allEEGSignals_copy,[4 8], 3:6);
save('..\RCSP_Toolbox_GPL\allEEGSignals.mat','allEEGSignals');
[results, ~] = online_csp(segment,2,'WTR_CSP',3:6,[4 8],3,sub_no,8,30);
classify(4) = results.classes;
score(4) = results.output;
delete ('..\RCSP_Toolbox_GPL\allEEGSignals.mat');

results_4class = classify;
classify;
m = 0;
score_results = zeros(1,5);
[m,results_ovr] = min(score);
score_results(1) = score(1);
score_results(2) = score(2);
score_results(3) = score(3);
score_results(4) = score(4);
score_results(5) = results_ovr;
end
