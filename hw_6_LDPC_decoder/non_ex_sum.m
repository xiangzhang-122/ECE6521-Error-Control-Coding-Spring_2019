function y = non_ex_sum(j, vec, branch, index_mat)
temp = 0;
sum =0;
for i= 1:length(vec)
   temp = branch(vec(i), pos(j, index_mat(vec(i),:)));
   sum= sum + temp;
end
y = sum;
end  % func