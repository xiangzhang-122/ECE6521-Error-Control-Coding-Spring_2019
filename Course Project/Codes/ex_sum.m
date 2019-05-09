% sum(x) - x_id
function y = ex_sum(x, id)
len = length(x);
y =0;
for j = 1:len
    if j ~= id
        temp = x(j);
    else 
        temp =0;
    end
    y = y + temp;
end
end
        
    
