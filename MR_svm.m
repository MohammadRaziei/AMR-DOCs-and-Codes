clear; clc;
load('signal_type_snr.mat');
N = 0.2;
size_test = floor(sam_size*N);
out = multisvm(Cum(1:(sam_size-size_test),:),types_R,Cum((size_test+1):sam_size , :) );