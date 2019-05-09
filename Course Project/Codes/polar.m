% mapping 0->-1, 1->1
function y = polar(x)
y = [];
for ii =1:size(x,1)
    for jj = 1: size(x,2)
        for kk =1:size(x,3)
            y(ii,jj,kk) = 2*x(ii,jj,kk) -1;
        end
    end
end
end
            
    
