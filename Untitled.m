    M_20 = mean(y.^2);
    M_21 = mean(abs(y.^2));
    M_40 = mean(y.^4);
    M_41 = mean((y.^2).*abs(y.^2));
    M_42 = mean(abs(y.^4));
    M_80 = mean(y.^8);
    M_81 = mean((y.^6).*abs(y.^2));
    M_82 = mean((y.^4).*abs(y.^4));
    M_83 = mean((y.^2).*abs(y.^6));
    M_84 = mean(abs(y.^8));
    
    C_20 = M_20;
    C_21 = M_21;
    C_40 = M_40 -3 * C_20 .^2;
    C_41 = M_41 * C_20 .* C_21;
    C_42 = M_42 - abs(C_20).^2 - 2 * C_21 .^2;
    
    C_80 = M_80 - 35.* M_40 .^2 -630.* M_21 .^2 +420 .* (M_20 .^2) .*(M_40 .^2);
    C_81 = M_81;
    C_82 = M_82;
    C_83 = M_83;
    C_84 = M_84;