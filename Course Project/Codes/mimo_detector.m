% mimo detector 
% input: LA-- prior (ex llr) for the 4 bits transmitted
%        H --channel realization
%        bit_snr --E_b/N_0
%        Y -- received sumbols, column vector
% output: ld -- llr for all 4 bits (extrinsic)
function ld = mimo_detector(LA, H, Y, bit_snr_dB)
format long;
bit_snr = 10^(bit_snr_dB/10);  % = symbol snr


sigma_n2 = 2/bit_snr;  % this is correct, do not change


ld = zeros(1,4);
X = zeros(16,4);  % all possible 4-bit codes
for var = 0:15
    X(var+1,:) = de2bi(var, 4,'left-msb');
end
X_pp = [];   % X_pp(:,:,k) store codes with k-th bit being 1
X_nn = [];   %X_nn(:,:,k) store codes with k-th bit being 0
for k =1:4
    X_pp(:,:,k) = extract_code(X, '1',k);   % codes with k-th bit = 1, 8 by 4
    X_nn(:,:,k) = extract_code(X, '0',k);
end
X_p = polar(X_pp);   % 0->-1, 1-> 1
X_n = polar(X_nn);
for k = 1:4
    pp = zeros(1,8);   % positive max star vector
    nn = zeros(1,8);
    for ii = 1:8
        pp(ii) = -1/(2*sigma_n2)*norm(Y - H*transpose(seq_qpsk_map(X_pp(ii,:,k))))^2 + 0.5*(dot(X_p(ii,:,k), LA)- X_p(ii,k,k)*LA(k));
        nn(ii) = -1/(2*sigma_n2)*norm(Y - H*transpose(seq_qpsk_map(X_nn(ii,:,k))))^2 + 0.5*(dot(X_n(ii,:,k), LA)- X_n(ii,k,k)*LA(k));
    end
    ld(k) =  max_star(pp) - max_star(nn);
end
end   % fun


    
    
    
    



