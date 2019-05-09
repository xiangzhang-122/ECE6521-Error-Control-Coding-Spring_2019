% concatenating the row of matrix x in into a row vector
function y = stretch(x)
y=[];
dim_1 = size(x,1);
dim_2 = size(x,2);
for ii = 1: dim_1
    y((ii-1)*dim_2 +1 : ii*dim_2 ) = x(ii, :);
end
end
    
