% Viterbi Decoding 
% Problem 3 DMC channel
h=4; % # info bits
N=7;
R =[ 7 7 3 1 7 3 3; 8 1 1 6 2 8 2]; %received sequence R=[r_0;r_1]
Decoded_seq = zeros(1,N);
P_tran=[]; % prob. transition matrix
P_tran=zeros(2,8);
P_tran(1,1)=0.434;
P_tran(1,2)=0.197;
P_tran(1,3)=0.167;
P_tran(1,4)=0.111;
P_tran(1,5)=0.058;
P_tran(1,6)=0.023;
P_tran(1,7)=0.008;
P_tran(1,8)=0.002;
P_tran(2,1)=0.002;
P_tran(2,2)=0.008;
P_tran(2,3)=0.023;
P_tran(2,4)=0.058;
P_tran(2,5)=0.111;
P_tran(2,6)=0.167;
P_tran(2,7)=0.197;
P_tran(2,8)=0.434;
P_tran_int=[];
for i=1:2
    for j=1:8
        P_tran_int(i,j) =   round(4.28 *(log10(P_tran(i,j))+ 2.699), 0);
    end
end

[PPM_matrix, Bran_matrix] = forward_build_dmc_func(P_tran_int,h,R,N);   % building up the ppm/bm matrix
%[~,state]= max(PPM_matrix(:,N+1)); %returns state==1
State=[];% track the decode states
state=1; % in the last stage, only paths ending with S0 have finite ppm
for i=N:-1:1
    [state, decoded_bit]=trace_back_func(state,PPM_matrix(:,i),Bran_matrix(:,i));
    Decoded_seq(i)= decoded_bit;
    State(i)= state;
end
Decoded_seq
State

PPM_matrix
P_tran_int




    




