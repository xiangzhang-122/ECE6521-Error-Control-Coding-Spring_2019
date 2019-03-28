% input x is a binary vector
function y = extract(x)
y = zeros(1, sum(x == ones(1,length(x))));
cnt = 1;
for i = 1: length(x)
    if x(i)~= 0
        y(cnt) = i;
        cnt = cnt+1;
    end
end
end
    