% Viterbi Decoding for AWGN channel 
% Problem 4
h=4; % # info bits
N=7;% N=h+m
R=[-0.72  -0.34 -1.14 2.92 -1.78 -1.05 -2.11;
    0.93 -3.42 -2.84 0.23 -0.63 2.95 -0.55 ];
Decoded_seq = zeros(1,N);
[PPM_matrix_awgn,Bran_matrix_awgn]= forward_build_awgn_func(h,R,N);   % building up the ppm/bm matrix
%[~,state]=max(PPM_matrix_awgn(:,N+1)) % this returns state '6' instead of
 state=1;   % terminated code
State=[];% track the decode states
for i=N:-1:1
    [state,decoded_bit]=trace_back_func(state,PPM_matrix_awgn(:,i),Bran_matrix_awgn(:,i));
    Decoded_seq(i)= decoded_bit;
    State(i)=state;
end
Decoded_seq  % info message with terminating bits

PPM_matrix_awgn


    



