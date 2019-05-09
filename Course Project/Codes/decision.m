function y = decision(x)
len = length(x);
for i = 1: len
    if x(i)>=0
        y(i) = 1;
    else
        y(i)= 0;
    end
end
end
