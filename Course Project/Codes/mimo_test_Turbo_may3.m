% project: MIMO detector with Turbo endec, using QPSK
% 'Achieving near-capacity on a multipe-antenna channel', S. Brink et al'
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
bit_snr_dB =[0, 1, 2, 2.1, 2.2, 2.3, 2.4, 2.6];
bit_snr = 10.^(bit_snr_dB/10);
symbol_snr_dB = bit_snr_dB - 10*log10(N/(rate*M*M_c)) ;  % note that the second is equal to zero
symbol_snr = 10.^(symbol_snr_dB/10);
% N_c = [100, 100, 100, 200, 200, 200, 200];
% N_c = [50, 50, 50, 50, 50, 50, 50,50];
%% ----------------- decoding parameters ------------------------
N_iter_mimo = 4;  %  mimo detection # iterations
N_iter_dec = 8;  % turbo ddecoding # of iterations
%%
av_error =zeros(1,length(symbol_snr_dB ));  % averaged error for each snr
%%
% for kk = 1: length(symbol_snr_dB)
%     err_sum = 0;
%     for jj =1: N_c(kk)

kk= 8   % 2.6 db
                info_seq = round(rand(1, Len_info));  % info sequence
                [code,~,~,~, rand_perm_turbo,~] = turbo_encoder(info_seq, miu, gen_poly, fb_poly, punc_flag);
                code_len = length(code);
                %% ----------------- channel interleaving -------------------
                rand_perm_ch = randperm(code_len);
                % rand_perm_turbo -- turbo permutation
                % rand_perm_ch -- channel permutation
                code_inter = ch_inter(code, rand_perm_ch);     % interleaved code
                %% -----------------contellation mapping --------------------------------
                symbol_seq = seq_qpsk_map(code_inter);
                Num_symbol  = length(symbol_seq);
                % [symbol_seq_1, symbol_seq_2] = separate(symbol_seq);
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

                sigma_n_2 = 2/bit_snr(kk) %% noise power per dimension
                noise_vec = complex_noise(1, Num_symbol, 2*sigma_n_2);    % total noise power = 2*sigma_n_2
                r_seq = r_temp + noise_vec;
                r_seq = transpose(r_seq) ;%   column vector

              %% ---------------------------- EXCHANGE SESSION ------------------------------------
                LA_mat = zeros(Num_block, 4);    % initialization
                [decoded_seq,llr] = mimo_det_dec_may3(info_seq, r_seq,H_all, LA_mat,N_iter_mimo, N_iter_dec, rand_perm_turbo, rand_perm_ch, trellis, bit_snr_dB(kk) );
                err = error_compute(decoded_seq(1:Len_info), info_seq)
                
                err_sum = err_sum + err;
                 x=sprintf(' snr cnt=  %d, code cnt = %d, error = %d', kk, jj, err);
                display(x);
%     end
%     av_error(kk) = err_sum/N_c(kk);
% end
% 
% av_error
                




 





    




