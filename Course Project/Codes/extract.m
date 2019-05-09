function [r_0, r_1, r_2] = extract(recv_seq, punc_flag)
if strcmp(punc_flag,'punc')
    r_0=[];
    r_1 = zeros(1,length(recv_seq)/2);
    r_2 = zeros(1,length(recv_seq)/2);  % permutated
    for j= 1: length(recv_seq)/2
        r_0(j) = recv_seq(2*j-1);
        if mod(j,2) ==1
            r_1(j) = recv_seq(2*j);   % the missing parity bits in v_1/v_2(r_1,r_2) are assumed to be all zero
        end
    end
    for j= 1: length(recv_seq)/2
        if mod(j,2) ==0
            r_2(j) = recv_seq(2*j);   % the missing parity bits in v_1/v_2(r_1,r_2) are assumed to be all zero
        end
    end
end
if strcmp(punc_flag,'non_punc')
        r_0=[];
        r_1 =[];   %length= len(recv_seq)/3
        r_2 = [];  % permutated
        for i =1: length(recv_seq)/3
            r_0(i) = recv_seq(1+3*(i-1));
            r_1(i) = recv_seq(2+3*(i-1));
            r_2(i) = recv_seq(3*i);
        end
end
end % func
            
        