
function Rx_Samples_IF = PSK_Signal_Generator(SNR,n_Sym,Mod_Type,Fs,Rs,rolloff,Fc,n_ISI)

% SNR      = inf   ;
% n_Sym    = 4096  ;
% Mod_Type = 9     ;
% Fs       = 250e6 ;
% Rs       = 50e6  ;
% rolloff  = 0.5   ;
% Fc       = 50e6  ;


n_Sym_True = n_Sym ;

switch Mod_Type
    case 0                      % 'BPSK'
        modOrder       = 2;
        Symbol_idx     = randi(modOrder,n_Sym_True,1);
        Samples_BPSK   = exp(1j*(2*pi*(0:1)/2)).';
        Symbols        = Samples_BPSK(Symbol_idx);

    case 1                      % 'QPSK'
        modOrder       = 4;
        Symbol_idx     = randi(modOrder,n_Sym_True,1);
        Samples_QPSK   = exp(1j*(2*pi*(0:3)/4+pi/4)).';
        Symbols        = Samples_QPSK(Symbol_idx);

    case 2                      % '8PSK'
        modOrder       = 8;
        Symbol_idx     = randi(modOrder,n_Sym_True,1);
        Samples_8PSK   = exp(1j*(2*pi*(0:7)/8+pi/8)).';
        Symbols        = Samples_8PSK(Symbol_idx);
    
    case 3                      % '16APSK'
        gamma          = 2.75;
        r2             = 1;
        r1             = r2/gamma;
        modOrder       = 16 ;
        Symbol_idx     = randi(modOrder,n_Sym_True,1);
        Samples_QPSK   = exp(1j*(2*pi*(0:3 )/4 +pi/4 )).';
        Samples_12PSK  = exp(1j*(2*pi*(0:11)/12+pi/12)).';
        Samples_16APSK = [r1*Samples_QPSK ; r2*Samples_12PSK] ;
        Symbols        = Samples_16APSK(Symbol_idx);
        
    case 4                      % '32APSK'
        gamma2         = 1.54;
        gamma1         = 4.33;
        r3             = 1;
        r2             = r3/gamma2;
        r1             = r3/gamma1;
        modOrder       = 32 ;
        Symbol_idx     = randi(modOrder,n_Sym_True,1);
        Samples_QPSK   = exp(1j*(2*pi*(0:3 )/4 +pi/4 )).' ;
        Samples_12PSK  = exp(1j*(2*pi*(0:11)/12      )).' ;
        Samples_16PSK  = exp(1j*(2*pi*(0:15)/16+pi/16)).' ;
        Samples_32APSK = [r1*Samples_QPSK ; r2*Samples_12PSK ; r3*Samples_16PSK] ;
        Symbols        = Samples_32APSK(Symbol_idx);

    case 9                      % '16QAM'
        modOrder = 16 ;
        Symbol_idx     = randi(modOrder,n_Sym_True,1);
        Samples_16QAM  = reshape(repmat(linspace(-1,1,4),4,1),[],1) + 1j*reshape(repmat(linspace(-1,1,4),1,4),[],1) ;
        Symbols        = Samples_16QAM(Symbol_idx);

    case 11                      % '64QAM'
        modOrder = 64 ;
        Symbol_idx     = randi(modOrder,n_Sym_True,1);
        Samples_64QAM  = reshape(repmat(linspace(-1,1,8),8,1),[],1) + 1j*reshape(repmat(linspace(-1,1,8),1,8),[],1) ;
        Symbols        = Samples_64QAM(Symbol_idx);

    case 33                      % 'OQPSK'
        modOrder       = 4;
        Symbol_idx     = randi(modOrder,n_Sym_True,1);
        Samples_OQPSK   = exp(1j*(2*pi*(0:3)/4+pi/4)).';
        Symbols        = Samples_OQPSK(Symbol_idx);
        
    case 41                      % 'pi/2-DBPSK'
        modOrder       = 2;
        Samples_BPSK   = exp(1j*(2*pi*(0:1)/2)).';
        Symbol_idx_1   = randi(modOrder,n_Sym_True/2,1);
        Symbol_idx_2   = randi(modOrder,n_Sym_True/2,1);
        Symbols_1      = Samples_BPSK(Symbol_idx_1);
        Symbols_2      = Samples_BPSK(Symbol_idx_2)*exp(1j*pi/2);
        Symbols        = reshape([Symbols_1 , Symbols_2].' ,[],1) ;

    case 42                      % 'pi/4-DQPSK'
        modOrder       = 4;
        Samples_QPSK   = exp(1j*(2*pi*(0:3)/4+pi/4)).';
        Symbol_idx_1   = randi(modOrder,n_Sym_True/2,1);
        Symbol_idx_2   = randi(modOrder,n_Sym_True/2,1);
        Symbols_1      = Samples_QPSK(Symbol_idx_1);
        Symbols_2      = Samples_QPSK(Symbol_idx_2)*exp(1j*pi/4);
        Symbols        = reshape([Symbols_1 , Symbols_2].' ,[],1) ;

    otherwise
        Symbols        = zeros(n_Sym_True+60,1) ;
end


SPS = Fs/Rs ; % Sample Per Symbol

%--------------------------------------------------------------------------
%-----------  Square Root Raised Cosine Filter Design  --------------------
%--------------------------------------------------------------------------
% rolloff = 0.5 ;
% SPS     = 5   ;
% n_ISI   = 40  ;

n       = linspace(-n_ISI/2,n_ISI/2,n_ISI*SPS+1) ;
rrcFilt = zeros(size(n)) ;

for iter = 1:length(n)
    if n(iter) == 0
        rrcFilt(iter) = 1 - rolloff + 4*rolloff/pi ;
        
    elseif abs(n(iter)) == 1/4/rolloff
        rrcFilt(iter) = rolloff/sqrt(2)*((1+2/pi)*sin(pi/4/rolloff)+(1-2/pi)*cos(pi/4/rolloff)) ;
        
    else
        rrcFilt(iter) = (4*rolloff/pi)/(1-(4*rolloff*n(iter)).^2) * (cos((1+rolloff)*pi*n(iter)) + sin((1-rolloff)*pi*n(iter))/(4*rolloff*n(iter))) ;
    end
end

% rrcFilt = rrcFilt/max(abs(rrcFilt)) ;

% Pulseshape     = fdesign.pulseshaping(SPS,'Square Root Raised Cosine','nSym,Beta',n_ISI,rolloff);
% PulseshapeFilt = design(Pulseshape);
% rrcFilt        = PulseshapeFilt.Numerator;
% rrcFilt        = rrcFilt/max(abs(rrcFilt)) ;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

Tx_Samples_bb = filter(rrcFilt,1,upsample(Symbols,SPS));
nSamp = length(Tx_Samples_bb);

if Mod_Type == 33
    Tx_Samples_bb = real(Tx_Samples_bb) + 1j* circshift(imag(Tx_Samples_bb),SPS/2) ;
end

if Fc == 0
    Tx_Samples_IF = Tx_Samples_bb ;
    noiseLog=noise_maker(nSamp,SNR,1,Fs,Rs*(1+rolloff));
else
    Tx_Samples_IF = Tx_Samples_bb.*exp(1j*2*pi*(0:length(Tx_Samples_bb)-1)'*Fc/Fs);
    noiseLog = 10^(-SNR/20)*randn(nSamp,1)/sqrt(2) ;
end
disp(['SNR = ',num2str(pow2db(1/(std(noiseLog)^2)*(Fs/(Rs*(1+rolloff)))))]);

Rx_Samples_IF = Tx_Samples_IF + noiseLog;
Rx_Samples_IF = Rx_Samples_IF/max(abs(Rx_Samples_IF)) ;

