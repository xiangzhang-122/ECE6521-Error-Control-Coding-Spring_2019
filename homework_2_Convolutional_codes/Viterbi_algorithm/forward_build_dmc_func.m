% Building up the partial path metric and brach metric, which are both 
% matrices recording the specific values for each state and branch
function [PPM_matrix,Bran_matrix]=forward_build_dmc_func(P_tran_int,h,R,N)
PPM_matrix=-Inf*ones(8,N+1); % row--state, column--stage
Bran_matrix=zeros(2*8,N);
PPM_matrix(1,1)=0;
for i=1:N
    Bran_matrix(1,i)=  P_tran_int(1,R(1,i))+P_tran_int(1,R(2,i));
    % state==1 (S_0), input==0
    Bran_matrix(2,i)=P_tran_int(2,R(1,i))+P_tran_int(2,R(2,i));
    % state==1, input==1
    Bran_matrix(3,i)=P_tran_int(1,R(1,i))+P_tran_int(2,R(2,i));
    % state==2, input==0
    Bran_matrix(4,i)=P_tran_int(2,R(1,i))+ P_tran_int(1,R(2,i));
    % state==2, input==1
    Bran_matrix(5,i)=P_tran_int(2,R(1,i))+ P_tran_int(2,R(2,i));
    % state==3, input==0
    Bran_matrix(6,i)=P_tran_int(1,R(1,i))+P_tran_int(1,R(2,i));
    % state==3, input==1
    Bran_matrix(7,i)=P_tran_int(2,R(1,i))+P_tran_int(1,R(2,i));
    % state==4, input==0
    Bran_matrix(8,i)=P_tran_int(1,R(1,i))+P_tran_int(2,R(2,i));
    % state==4, input==1
    Bran_matrix(9,i)=P_tran_int(2,R(1,i))+P_tran_int(2,R(2,i));
    % state==5, input==0
    Bran_matrix(10,i)=P_tran_int(1,R(1,i))+P_tran_int(1,R(2,i));
    % state==5, input==1
    Bran_matrix(11,i)=P_tran_int(2,R(1,i))+P_tran_int(1,R(2,i));
    % state==6, input==0
    Bran_matrix(12,i)=P_tran_int(1,R(1,i))+P_tran_int(2,R(2,i));
    % state==6, input==1
    Bran_matrix(13,i)=P_tran_int(1,R(1,i))+P_tran_int(1,R(2,i));
    % state==7, input==0
    Bran_matrix(14,i)=P_tran_int(2,R(1,i))+P_tran_int(2,R(2,i));
    % state==7, input==1
    Bran_matrix(15,i)=P_tran_int(1,R(1,i))+P_tran_int(2,R(2,i));
    % state==8, input==0
    Bran_matrix(16,i)=P_tran_int(2,R(1,i))+P_tran_int(1,R(2,i));
    % state==8, input==1
    %partial path metric realization
    PPM_matrix(1,i+1)=max(PPM_matrix(1,i)+Bran_matrix(1,i),PPM_matrix(5,i)+Bran_matrix(9,i));% input==0
    PPM_matrix(2,i+1)=max(PPM_matrix(1,i)+Bran_matrix(2,i),PPM_matrix(5,i)+Bran_matrix(10,i));% input==1
    PPM_matrix(3,i+1)=max(PPM_matrix(2,i)+Bran_matrix(3,i),PPM_matrix(6,i)+Bran_matrix(11,i));%0
    PPM_matrix(4,i+1)=max(PPM_matrix(2,i)+Bran_matrix(4,i),PPM_matrix(6,i)+Bran_matrix(12,i));%1
    PPM_matrix(5,i+1)=max(PPM_matrix(3,i)+Bran_matrix(5,i),PPM_matrix(7,i)+Bran_matrix(13,i));%0
    PPM_matrix(6,i+1)=max(PPM_matrix(3,i)+Bran_matrix(6,i),PPM_matrix(7,i)+Bran_matrix(14,i));%1
    PPM_matrix(7,i+1)=max(PPM_matrix(4,i)+Bran_matrix(7,i),PPM_matrix(8,i)+Bran_matrix(15,i));%0
    PPM_matrix(8,i+1)=max(PPM_matrix(4,i)+Bran_matrix(8,i),PPM_matrix(8,i)+Bran_matrix(16,i));%1
end

    
end
    
    
