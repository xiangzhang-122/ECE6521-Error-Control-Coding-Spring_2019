% append row vector to matrix X, which can be empty
function y = append(X, vec)
dim = size(X, 1);
y = [];
y(1:dim,:) = X;
y(dim+1, :) = vec;
end




