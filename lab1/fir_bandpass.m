function fir = fir_bandpass(Fs,Fc,bw,len)
    % Create the bandpass filter by making two low pass filters and doing a spectral inversion the latter
    N = floor(len/4);
    n = (-N:N);

    lpcoef = 2 * (Fc+bw);
    hpcoef = 2 * (Fc-bw);
    lpcoef = lpcoef / Fs;
    hpcoef = (Fs - hpcoef) / Fs;
    lpfir = lpcoef * sinc(lpcoef*n);
    hpfir = hpcoef * sinc(hpcoef*n);

    % Spectral Reversal
    hpfir(1:2:end) = -hpfir(1:2:end);
    
    % Convolve the two to create bandpass filter
    bpfir = conv(hpfir,lpfir);

    % Apply the window
    bpfir = bpfir .* blackman(len).';
    fir = bpfir;
end
