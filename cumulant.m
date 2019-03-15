function cum = cumulant(mat)
% M =@(s,p,q) mean(s.^(p-q).* conj(s) .^q);    
cum = 0+0i;
n = size(mat,2);

for q = 1:n
   perm = unique( perms([ 1:n zeros(1,q-1)]) , 'rows'); 
   Sum = 0;
    for p = 1:size(perm,1)
        [sl,Size] = slicer( perm(p,:) ,0);
        if sum(Size == 0)
            continue;
        end
        Exp = 1;
        temp = zeros(n-q+1 , 1);

        for i = 1:length(sl)
            Exp = Exp * mean(prod(mat(:,sl{i}),2 ));
            temp(Size(i)) = temp(Size(i)) + 1;
        end
        Sum = Sum + Exp / ( prod(factorial(Size))  *   prod(factorial(temp)));
        
    end
    cum = cum +((-1)^(q-1)) * Sum / q;
end
 





















end