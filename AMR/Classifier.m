clear; clc;
load('type_snr_cum_8e3.mat');
pt = zeros(1,10);
% for i=1:10
trainRatio = .7; valRatio = 0.1; testRatio = 0.2;
[trainInd,valInd,testInd] = dividerand(sam_size,trainRatio,valRatio,testRatio);
cols = 1:size(Cum,2);

Data = log(abs( Cum ))./ log(abs(repmat(Cum(:,2),1,size(Cum,2)) )); % normalization cumuant
% Data = abs(Cum);
Data = Data ./ repmat(max(abs(Data)) , sam_size , 1 ) ;
TrainSet = Data(trainInd,cols);
TestSet = Data(testInd , cols);

GroupTrain = types_R(trainInd,:);
GroupTest = types_R(testInd,:);
out = multisvm(TrainSet ,GroupTrain ,TestSet );
p =  1 - sum( out ~= GroupTest ) / numel(testInd);
% pt(i) = p;
% end
% disp( mean(pt) );
% hist(pt)

disp(p);