% [Description] This function combines the three component sequence of the codes, i.e.,
% the info sequence (terminated, h+m bits), the first parity check sequence
% (terminated) and the second parity check sequence (uaually not
% terminated) with or without puncturing.
% rate_recp == 2(rate =0.5) -> puncturing
% rate == 1/3 -> no puncturing 
function code = puncture(v0,v1,v2, rate_recp)
code=[];
if rate_recp ==2
    for i = 1:rate_recp*length(v0)
        if mod(i,2)==1
            code(i)= v0((i+1)/2);
        else if mod(i/2,2)==1
                code(i) = v1(i/2);
            else if mod(i/2,2)==0
                code(i) = v2(i/2);
                end
            end
        end
    end
end% if 
if rate_recp ==3
    for i = 1:rate_recp*length(v0)
        if mod(i,3)== 1
            code(i) =v0((i+2)/3);
        end
        if mod(i,3)== 2
            code(i) =v1((i+1)/3);
        end 
        if mod(i,3)== 0
            code(i) =v2(i/3);
        end 
    end
end%if
end