% combine two output streams of rate 1/2 into one codeword
function code = combine(a,b)
len = length(a);
for i =1:len
    code(2*i-1) = a(i);
    code(2*i)= b(i);
end
end