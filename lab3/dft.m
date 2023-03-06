function y = dft(x,N)
    y = zeros(1,N);
    for k = 1:N
        for n = 1:N
            W_N = exp(-1j*2*pi*n*k/N);
            y(k) = y(k) + x(n)*W_N;
    
        end
    end
end