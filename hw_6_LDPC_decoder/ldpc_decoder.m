%  LDPC decoding
% H --parity check matrix
% y -- received signal
% sigma_2-- snr
% Num_iter --# iterations
function [dec_seq, dec_llr]= ldpc_decoder(H, y,sigma_2, Num_iter)
% Tanner graph -------
% H =[ 1 1 1 0 0 0 0 0;0 0 0 1 1 1 0 0;1 0 0 1 0 0 1 0; 0 1 0 0 1 0 0 1];
format long;
Num_var =  size(H, 2);
Num_che = size(H, 1); 
che_degree = weight(H, 'row');
var_degree = weight(H, 'column');
che_index = zeros(Num_che, max(che_degree));  % specifies the connection
var_index = zeros(Num_var, max(var_degree));    
for i =1: Num_che
    che_index(i,1:che_degree(i)) = extract(H(i,:));
end
for i =1: Num_var
    var_index(i,1:var_degree(i)) = extract(H(:,i)');
end
che_branch = zeros(Num_che, max(che_degree));  %  r vlaue 
var_branch = zeros(Num_var, max(var_degree));  % q value
% y = ones(1,Num_var);   % received signal
%-------------------------------------------
% sigma_2 = 0.5;
for i =1:Num_var
    channel_llr(i) = 2*y(i)/sigma_2;
end
% initializaiton 
for i = 1: Num_var
    for j =1: var_degree(i)
        var_branch(i,j) = channel_llr(i);   % q from the same bit node are all the same
    end
end
% N_iter = 1; % # of iterations
%-------------- update  ------------------
for k = 1: Num_iter
    % update r value
    for j = 1:Num_che
        for i =1:che_degree(j)
            [sign_prod, ~, sum_phi]= ex_sum_phi( j, che_index(j,1:che_degree(j)), i, var_branch, var_index);
            % r(x,y) where x = j, y = che_index(j,i)
            che_branch(j,i) = sign_prod * phi_(sum_phi);
        end
    end
    % update q value
    for i = 1:Num_var
        for j =1:var_degree(i)
            sum_ = ex_sum( i, var_index(i,1:var_degree(i)), j, che_branch, che_index);
            % q(x,y) where x = i, y = var_index(i,j)
            var_branch(i,j) =  sum_ + channel_llr(i)  ;
%             var_branch(i,j) =  sum_  ;
        end
    end
end  % iteration

%  ------------- decision llr ------------------
dec_llr = zeros(1,Num_var);   % decision
dec_seq = [];
for i =1:Num_var
    dec_llr(i) = channel_llr(i) + non_ex_sum(i, var_index(i,1:var_degree(i)), che_branch, che_index);
end
for i =1: Num_var
    if dec_llr(i) > 0
        dec_seq(i) = 0;   % decoded codeword
    else
        dec_seq(i) = 1;
    end
end
end % fucntion
        
    


    
