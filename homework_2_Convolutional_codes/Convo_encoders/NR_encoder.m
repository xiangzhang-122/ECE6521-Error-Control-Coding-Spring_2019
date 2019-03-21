function [v_0, v_1] = NR_encoder(u, miu, gen_poly)
%miu = m + 1
m = miu -1;% number of shifters
g_0 = de2bi(oct2dec(gen_poly(1)),miu ,'left-msb')
g_1 = de2bi(oct2dec(gen_poly(2)),miu, 'left-msb')
h= length(u);
u = [u, zeros(1, m)];
v_0 = zeros(1, h+m);
v_1 = zeros(1, h+m);
state_matrix = zeros(h + m, m);
for i =  2: h+m
    state_matrix(i,1) = u(i-1);
    for j = 2: m
        state_matrix(i,j) = state_matrix(i-1,j-1);
    end
end
for i = 1:h+m
    v_0(i)= mod(g_0*[u(i), state_matrix(i,:)]',2);
    v_1(i)= mod(g_1*[u(i), state_matrix(i,:)]',2);
end
end 

   