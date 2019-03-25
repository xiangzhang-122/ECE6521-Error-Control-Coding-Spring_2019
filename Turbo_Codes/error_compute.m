function err = error_compute(x,y)
cnt=0;
for i =1: length(x)
    if x(i) ~= y(i)
        cnt=cnt+1;
    end
end
err = cnt/length(x);