function [out,Size] = slicer(vec,o)
f = find(vec == o);
n = length(f);
out = cell(n+1,1); 
Size = zeros(n+1,1);

if n > 0
   temp = vec(1:f(1)-1);
   out{1} = temp;
   Size(1) = length(temp);
end
for i=2: n
    temp = vec(f(i-1)+1 : f(i)-1);
    out{i} =  temp;
    Size(i) = length(temp);
end
if n == 0
    temp = vec(1:end);
    out{n+1} = temp;
    Size(n+1) = length(temp);
else
    temp = vec(f(n)+1:end);
    out{n+1} = temp;
    Size(n+1) = length(temp);
end



end