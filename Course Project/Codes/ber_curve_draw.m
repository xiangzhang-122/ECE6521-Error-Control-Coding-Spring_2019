av_error =[ 0.199735243055556  ;0.161553819444444 ;  0.071338975694444;
0.043449435763889;
 0.016998697916667 ;  0.004807942708333;
  0.000346137152778];
x= [0, 1, 2, 2.1, 2.2, 2.3, 2.4];
figure
semilogy(x, av_error,'d-')
xlabel( 'SNR E_b/N_0 (dB)' );
ylabel( 'BER' );
title('Average BER over 100 codewords')
ylim([ 10^(-4),10^0])
xlim([0, 3])
grid on
