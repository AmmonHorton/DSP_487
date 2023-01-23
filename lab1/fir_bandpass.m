% FIR Bandpass Filter

centerFreq = 3e3;
firWinLength = 81;
bandwidth = 600;

fsample = 18e3;

% Create the bandpass filter by making two low pass filters and doing a spectral inversion the latter
N = firWinLength/4;
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


bpfir = bpfir .* hamming(firWinLength).';
length(bpfir)

figure();
freqz(bpfir);
