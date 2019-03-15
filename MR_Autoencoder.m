load('signal_type_snr.mat');
% r = Signal_R;
%% 
temp2 = Signal_R.^2;
tempA = abs( Signal_R ).^2;
C_20 = mean( temp2 );
C_21 = mean( tempA );
C_40 = mean( Signal_R .^4)-3 * C_20 .^2;
C_41 = mean(temp2.*tempA)-3 * C_20 .* C_21;
C_42 = mean(temp2.^2) - abs(C_20).^2 - 2 * C_21 .^2;
C = [C_40',C_41',C_42'];
% Data = [real(C) , imag(C) ]; 
Data = abs(C);
%%
data=DataClasses.DataStore();
data.valueType=ValueType.gaussian;
data.trainData = Data;
data.testData = Data;
data.validationData = Data;
dbn=DBN();

dbn.dbnType='autoEncoder';
% RBM1
rbmParams=RbmParameters(1000,ValueType.binary);
rbmParams.maxEpoch=50;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);

dbn.train(data);
% dbn.reconstructData(data.testData(n,:),1)
dbn.backpropagation(data);