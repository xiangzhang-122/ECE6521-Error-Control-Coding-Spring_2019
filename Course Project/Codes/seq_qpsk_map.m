% x is code word containing even bits
function gg = seq_qpsk_map(x)
len =length(x);
temp = zeros(1,len/2);
for i =1:2:len
    temp((i+1)/2) = qpsk_map(x(i:i+1));
end
gg = temp;
end
