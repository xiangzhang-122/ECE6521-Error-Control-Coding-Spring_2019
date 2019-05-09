% Run the f2nd part of the simulation
% from snr(N_1+1:7)

format long
%% -------------  turbo code generation ------------------------------------
Len_info = 9216;
miu = 3;
gen_poly = [7,5];
fb_poly = 7;
trellis = poly2trellis(miu, gen_poly, fb_poly);
punc_flag = 'punc';
rate = 0.5;
%% ---------------- MIMO parameters-----------------------------------------------
N = 2 ;  % # Txs
M = 2 ; % # Rxs
M_c = 2;  % each contellation contains M_c =2 bits
bit_snr_dB =[0, 1, 2, 2.1, 2.2, 2.3, 2.4];
bit_snr = 10.^(bit_snr_dB/10);
symbol_snr_dB = bit_snr_dB - 10*log10(N/(rate*M*M_c)) ;  % note that the second is equal to zero
symbol_snr = 10.^(symbol_snr_dB/10);
N_c = [50, 50, 50, 100, 100, 100, 100];
%% ----------------- decoding parameters ------------------------
N_iter_mimo = 4;  %  mimo detection # iterations
N_iter_dec = 8;  % turbo ddecoding # of iterations
%%
av_error =zeros(1, 4);  % averaged error for each snr
%%
for kk = 4:7
    err_sum = 0;
    for jj =1: N_c(kk)
                info_seq = round(rand(1, Len_info));  % info sequence
                [code,~,~,~, rand_perm_turbo,~] = turbo_encoder(info_seq, miu, gen_poly, fb_poly, punc_flag);
                code_len = length(code);
                %% ----------------- channel interleaving -------------------
                rand_perm_ch = randperm(code_len);
                code_inter = ch_inter(code, rand_perm_ch);     % interleaved code
                %% -----------------contellation mapping --------------------------------
                symbol_seq = seq_qpsk_map(code_inter);
                Num_symbol  = length(symbol_seq);
                Num_block = code_len/4;  %# of channel uses
                %% --------------- channel gain matrix generation -----------------
                H_all =[];
                for k = 1: Num_block
                    H_all(:,:,k) = ch_gen(2,2, 1);   % each channel gain has total power 1
                end
                %% ---------------------- received sequence --------------------------
                r_seq = zeros(1, Num_symbol); % received sequence
                r_temp = zeros(1, Num_symbol);
                for ii = 1:Num_symbol/2
                    r_temp(1+(ii-1)*2 : 2*ii) = transpose(H_all(:,:,ii)*transpose(symbol_seq(1+(ii-1)*2 : 2*ii)));
                end

                sigma_n_2 = 2/symbol_snr(kk);  %% noise power per dim
                noise_vec = complex_noise(1, Num_symbol, 2*sigma_n_2);    % total noise power = 2*sigma_n_2
                r_seq = r_temp + noise_vec;
                r_seq = r_seq.' ;%   to column vector

              %% ---------------------------- EXCHANGE SESSION ------------------------------------
                LA_mat = zeros(Num_block, 4);    % initialization
                [decoded_seq,llr] = mimo_det_dec(r_seq,H_all, LA_mat,N_iter_mimo, N_iter_dec, rand_perm_turbo, rand_perm_ch, trellis, bit_snr_dB(kk) );
                err = error_compute(decoded_seq(1:Len_info), info_seq);
                err_sum = err_sum + err;
                 x=sprintf(' snr cnt=  %d, code cnt = %d, error = %d', kk, jj, err);
                display(x);
    end
    av_error(kk) = err_sum/N_c(kk);
    x= sprintf('average error = %d for snr cnt %d', av_error(kk), kk);
    display(x)
end

av_error
% write the result to ber_2.txt
fileID = fopen('ber_2.txt','w');
fprintf(fileID, 'Ber (snr index 4-7):');
fprintf(fileID,'%f\n *', av_error);
                




 





    




