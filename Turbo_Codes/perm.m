function y = perm(x, rand_perm)
for i =1:length(rand_perm)
    y(i) = x(rand_perm(i));
end
end
