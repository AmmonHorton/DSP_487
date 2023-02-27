% These are important parameters for your sound card. They specify the
% sample rate and essentially the size of the block of data that you will
% periodically receive from the sound card.
Fs = 48000;
FrameSize = 1024;
FF = -0.5:1/FrameSize:0.5 - 1/FrameSize;
NumChannels = 1;

runlength = 15; % Seconds
numFrames = runlength * Fs / FrameSize;

% Create the fir filter here


try % VERY IMPORTANT

    % This sets up the characteristics of recording
    ar = audioDeviceReader(...
    'NumChannels', NumChannels,...
    'BitDepth', '24-bit integer', ...
    'SamplesPerFrame', FrameSize, ...
    'SampleRate', Fs);

    % This sets up the characteristics of playback
    ap = audioDeviceWriter(...
    'SampleRate', Fs, ...
    'BufferSize', FrameSize, ...
    'BitDepth', '24-bit integer');

    

    % This records the first set of data
    disp('Starting processing');
    input_data = step(ar); % This gets the first block of data from the sound card.

    % [y,zf] = filter(bpfir,1,input_data); % Filter the first block
    loop_count = 0;
    figure();
    while loop_count <= numFrames
        loop_count = loop_count + 1;
        
        %%%%%% Put your dsp code or function call here! %%%%%%%%%%%%%%%
        fft_out = fft(input_data, FrameSize);
        plot(FF, (fftshift(real(fft_out).^2 + imag(fft_out).^2)));

        drawnow
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        step(ap, y_data);
        input_data = step(ar);        
    end

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
