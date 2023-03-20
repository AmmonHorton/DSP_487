clear, clc, close all

% Define Frame size and runtime length
FrameSize = 1024 ;

% Define whether to use averaging filter
alpha = 1;
importdata = 0;

% Define axis scale
ylower = -150;
yupper = 0;


try % VERY IMPORTANT
    if importdata
        [y, Fs] = audioread('mix10 2021.wav');
        ceildiv = ceil(length(y)/FrameSize);
        y = [y.',zeros(1,ceildiv*FrameSize-length(y))];
        y = reshape(y, [FrameSize, ceildiv]);
        input_data = y(1);
    else
        NumChannels = 1;
        Fs = 48000;
        % This sets up the characteristics of recording
        ar = audioDeviceReader(...
        'NumChannels', NumChannels,...
        'BitDepth', '24-bit integer', ...
        'SamplesPerFrame', FrameSize, ...
        'SampleRate', Fs);
        disp('Starting processing');
        input_data = step(ar); % This gets the first block of data from the sound card.
    end
    
    % Define the FFT Axis
    FF = (-0.5:1/FrameSize:0.5 - 1/FrameSize) * Fs;
    % Define run time length
    runlength = 3; % Seconds
    numFrames = runlength * Fs / FrameSize;
    numFrames = 25;

    loop_count = 0;
    figure();
    power = 0;
    time_resp = zeros(1,numFrames);
    while loop_count <= numFrames
        loop_count = loop_count + 1;
        %%%%%% Put your dsp code or function call here! %%%%%%%%%%%%%%%
        
        % Change between FFT's algorithms
        tic
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         fft_out = fft(input_data, FrameSize)/FrameSize;
%         fft_out = myfft(input_data, FrameSize)/FrameSize;
        fft_out = dft(input_data,FrameSize);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        time_resp(loop_count) = toc;

        % Plot the power for a given output
        power = (1-alpha)*20*log10(fftshift(real(fft_out).^2 + imag(fft_out).^2) + 1e-7) + alpha*power;
        plot(FF(floor(FrameSize/2):end), power(floor(FrameSize/2):end));
        title('Spectrum Analyzer')
        xlabel('Frequency (Hz)')
        ylabel('Power (uncalibrated dB)')
        ylim([ylower,  yupper]);
        xlim([0,Fs/2]);

        drawnow        
        if importdata
            input_data = y(loop_count);
        else
            input_data = step(ar);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end
    time_resp = mean(time_resp);
    disp(time_resp)

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
