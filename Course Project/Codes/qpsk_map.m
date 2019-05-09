% x is a vector of 2 bits
function y = qpsk_map(x)
x_p = 1- 2*x;
y = i*x_p(1) + x_p(2);
% y = x_p(1) + i*x_p(2);
end
