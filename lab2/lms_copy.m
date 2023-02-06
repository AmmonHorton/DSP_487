function [y, e, h] = lms_copy(x, d, mu, h_init)
    % LMS adaptive filter algorithm
    
    % First, define the Initial Filter
    h = h_init;
    flen = length(h_init);
    % First, compute the output data for the current block
    len = length(x) - length(h_init);
    y = zeros(1,len);
    e = zeros(1,len);
    for i = flen:length(x)
        % Compute the dot product of slices to represent Delay-Chain, 
        % taps & summation
        slc = x(i:-1:i-length(h_init)+1).';

        % slcud = flipud(slc.').';

        refIn = d(i);
        out = slc * h.';
        error = refIn - out;

        y(i-flen+1) =  out;
        e(i-flen+1) = error;
        h = h+(slc*error*mu);
    end
end

