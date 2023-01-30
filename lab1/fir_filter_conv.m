function out = fir_filter_conv(a,fir)
    len = length(a) - length(fir);
    out = zeros(1,len);
    for i = 1:len
        % Compute the dot product of slices to represent Delay-Chain, 
        % taps & summation
        slc = a(i:i+length(fir)-1).';
        out(i) = slc * fir.';
    end
end