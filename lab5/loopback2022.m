clear, clc, close all

% Define Frame size and runtime length
FrameSize = 1024 ;
spacing = 0.4;
freq = 1000;
speedOfSound = 343;
dist = spacing * speedOfSound/freq;

% runlength = 3; % Seconds
% numFrames = runlength * Fs / FrameSize;
numFrames = 200;


% Define whether to use averaging filter
alpha = 1;
importdata = 1;


try % VERY IMPORTANT
    if importdata
        offset = 0;
        real_doa = -90;
        Fs = 4000;

        data_size = 1e5;
        t = (0:data_size)*1/Fs;
        
        y1 = cos(t*2*pi*freq);
        phs_shft = 2*pi*spacing*sin((real_doa)*pi/180);
        y2 = cos(t*2*pi*freq + phs_shft);

        y = [y1.',y2.'];

        ceildiv = ceil(length(y(:,1))/FrameSize);
        y = [y.',zeros(2,ceildiv*FrameSize-length(y))];
        y1 = reshape(y(1,:), [FrameSize, ceildiv]);
        y2 = reshape(y(2,:), [FrameSize, ceildiv]);
        input1 = y1(:,1).';
        input2 = y2(:,1).';
    else
        offset = pi + 0.6073;
        NumChannels = 2;
        Fs = 4000;
        % This sets up the characteristics of recording
        ar = audioDeviceReader(...
        'NumChannels', NumChannels,...
        'BitDepth', '24-bit integer', ...
        'SamplesPerFrame', FrameSize, ...
        'SampleRate', Fs);
        disp('Starting processing');
        input_data = step(ar).'; % This gets the first block of data from the sound card.
        input1 = input_data(1,:);
        input2 = input_data(2,:);
    end

    filter_len = FrameSize/4;
    N = floor(filter_len/2);
    lpcoef = 2*Fs/(3*Fs);
    bpfir = lpcoef*sinc((-N:N)*lpcoef);
    bpfir = bpfir.' .* blackman(length(bpfir));

    [y,zf1_r] = filter(bpfir,1,input1); % Filter the first block
    zf1_i = zf1_r;
    zf2_r = zf1_r;
    zf2_i = zf1_r;

%     mixing_arry = [1,1j,-1,-1j];
%     repeats = FrameSize / length(mixing_arry);
    mixing_arry = exp(1j*2*pi*(0:FrameSize-1)*freq/Fs);

    DoA = 0;
    loop_count = 0;
    % while loop_count <= numFrames
    while true
        loop_count = loop_count + 1;
        
        % plot(20*log10(abs(fftshift(fft(input1)))))

        % Mix down to badeband (0 Hz)
        real_mix = real(mixing_arry);
        imag_mix = imag(mixing_arry);


        input1_r = real_mix .* input1;
        input1_i = imag_mix .* input1;
        input2_r = real_mix .* input2;
        input2_i = imag_mix .* input2;

        % plot(20*log10(abs(fftshift(fft(input1_r)))))

        % Filter the inputs after mixing
        [input1_r,zf1_r] = filter(bpfir,1,input1_r,zf1_r);
        [input1_i,zf1_i] = filter(bpfir,1,input1_i,zf1_i);
        [input2_r,zf2_r] = filter(bpfir,1,input2_r,zf2_r);
        [input2_i,zf2_i] = filter(bpfir,1,input2_i,zf2_i);
        
        filt_out1 = input1_r + 1j*input1_i;
        filt_out2 = input2_r + 1j*input2_i;

        % plot(20*log10(abs(fftshift(fft(filt_input1)))))


        % Sum complex conijugate multiply to average the phase angle
        complx_num = sum(filt_out1 .* conj(filt_out2));
        average_phase = mod(angle(complx_num) - offset, 2*pi);
        current_DoA = (average_phase/(4*spacing)) * 180/pi;
        % current_DoA = 180/pi*asin(average_phase/(2*pi*2*spacing));
        % DoA = (1-alpha)*current_DoA + alpha*DoA;
        disp("Avg Phase: " + string(average_phase));
        disp("DoA: " + string(current_DoA));
        
        if importdata
            input1 = y1(:,loop_count).';
            input2 = y2(:,loop_count).';
        else
            input_data = step(ar).';
            input1 = input_data(1,:);
            input2 = input_data(2,:);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end


    % You want to make sure that you release the system resources after using
    % them and they don't get tied up.
    if ~importdata
        release(ar)
    end
catch err 
    if ~importdata
        release(ar)
    end
    rethrow(err)
end
