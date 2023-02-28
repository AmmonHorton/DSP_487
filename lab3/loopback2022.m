% These are important parameters for your sound card. They specify the
% sample rate and essentially the size of the block of data that you will
% periodically receive from the sound card.
Fs = 48000;
FrameSize = 2048 ;
FF = (-0.5:1/FrameSize:0.5 - 1/FrameSize) * Fs;
NumChannels = 1;

runlength = 3; % Seconds
numFrames = runlength * Fs / FrameSize;
% numFrames = 100;

ylower = -150;
yupper = 0;

alpha = 0.99;
% Create the fir filter he

% Import the audio clip
% [y, Fs] = audioread('mix10 2021.wav');

try % VERY IMPORTANT

    % This sets up the characteristics of recording
    ar = audioDeviceReader(...
    'NumChannels', NumChannels,...
    'BitDepth', '24-bit integer', ...
    'SamplesPerFrame', FrameSize, ...
    'SampleRate', Fs);


    

    % This records the first set of data
    disp('Starting processing');
    input_data = step(ar); % This gets the first block of data from the sound card.
    y_in = y(1:FrameSize);

    % [y,zf] = filter(bpfir,1,input_data); % Filter the first block
    loop_count = 0;
    figure();
    power = 0;
%     i = 1;
    tic
    while loop_count <= numFrames
        loop_count = loop_count + 1;
        
        %%%%%% Put your dsp code or function call here! %%%%%%%%%%%%%%%
        fft_out = fft(input_data, FrameSize)/FrameSize;
        power = (1-alpha)*20*log10(fftshift(real(fft_out).^2 + imag(fft_out).^2) + 1e-7) + alpha*power;
%         power = (fftshift(real(fft_out).^2 + imag(fft_out).^2) + 1e-7);
        plot(FF(floor(FrameSize/2):end), power(floor(FrameSize/2):end));
        title('Spectrum Analyzer')
        xlabel('Frequency (Hz)')
        ylabel('Power (uncalibrated dB)')
        ylim([ylower,  yupper]);
        xlim([0,Fs/2]);
%         xlim([0, 2500]);

        drawnow
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        input_data = step(ar);   
%         y_in = y(i*1024:(i+1)*1024 - 1);
    end
    toc
    
    % peaks = 10.^(findpeaks(power)/20);

    % You want to make sure that you release the system resources after using
    % them and they don't get tied up.
    release(ar)
    release(ap)

    % The following statements are really important so that you don't cause
    % problems and hang system resources when you actually terminate inside of
    % the loop. Otherwise, you need to restart MATLAB if you hit certain kinds
    % of errors.
catch err 
        release(ar)
        release(ap)
        rethrow(err)
end
