% generating complex nosie with total power sigma_2
% dim_1 by dim_2 matrix
function y =  complex_noise(dim_1, dim_2, sigma_2)
y = [];
for ii = 1: dim_1
    for jj = 1:dim_2
        y(ii,jj) = sqrt(sigma_2/2)*randn(1,1) + i*sqrt(sigma_2/2)*randn(1,1);
    end
end
end
        