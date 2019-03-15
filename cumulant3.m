function cum = cumulant3(mat)
% M =@(s,p,q) mean(s.^(p-q).* conj(s) .^q);    
cum = 0+0i;
n = size(mat,2);

base = n+1;
temp = unique(nchoosek([zeros(1,n-1), 1:n ] , n) , 'rows' );
temp = temp * (base.^((size(temp,2)-1):-1:0))';
dict = inf*ones(length(temp),2);
dict(:,1) = temp;


for q = 1:n
   perm = unique( perms([ 1:n zeros(1,q-1)]) , 'rows'); 
   Sum = 0;
    for p = 1:size(perm,1)
        [sl,Size] = slicer( perm(p,:) ,0);
        if sum(Size == 0)
            continue;
        end
        Exp = 1;
        fac = zeros(n-q+1 , 1);

        for i = 1:length(sl)
            temp = sort(sl{i},2);
            [found,~] = find( ( temp * (base.^((size(temp,2)-1):-1:0))') == dict );
            if dict(found,2) == inf
                dict(found,2) = mean(prod( mat(:,temp) ,2 ));
            end
            Exp = Exp * dict(found,2);
            fac(Size(i)) = fac(Size(i)) + 1;
        end

        Sum = Sum + Exp / ( prod(factorial(Size))  *   prod(factorial(fac)));
        
    end
    cum = cum +((-1)^(q-1)) * Sum / q;
end






















end