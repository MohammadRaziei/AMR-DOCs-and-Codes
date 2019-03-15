%% Ready to run
addpath('.\DataGeneration\');
clc; clear; close all;
%% General Parameter
SNR       = 127000;
Mod_Type  = 1;
rolloff   = 0.3;
Fs        = 8e6   ;
SPS       = 8;
N_ISI     = 100;
modu_ind  = 0.7;
offset    = -0.01;
Fc        = 0;
Rs        = Fs/SPS   ;
n_Sym     = fix(5e5) ;
BW        = Rs*(1+rolloff)/Fs;
%% Random Signal Parameter
sam_size  = 1e5;

SNR_rand  = [ 0 , 5 , 10 , 15 , -5];

types     = [0 , 1 , 2 , 9];
types_R   = randi(4,sam_size,1);
types_str =  [ 'BPSK ' ; 'QPSK ' ; '8PSK ' ; '16QAM' ];

Signal_R  = cell(200,1);
Cum       = zeros(sam_size,10);
SNR_R     = zeros(sam_size,1);
%% Generate Signal
for i = 1:sam_size
    type_r=types(types_R(i));
    disp('Level:  '+string(i));
    
    max_snr = 4;
    if type_r == 0 % for BPSK
        max_snr = 5;
    end
    SNR_r = SNR_rand(randi(max_snr)); % rand snr and rand type
    SNR_R(i)=SNR_r;
    
    Signal_r = PSK_Signal_Generator(SNR_r , n_Sym , type_r , Fs , Rs , rolloff , Fc , N_ISI) ;

    run calc_cumulant;
    Cum(i,:) = [C_20,C_21,C_40,C_41,C_42,C_80,C_81,C_82,C_83,C_84];
    disp(['Mode: ',types_str(types_R(i),:),',  SNR : ',num2str(SNR_r)]);


end
%% The End
save("type_snr_cum.mat",'types_R','types','SNR_R','Cum','sam_size');
disp('Finished');
