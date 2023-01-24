clear all;

% FIR Bandpass Filter
centerFreq = 3e3;
firWinLength = 101;
bandwidth = 400;

fsample = 16200;

% Create the bandpass filter by making two low pass filters and doing a spectral inversion the latter
N = floor(firWinLength/4);
n = (-N:N);
%n = n - floor(N/2)
lpcoef = 2 * (centerFreq+bandwidth);
hpcoef = 2 * (centerFreq-bandwidth);


lpcoef = lpcoef / fsample;
hpcoef = (fsample - hpcoef) / fsample;
lpfir = lpcoef * sinc(lpcoef*n);
hpfir = hpcoef * sinc(hpcoef*n);

% Spectral Reversal
hpfir(1:2:end) = -hpfir(1:2:end);



% Convolve the two to create bandpass filter
bpfir = conv(hpfir,lpfir);
figure();
freqz(bpfir);

bpfir = bpfir .* blackman(firWinLength).';
% bpfir = bpfir .* hamming(firWinLength).';

figure();
freqz(bpfir);


[y, Fs] = audioread('mix10 2021.wav');

y_filtered = conv(y,bpfir);
% sound(y_filtered, Fs);


y_filtered = y_filtered.^2;
axis = 1:length(y_filtered);

figure();
plot(axis,y_filtered);


