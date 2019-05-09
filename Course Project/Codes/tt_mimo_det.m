 

LA= zeros(1,4);
% LA= [1.2, -0.5, -1.5, 2];
H = [-0.9 + 2*i, 0.2+2*i ; -0.3-1*i, 2.5+0.5*i];
Y =[1+1.5*i; 2-0.2*i];
bit_snr_dB = 2
ld = mimo_detector(LA, H, Y, bit_snr_dB)
