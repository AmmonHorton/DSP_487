clear all;

% FIR Bandpass Filter
Fs = 16200;
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
y_filtered = fir_filter_conv(y,bpfir);
% y_filtered = conv(y,bpfir);
% sound(y_filtered, Fs);

%  Square and plot the output
y_filtered = y_filtered.^2;
axis = 1:length(y_filtered);

figure();
plot(axis,y_filtered);

