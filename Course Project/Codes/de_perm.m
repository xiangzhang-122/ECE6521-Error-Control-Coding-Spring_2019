% deinterleaver the seq interleaved by rd_perm
% y is thr permutated version of x accorinding to rd_perm
function z = de_perm(y, rd_perm)
z=[];
for i= 1: length(rd_perm)
    z(rd_perm(i)) = y(i);
end

    


end
