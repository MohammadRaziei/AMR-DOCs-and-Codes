clc;clear
rolloff=0.1;
N_ISI=100;
modu_ind=1;
offset=0.0;

Fs       = 8e6   ;
Fc       = 0     ;
Rs       = 1e6   ;
n_Sym    = fix(1e6) ;
BW=Rs*(1+rolloff)/Fs;

sam_size = 1000;

SNR_rand =[ 0 , 5 , 10 , 15 , -5];
types = [0 , 1 , 2 , 9];
types_R = randi(4,1,sam_size);
% types : 
%         1 = BPSK
%         2 = QPSK
%         3 = 8PSK
%         4 = 16QAM 
SNR_R=[];
Signal_R=[];
iiiiii = 1;

for type_r = types(types_R)
    disp('level:'+string(iiiiii));
    iiiiii = iiiiii+ 1;
    max_snr = 4;
    if type_r == 1
        max_snr = 5;
    end
    SNR_r = SNR_rand(randi(max_snr)); % rand snr and rand type
    SNR_R=[SNR_R,SNR_r];
    

    Signal_r = PSK_Signal_Generator(SNR_r , n_Sym , type_r , Fs , Rs , rolloff , Fc , N_ISI) ;
    Signal_R = [Signal_R,Signal_r];
    
    disp(type_r);
end
save("signal_type_snr.mat",'Signal_R','types_R','SNR_R','sam_size');
disp('signals are ready');