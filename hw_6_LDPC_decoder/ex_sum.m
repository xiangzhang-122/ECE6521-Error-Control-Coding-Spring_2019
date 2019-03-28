% vec_1/2: vector whose elements represent the index of bit/check nodes
% conencted to a specific node
% id -the index that will be excluded 
% branch: the check\var branch value matrix
% j -- the j -th row of che\var_branch
function y = ex_sum(j, vec, id, branch, index_mat)
temp = 0;
sum =0;
for i= 1:length(vec)
    if i ~= id
        temp = branch(vec(i), pos(j, index_mat(vec(i),:)));
    else if i == id
            temp =0;
        end
    end
    sum= sum + temp;
end
y = sum;
end  % func

