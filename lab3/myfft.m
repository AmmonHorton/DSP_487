function X = myfft(x, N)
if N > 2
    g = x(2:2:end);
    h = x(1:2:end);
    G = myfft(g, N/2);
    H = myfft(h, N/2);
    
    W_N = exp(-1j*2*pi/N);
    for k = 0:N/2-1
        X(k+1) = G(k+1) + W_N^k*H(k+1);
    end
    for k = N/2:N-1
        X(k+1) = G(k+1 - N/2) + W_N^k*H(k+1-N/2);
    end
else 
    if N == 2
        X(1) = x(1) + x(2);
        X(2) = x(1) - x(2);
    end
end

            