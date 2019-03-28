% y_1 is the product of signs
% y_2: sum of r/q values
% y_phi summmaiton of the phi functions
function [y_1,y_2, y_phi] = ex_sum_phi(j, vec, id, branch, index_mat)
% consider the case: bit/check node has degree 1
temp = 0;
temp_ = 0;
temp_p =1;
sum =0;
sum_ =0;
prod =1;
for i= 1:length(vec)
    if i ~= id
        temp = branch(vec(i), pos(j, index_mat(vec(i),:)));
%         if abs(branch(vec(i), pos(j, index_mat(vec(i),:))))~=0
%             temp_ = phi_(abs(branch(vec(i), pos(j, index_mat(vec(i),:))))); % phi_(0) =NaN
%             temp_p =sign(branch(vec(i), pos(j, index_mat(vec(i),:))));
%         else
%             temp_ =0;
%             temp_p = 1;
%         end     
            temp_ = phi_(abs(branch(vec(i), pos(j, index_mat(vec(i),:))))); % phi_(0) =NaN
            temp_p =sign(branch(vec(i), pos(j, index_mat(vec(i),:))));
    else if i == id
            temp =0;
            temp_ =0;
            temp_p = 1;
        end
    end
    sum= sum + temp;
    sum_= sum_ + temp_;
    prod = prod*temp_p;
end
y_1 = prod;
y_2 = sum;
y_phi = sum_;
end  % func

