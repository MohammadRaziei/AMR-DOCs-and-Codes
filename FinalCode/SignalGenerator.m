clc;clear;close all
addpath('SignalFunc\')
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
types_R = randi(4,sam_size,1);
% types : 
%         1 = BPSK
%         2 = QPSK
%         3 = 8PSK
%         4 = 16QAM 

Signal_R=cell(sam_size,1);
Cum = zeros(sam_size,10);
SNR_R=zeros(sam_size,1);
for i = 1:numel(types_R)
    type_r=types(types_R(i));
    disp('level:  '+string(i));
    
    max_snr = 4;
    if type_r == 1
        max_snr = 5;
    end
    SNR_r = SNR_rand(randi(max_snr)); % rand snr and rand type
    SNR_R(i)=SNR_r;
    

    Signal_r = PSK_Signal_Generator(SNR_r , n_Sym , type_r , Fs , Rs , rolloff , Fc , N_ISI) ;
%     if i <= 100
        Signal_R{i} = Signal_r;
%         if i == 100
%             save("signal_save.mat_2",'Signal_R');
%             clear Signal_R;
%         end
%     end
    
    
    temp2 = Signal_r.^2;
    tempA2 = abs( temp2 );
    temp4 = Signal_r .^4;
    tempA4 = abs( temp4);
    
    C_20 = mean( temp2 );
    C_21 = mean( tempA2 );
    C_40 = mean( temp4 )-3 * C_20 .^2;
    C_41 = mean( tempA2.*temp2 )-3 * C_20 .* C_21;
    C_42 = mean( tempA4 ) - abs(C_20).^2 - 2 * C_21 .^2;
    
    C_80 = mean( temp4.^2 );
    C_81 = mean( (Signal_r.^6).* tempA2);
    C_82 = mean( temp4.*tempA4 );
    C_83 = mean( temp2.*abs(Signal_r.^6) );
    C_84 = mean( tempA4 .^2);
    
    Cum(i,:) = [C_20,C_21,C_40,C_41,C_42,C_80,C_81,C_82,C_83,C_84];
    
    % Data = [real(C) , imag(C) ]; 
%     Data = abs(Cum);
    disp(type_r);
end
save("signal_type_snr.mat",'Signal_R','Cum','types_R','SNR_R','sam_size');
disp('signals are ready');