clear all;

% FIR Bandpass Filter
Fs = 16200;
Ts = 1/Fs;
Fc = 3e3;
firLen = 101;
bw = 400;

% Generate the coefficients for the filter
bpfir = fir_bandpass(Fs,Fc,bw,firLen);

% figure();
% freqz(bpfir);


% Import the audio clip
[y, Fs] = audioread('mix10 2021.wav');

% Filter using conv function
% y_filtered = fir_filter_conv(y,bpfir);
% y_filtered = conv(y,bpfir);
% sound(y_filtered, Fs);

% Filter using blockmode function
blocksize = 4096;
y = y(1:floor(length(y)/blocksize)*blocksize);
y_filtered = blockmode_filter(y,bpfir,blocksize);

%  Square and plot the output
y_filtered = y_filtered.^2;
axis = 1:length(y_filtered);

figure();
plot(axis,y_filtered);
title('Morse Code Signal')

t = (0:Ts:10);
x = cos(2*pi*Fc*t) + cos(2*pi*(Fc-1000)*t) + cos(2*pi*(Fc+1000)*t);
x_filtered = fir_filter_conv(y,bpfir);

nfft = 512;
FF = -0.5:1/nfft:0.5 - 1/nfft;
figure();
hold on;
plot(FF, 20*log10(abs(fftshift(fft(x, nfft)))));
plot(FF, 20 + 20*log10(abs(fftshift(fft(x_filtered, nfft)))));
hold off;
title("3 Pure Sinusoids");
legend('Original','Filtered');


