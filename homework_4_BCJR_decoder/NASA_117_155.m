% NASA (2,16)-(117,155)code with rate half
format long
N_bit=2000;
rate =0.5;
snr_db = 0:4;   % here snr =E_b/N_0
snr = 10.^(snr_db/10);
N_C =[10,10,100,100,100];
av_err_4 = zeros(1, length(snr_db));
for i=1:length(snr_db)
    err_sum_4 = 0;
    for j =1:N_C(i)
        info = round(rand(1, N_bit));
        %-------------------------- enc para.-------------------------------------
        gen_poly_4= [166,171];  %nasa code
        miu_4 = 7;
        trellis_4 = poly2trellis(miu_4, gen_poly_4);
        %-------------------------- encoding & mapping ------------------------------
        
        [v0_4,v1_4] = NR_encoder(info, miu_4, gen_poly_4 );
        code_4 = combine(v0_4,v1_4);
        
        y_4 =2*code_4 -1;
        %------------------ awgn channel------------------------------------
        recv_4 = y_4 + randn(1, length(code_4))/sqrt(snr(i));
        %----------------------  decoding ------------------------------------

        ap_LLR_4 = zeros(1,rate*length(code_4));
        [~, ~, ~, dec_4] = mogen_log_map_bcjr(recv_4, trellis_4, rate*snr(i), ap_LLR_4, 'term');
        e_4 = error_compute(dec_4(1:N_bit), info)
        err_sum_4 = err_sum_4 + e_4;
    end  % for j 
 
    av_err_4(i) = err_sum_4/N_C(i);
end
%--------------------------------- BER plot ------------------------------
% semilogy(snr_db, av_err_1,'s-');
% grid on;
% hold on;
% semilogy(snr_db, av_err_2,'^-');
% hold on;
% semilogy(snr_db, av_err_3,'d-');
% hold on
semilogy(snr_db, av_err_4,'d-');
legend('NASA NR-(2,1,6) code');
grid on;
axis([min(snr_db) max(snr_db) 10^(-6) 1 ]);

