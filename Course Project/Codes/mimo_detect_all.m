%--------------------------------------------------------------------------
% returns the all llr (L_D) for all the info bits
% input: HH-- 2*2*Num_channel_use
%        rr -- received symbol sequence
%        b_snr_dB -- E_b/N_0
%        LA_mat -- Num_ch_use * 4 matrix storing prior llr
%--------------------------------------------------------------------------
function y = mimo_detect_all(LA_mat, HH, rr, b_snr_dB)
temp_mat = [];    % Num_ch_use * 4 matrix storing llrs
Num_ch_use = size(HH, 3);
for k = 1: Num_ch_use
    ld = mimo_detector(LA_mat(k,:), HH(:,:,k), rr( 1+(k-1)*2 :2*k ), b_snr_dB);
    temp_mat = append(temp_mat, ld);
end
y = temp_mat;
end
