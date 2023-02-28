%% Spectrogram

% Import the audio clip
[y, Fs] = audioread('GeekCubed.wav');

N = length(y);
M = 1000;
percent_overlap = 0.8;
L = floor(percent_overlap*M);
g = rectwin(M);
Nfft = 2048;

chunk = floor(N/10);


for i=0:chunk-1
    figure(i+1)
    spectrogram(y((i*chunk)+1:(i+1)*chunk), g, L, Nfft, Fs, 'yaxis')
    % spectrogram(y, 'yaxis')
end