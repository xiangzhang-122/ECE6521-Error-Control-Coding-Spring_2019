% return the index of the first entry that is equal to val 
function y = pos(val,vec)
for i =1:length(vec)
    if vec(i) == val
        y = i;
    end
end
end
        
        