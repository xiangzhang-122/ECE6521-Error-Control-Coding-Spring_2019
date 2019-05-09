% y_1: odd-index entries
%y_2 : even-index entries
function [y_1,y_2] = separate(x)
len = length(x);
y_1 = zeros(1,len/2);
y_2 = zeros(1,len/2);
for i =1:len
    if mod(i,2) == 1
        y_1((i+1)/2) = x(i);
    else
        y_2(i/2) =x(i);
    end
end
end
    
        
