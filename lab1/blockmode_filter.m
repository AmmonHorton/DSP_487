function out = blockmode_filter(a,bpfir, blocksize)
    height = floor(length(a)/blocksize);
    width = blocksize;
    
    k = reshape(a, [width,height]).';
    [y,zf] = filter(bpfir,1,k(1));
    
    out = zeros(height,width);
    for i = 1:height
        [out(i,:),zf] = filter(bpfir,1,k(i,:),zf);
    end
    out = reshape(out.', [1, width * height]).';

end