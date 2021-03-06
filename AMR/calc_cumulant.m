    M_20 = mean(Signal_r.^2);
    M_21 = mean(abs(Signal_r.^2));
    M_40 = mean(Signal_r.^4);
    M_41 = mean((Signal_r.^2).*abs(Signal_r.^2));
    M_42 = mean(abs(Signal_r.^4));
    M_80 = mean(Signal_r.^8);
    M_81 = mean((Signal_r.^6).*abs(Signal_r.^2));
    M_82 = mean((Signal_r.^4).*abs(Signal_r.^4));
    M_83 = mean((Signal_r.^2).*abs(Signal_r.^6));
    M_84 = mean(abs(Signal_r.^8));
    
%% Order 2
    C_20 = M_20;
    C_21 = M_21;
%% Order 4
    C_40 = M_40 -3 * C_20 .^2;
    C_41 = M_41 * C_20 .* C_21;
    C_42 = M_42 - abs(C_20).^2 - 2 * C_21 .^2;
       
 %% Order 8
    C_80 = M_80 -35.* M_40 .^2 -630.* M_21 .^2 +420 .* (M_20 .^2) .*(M_40 .^2);
    C_81 = M_81 -35.*M_40.*M_41 - 630.*M_20.^2 +210.*M_40.*M_21.*M_20 +210.*M_20.^2.*M_41;
    C_82 = M_82 -15.*M_40.*M_42 + 20.*M_20.^2 +30.*M_40.*M_20.^2 +60.*M_40.*M_21.^2 +240.*M_41.*M_21.*M_20 +90.*M_42.*M_20.^2;
    C_83 = M_83 -5.*M_40.*M_42 -30.*M_41.*M_42 +90.*M_41.*M_20.^2 + 120.*M_41.*M_21.^2 +180.*M_42.*M_21.*M_20 +30.*M_40.*M_21.*M_20 -270.*M_21.*M_20.^3 -360.*M_21.^3.*M_20;
    C_84 = M_84 -18.*M_42.^2 -16.*M_41.^2 -M_40.^2 -144.*M_21.^4 -432.*M_20^2.*M_21.^2 +125.*M_40.*M_20.^2 +96.*M_41.*M_42.*M_20 +144.*M_42.*M_21.^2 +72.*M_42.*M_20.^2 +96.*M_41.*M_20.*M_21;