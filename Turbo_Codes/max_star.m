function z = max_star(x)   % assume that x=[x_1,x_2]
if length(x)==0
    z= 0;
else
    tt =max(x);
    sum=0;
    for i =1:length(x)
        sum = sum+ exp(-abs(tt-x(i)));
    end
    z = tt + log(sum);
end
end



    
