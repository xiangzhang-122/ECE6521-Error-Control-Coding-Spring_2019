% Turbo encoder with two compoinent convol encoder with rate 1/2 
% punc_flag ='punc': with puncturing
%           'non_punc': no puncturing
% u :info sequence
% constituent ENC is SR- convo encoder
function [code,v_0,v_1,v_2, rand_perm,last_state_2] = turbo_encoder(u, miu, gen_poly, fb_poly, punc_flag)
[v_0, v_1,~] = SR_encoder(u, miu, gen_poly, fb_poly, 'term'); % dec 1 is terminated,v_0 h+m bits
rand_perm = randperm(length(v_0)); 
% rand_perm =[5, 7,16, 4,1, 19, 10, 15, 3, 20, 12, 8, 14, 2, 17,11, 18,6,13,9];
v_0_perm = perm(v_0, rand_perm ); % permiutate v_0 according to rand_perm
% perm: the ramdom permutation used in the encoder
%----------------------------------------------------
% perm = [0, 8, 15, 9, 4,7,11,5,1,3,14,6,13,12,10,2]+1;   % verify note example
% v_0_perm=[];
% for i =1:length(perm)
%     v_0_perm(i) = v_0(perm(i)+1);
% end
%--------------------------------------
[~, v_2, last_state_2] = SR_encoder(v_0_perm, miu, gen_poly, fb_poly, 'non_term'); % dec 1 is terminated
% although we do not append term. bits to ENC 2 , it is still possible that ENC 2 is actually 
% terminated. We need to check this.
%last_state_2 = 'term_state'/'non_term_state': indicates whether ENC 2 is
%terminated or not.
code =[];
rate_recp =0;   % reciprocal of rate
if strcmp(punc_flag,'punc')
    rate_recp =2;
else if strcmp(punc_flag,'non_punc')
        rate_recp = 3;
    end
end
code = puncture(v_0,v_1,v_2, rate_recp);   % produce the punctured or non -ounctured function
end


    
    
    