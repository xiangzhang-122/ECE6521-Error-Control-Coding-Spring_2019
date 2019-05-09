% each gain has total power sigma-2
function H = ch_gen(dim_1,dim_2, sigma_2)
format long;
H = zeros(dim_1, dim_2);
sigma = sqrt(sigma_2/2); % variance of real part
for ii = 1:dim_1
    for jj = 1: dim_2
        H(ii,jj) = sigma*randn(1,1) + i*sigma*randn(1,1);
    end
end
end
