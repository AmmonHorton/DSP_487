clear, clc, close all

% Define Frame size and runtime length
FrameSize = 2*1024 ;
freq = 1000;
speedOfSound = 343;

% runlength = 3; % Seconds
% numFrames = runlength * Fs / FrameSize;
numFrames = 200;


% Define whether to use averaging filter
alpha = 1;
importdata = 0;


try % VERY IMPORTANT
    if importdata
        offset = 0;
        spacing = 0.6;
        max_phase = 180 * spacing;

        real_doa = 90;
        Fs = 16000;

        data_size = numFrames * FrameSize;
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
        offset = -155;%pi + 0.6073;
        spacing = 0.3;
        max_phase = 60;
        NumChannels = 2;
        Fs = 16000;
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

    filter_len = FrameSize/10;
%     N = floor(filter_len/2);
%     lpcoef = 1/10;
%     bpfir = lpcoef*sinc((-N:N)*lpcoef);
%     bpfir = bpfir.' .* blackman(length(bpfir));

    bpfir = firpm(41, [0,0.1,0.15,1], [1,1,0,0]);
    
    figure();
    freqz(bpfir);

    [y,zf1_r] = filter(bpfir,1,input1); % Filter the first block
    zf1_i = zf1_r;
    zf2_r = zf1_r;
    zf2_i = zf1_r;

%     mixing_arry = [1,1j,-1,-1j];
%     repeats = FrameSize / length(mixing_arry);
    mixing_arry = exp(1j*2*pi*(0:FrameSize-1)*freq/Fs);

    DoA = 0;
    loop_count = 0;
    FF = (-0.5:1/FrameSize:0.5 - 1/FrameSize) * Fs;

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

        fft_out = fft(filt_out2, FrameSize)/FrameSize;
        fft_plot = 20*log10(fftshift(real(fft_out).^2 + imag(fft_out).^2) + 1e-7);
        plot(FF, fft_plot);
        drawnow


        % Sum complex conijugate multiply to average the phase angle
        complx_num = sum(filt_out1 .* conj(filt_out2));
        phase = atan2(imag(complx_num),real(complx_num));
        average_phase = (mod(phase + pi - offset*pi/180, 2*pi) - pi) * 180/pi;
        % -50, -5, 70
%         if average_phase < 0
%             phs_ratio = average_phase / 50;
%         else
%             phs_ratio = average_phase / 70;
%         end
        phs_ratio = average_phase / max_phase;

        if abs(phs_ratio) > 1
            phs_ratio = 1 * sign(phs_ratio);
        end


        % current_DoA = (average_phase/(2*spacing)) * 180/pi;
        current_DoA = 180/pi*asin(phs_ratio);
        
        alpha = 0.8;
        DoA = (1-alpha)*current_DoA + alpha*DoA;

        disp("Avg Phase: " + string(average_phase));
        disp("Phase: Ratio " + string(phs_ratio));
%         disp("DoA: " + string(current_DoA));
        disp("DoA: " + string(DoA));
        
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
