function [y, e, h] = lms(x, d, mu, h_init)
    % LMS adaptive filter algorithm
    
    % First, define the Initial Filter
    h = h_init;
    flen = length(h_init);

    % First, compute the output data for the current block
    len = length(x) - flen;
    y = zeros(1,len);
    e = zeros(1,len);
    for i = 1:len
        % Compute the dot product of slices to represent Delay-Chain, 
        % taps & summation
        slc = x(i:i+length(h_init)-1).';
        slcud = flipud(slc.').';
        y(i) = slcud * h.';

        % Compute the error, and find new fir coefficients
        e(i) = d(i+flen-1) - y(i);
        h = h+(slcud*e(i)*mu);
    end
end

