% problem 2   
N_bit =1000;
% gen_poly=[7,5];
% fb_poly =7;
% miu =3;
% gen_poly=[3,2];
% fb_poly =3;
% miu =2;
gen_poly=[37,21];
fb_poly =37;
miu =5;
rate_recp =0;  % reciprocal of rate 
punc_flag ='punc';
if strcmp(punc_flag,'punc')
     rate_recp =2;
else 
     rate_recp =3;
end
snr_db = 0:2;
snr = 10.^(snr_db/10);
N_c = [10,10,5];
Num_iter =3;
aver_error = zeros(1, length(snr));
for s = 1: length(snr)
    err_sum =0;
    for i = 1:N_c(s)
        u = round(rand(1, N_bit));
        [code,v_0,v_1,v_2, rand_perm, last_state_2] = turbo_encoder(u, miu, gen_poly, fb_poly, punc_flag);
        term_flag_1 = 'term'; % ENC 1 is terminated
        if strcmp(last_state_2,'term_state')
            term_flag_2 = 'term';
        else
            term_flag_2 = 'non_term';
        end
        y =2*code -1;
        recv_seq = y + randn(1, length(code))/sqrt(2*snr(s)/rate_recp);
%        [r_0,r_1,r_2] = extract(recv_seq, 'non_punc')
        ap_llr =zeros(1,length(code)/rate_recp );
        dec_seq =[];
        [dec_seq, app_LLR]= turbo_decoder(recv_seq, miu, gen_poly, fb_poly, snr(s), ap_llr, rand_perm, Num_iter, punc_flag, term_flag_1,term_flag_2 );
        % input snr is E_b/N_0
        err = error_compute(dec_seq(1:N_bit), u);
        err_sum =err_sum + err;
    end   % end i
    aver_error(s)= err_sum/N_c(s);
end
semilogy(snr_db, aver_error,'d-');
hold on;
grid on;
% semilogy(snr_db, av_err_4,'d-');
% legend('NR-(5,7) code','NR-(27,31) code','SR-(7,5) code', 'NASA NR-(117,155) code');
axis([min(snr_db) max(snr_db) 10^(-5) 1 ]);
    
      


    
