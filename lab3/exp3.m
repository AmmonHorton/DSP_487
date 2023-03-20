%% Spectrogram

% Import the audio clip
clear, clc, close all
[y, Fs] = audioread('GeekCubed.wav');
load('fricatives.mat')
load('plosives.mat')
Fs = 8000;
y_fr = recObj_fr;
y_pl = recObj_pl;
y = y_pl;

N = length(y);
M = 1000;
percent_overlap = 0.8;
L = floor(percent_overlap*M);
g = rectwin(M);
Nfft = 2048;
chunk = floor(N/10);

% figure();
spectrogram(y, g, L, Nfft, Fs, 'yaxis');

% Procced if you want longer windows
% for i=1:chunk
%     figure(i);
%     spectrogram(y(((i-1)*chunk)+1:i*chunk), g, L, Nfft, Fs, 'yaxis')
%     spectrogram(y, 'yaxis')
% end