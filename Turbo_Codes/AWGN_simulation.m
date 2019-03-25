% Simlulation of BPSK over AWGN
% Simulaiton of NR-(5,7), (27,31) and SR-(7,5) , NASA (2,16)-(117,155)code with rate half
format long
% N_C = 500 ;% # of codewords
N_bit=2000;
rate =0.5;
snr_db = 0:4;
snr = 10.^(snr_db/10);
% N_C =[1,1,1,2,2];
% N_C =[500, 500, 500,3000, 3000];
N_C =[5, 5, 5,5, 5];
av_err_1 = zeros(1, length(snr_db));
av_err_2 = zeros(1, length(snr_db));
av_err_3 = zeros(1, length(snr_db));
% av_err_4 = zeros(1, length(snr_db));
for i=1:length(snr_db)
    err_sum_1 = 0;   % record  individual error
    err_sum_2 = 0;
    err_sum_3 = 0;
%     err_sum_4 = 0;
    for j =1:N_C(i)
        info = round(rand(1, N_bit));
        %-------------------------- enc para.-------------------------------------
        gen_poly_1= [5,7];   %enc 1
        miu_1 = 3;    % miu = m + 1
        trellis_1 = poly2trellis(miu_1, gen_poly_1);
        gen_poly_2= [27,31];  %enc 2
        miu_2 = 5;
        trellis_2 = poly2trellis(miu_2, gen_poly_2);
        gen_poly_3= [7,5];  % ENC 1, SR
        miu_3 = 3;
        fb_poly = 7;
        trellis_3 = poly2trellis(miu_3, gen_poly_3, fb_poly);
        
%         gen_poly_4= [117, 155];  %nasa code
%         miu_4 = 7;
%         trellis_4 = poly2trellis(miu_4, gen_poly_4);
        %-------------------------- encoding & mapping ------------------------------
        [v0_1,v1_1] = NR_encoder(info, miu_1, gen_poly_1 );
        code_1 = combine(v0_1,v1_1);
        y_1 =2*code_1 -1;
        [v0_2,v1_2] = NR_encoder(info, miu_2, gen_poly_2 );
        code_2 = combine(v0_2,v1_2);
        y_2 =2*code_2 -1;
        [v0_3,v1_3] = SR_encoder(info, miu_3, gen_poly_3, fb_poly );
        code_3 = combine(v0_3,v1_3);
        y_3 =2*code_3 -1;
%         
%         [v0_4,v1_4] = NR_encoder(info, miu_4, gen_poly_4 );
%         code_4 = combine(v0_4,v1_4);
%         y_4 =2*code_4 -1;
        %------------------ awgn channel------------------------------------
        recv_1 = y_1 + randn(1, length(code_1))/sqrt(2*snr(i));
        recv_2 = y_2 + randn(1, length(code_2))/sqrt(2*snr(i));
        recv_3 = y_3 + randn(1, length(code_3))/sqrt(2*snr(i));
%         recv_4 = y_4 + randn(1, length(code_4))/sqrt(2*snr(i));
        %----------------------  decoding ------------------------------------
        ap_LLR_1 = zeros(1,rate*length(code_1));
        ap_LLR_2 = zeros(1,rate*length(code_2));
        ap_LLR_3 = zeros(1,rate*length(code_3));
%         ap_LLR_4 = zeros(1,rate*length(code_4));
        [~, ~, ~, dec_1] = mogen_log_map_bcjr(recv_1, trellis_1, snr(i), ap_LLR_1);
        [~, ~, ~, dec_2] = mogen_log_map_bcjr(recv_2, trellis_2, snr(i), ap_LLR_2);
        [~, ~, ~, dec_3] = mogen_log_map_bcjr(recv_3, trellis_3, snr(i), ap_LLR_3);
%         [~, ~, ~, dec_4] = mogen_log_map_bcjr(recv_4, trellis_4, snr(i), ap_LLR_4);
        e_1 = error_compute(dec_1(1:N_bit), info);
        err_sum_1 = err_sum_1 + e_1;
        e_2 = error_compute(dec_2(1:N_bit), info);
        err_sum_2 = err_sum_2 + e_2;
        e_3 = error_compute(dec_3(1:N_bit), info);
        err_sum_3 = err_sum_3 + e_3;
        
%         e_4 = error_compute(dec_4(1:N_bit), info);
%         err_sum_4 = err_sum_4 + e_4;
    end  % for j 
    av_err_1(i) = err_sum_1/N_C(i);
    av_err_2(i) = err_sum_2/N_C(i);
    av_err_3(i) = err_sum_3/N_C(i);
    
%     av_err_4(i) = err_sum_4/N_C(i);
end
%--------------------------------- BER plot ------------------------------
semilogy(snr_db, av_err_1,'s-');
grid on;
hold on;
semilogy(snr_db, av_err_2,'^-');
hold on;
semilogy(snr_db, av_err_3,'d-');
hold on
% semilogy(snr_db, av_err_4,'d-');
% legend('NR-(5,7) code','NR-(27,31) code','SR-(7,5) code', 'NASA NR-(117,155) code');
axis([min(snr_db) max(snr_db) 10^(-4) 1 ]);



