% systematic and recursive encoder
% feedback polynomial
% miu = m+1, constrint len = #shift registers + 1 
% retunns two output streams
% the output v_0 contains the terminating bits
% terminating flag : term_flag ='term' (h+m bits output), 'non_term' (h bits output)'
% term_flag ='term'--> append m terminating bits to u (and the parity check sequence)
% term_flag ='non_term'--> no terminating bits, only h-bit long code
% last_state: the state of the encdoer after the input of the last bit of
% input sequence. If term_flag = 'term', then last_state  ==0. Else we need
% to calculate last_state.
% last_state = 'term_state'-> terminated
%            = 'non_term_state'-> unterminated 
function [v_0, v_1, last_state] = SR_encoder(u, miu, gen_poly, fb_poly, term_flag)
%miu = m + 1
m = miu -1;% number of shifters
g_0 = de2bi(oct2dec(gen_poly(1)),miu ,'left-msb');
g_1 = de2bi(oct2dec(gen_poly(2)),miu, 'left-msb');
g_fb = de2bi(oct2dec(fb_poly),miu ,'left-msb');
h= length(u);
v_0 = zeros(1, h);
v_1 = zeros(1, h);
state_matrix = zeros(h + m, m+1);  % cb(l), s_1(l)...
v_0 = u;  
bin_fb = de2bi(oct2dec(fb_poly),miu ,'left-msb');
state_matrix(1,1) =mod( u(1) + bin_fb(2:miu) *state_matrix(1,2:m +1)',2);
for i =  2: h
    for j = 2: m+1
        state_matrix(i,j) = state_matrix(i-1,j-1);
    end
    state_matrix(i,1) = mod(u(i) + bin_fb(2: miu)*state_matrix(i,2:m +1)',2);
end
for i = 1:h
%     v_0(i)= mod(g_0*[u(i), state_matrix(i,:)]',2);
    v_1(i)= mod(g_1*state_matrix(i,:)',2);
end
% determine the terminating bits
term_state = zeros(m, m+1);
tb =  zeros(1,m);
v_tb =zeros(1,m);
term_state(1,1) = 0;
term_state(1,2:m+1)= state_matrix(h,1:m);
for i =2:m
    term_state(i,1)= 0;
    term_state(i,2:m+1)= term_state(i-1,1:m);
end
for i = 1:m
    tb(i) = mod( bin_fb(2:miu) *term_state(i,2:m +1)',2);
    v_tb(i) = mod(g_1*term_state(i,:)',2);
end
if strcmp(term_flag,'term')==1   % info seq is terminated
    v_0= [v_0, tb];   % the output v_0 contains the terminating bits
    v_1 =[v_1, v_tb];  
    last_state = 'term_state';
else if strcmp(term_flag,'non_term')
        if bi2de(state_matrix(h,:),'left-msb')==0
            last_state= 'term_state';
        else
            last_state= 'non_term_state';
        end
            
    end
end

end  % func
   