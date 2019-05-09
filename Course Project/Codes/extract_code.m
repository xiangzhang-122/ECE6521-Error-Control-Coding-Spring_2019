% extacts the codes with k-th bit indicated by flag
function y = extract_code(x, flag, k)
dim_1 = size(x, 1);
y=[];
if flag == '1'
    for ii = 1:dim_1
        if x(ii,k) == 1
            y = append(y, x(ii,:));
        end
    end
end
if flag == '0'
    for ii = 1:dim_1
        if x(ii,k) == 0
            y = append(y, x(ii,:));
        end
    end
end
end

        

