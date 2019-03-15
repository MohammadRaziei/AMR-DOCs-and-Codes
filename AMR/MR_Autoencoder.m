clear;clc;
addpath('..\DeeBNetV3.2');
load('type_snr_cum.mat');
%% 
% Data = [real(C) , imag(C) ]; 
trainRatio = .7; valRatio = 0.1; testRatio = .2;
[trainInd,valInd,testInd] = dividerand(sam_size,trainRatio,valRatio,testRatio);
cols = 1:size(Cum,2);

Data = log(abs( Cum ))./ log(abs(repmat(Cum(:,2),1,size(Cum,2)) )); % normalization cumuant
% Data = abs(Cum);
TrainSet =    Data(trainInd,cols);
ValSet   =    Data(valInd ,cols);
TestSet  =    Data(testInd ,cols);
% ValSet = TestSet;
GroupTrain = types_R(trainInd,:);
GroupTest = types_R(testInd,:);

%%
data = DataClasses.DataStore();
data.valueType      =  ValueType.gaussian;
data.trainData      =  TrainSet;
data.testData       =  TestSet;
data.validationData =  ValSet;
data.normalize('meanvar');

dbn = DBN();
dbn.dbnType='autoEncoder';
% RBM1
rbmParams = RbmParameters(8,ValueType.binary);
rbmParams.maxEpoch = 1;
rbmParams.samplingMethodType = SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod = 'reconstruction';
dbn.addRBM(rbmParams);
% RBM2
rbmParams=RbmParameters(2,ValueType.binary);
rbmParams.maxEpoch=1;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);

dbn.train(data);
% dbn.reconstructData(data.testData(n,:),1)
dbn.backpropagation(data);

train_fea_extracted = dbn.getFeature(data.trainData);
test_fea_extracted = dbn.getFeature(data.testData);


out = multisvm(train_fea_extracted ,GroupTrain ,test_fea_extracted );
p = 1 - sum( out ~= GroupTest ) / numel(testInd) ;
disp( [num2str(p * 100) '%'] );
% save("autoencoder_type_snr_cum.mat",'types_R','types','SNR_R','Cum','sam_size');
save('resualt2')