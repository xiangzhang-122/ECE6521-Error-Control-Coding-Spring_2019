% fold vector x into a matrix with dim_2 columns (dim_2 must divide len(x))
function y = de_stretch(x,dim_2)
row = length(x)/dim_2;
for i = 1: row
    y(i, 1:dim_2) = x((i-1)*dim_2+1 :i*dim_2);
end
end

