%% Expirement 2
% Clear all variables
clc, clear, close all;

% Load the variable into the workspace
load("sysIDdata.mat");


% Filter the data using the lms filter
mu = 0.00056;
h_init = zeros(1,length(h_true));

% Filter the input
[filtered,e,h] = lms(p,z,mu,h_init);
% [filtered,e,h] = lms(p,z,mu,h);

% Get the frequency Repsonse for our adaptive filter
[H_true, W] = freqz(h_true);
[H, W] = freqz(h);

% Plot both responses
figure();
hold on;
plot(W,abs(H_true));
plot(W,abs(H));
legend("H true", "H")
title("Filter frequency response")
xlabel("Radians/sample")
ylabel("Magnitude")
hold off;


% Plot the error over time
figure();
t = (1:length(e));
plot(t,e);
title("Error over time")
xlabel("Sample")
ylabel("Error")

% plot h and h_true on same graph
figure();
hold on;
plot(h);
plot(h_true);
legend("h", "h true");
title("h vs h true")
xlabel("Radians/sample")
ylabel("Magnitude")
hold off


%% Experiment 3
clc, clear, close all
% Load the variable into the workspace
load("noiseCancelData.mat");

% Filter the data using the lms filter
mu = 0.001;
h_init = zeros(1,length(h_true));

% Filter the input
[z_filtered,e,h] = lms(eta,z,mu,h_init);

% Get the frequency response for our adaptive filter
[H_true, W] = freqz(h_true);
[H, W] = freqz(h);

% Plot both responses
figure();
hold on;
plot(W,abs(H_true));
plot(W,abs(H));
legend("H true", "H")
title("Filter frequency response")
xlabel("Radians/sample")
ylabel("Magnitude")
hold off;


% Plot the error over time
figure();
t = (1:length(e));
plot(t,e);
title("Error over time of eta")
xlabel("Sample")
ylabel("Error")

% sound(eta, 8000);
% sound(z, 8000);
% sound(z2, 8000);

sound(e(floor(length(e)/2)), 8000);


%% Experiment 4
clc, clear, close all
% Load the variable into the workspace
load("EqualizerData.mat");

% Filter the data using the lms filter
gfirLen = 71;
myfirLen = 91;
mu = 0.016;
h_init = zeros(1,myfirLen);

% Delay the reference
delay = floor((gfirLen+myfirLen)/2);
t_delay = zeros(length(t),1);

t_delay(delay+1:end) = t(1:end-delay);

% Filter the input
[filtered,e,g] = lms(z,t_delay,mu,h_init);


% Get the frequency Repsonse for our adaptive filter
[G_true, W] = freqz(g_true);
[G, W] = freqz(g);

% Compare the frequency repsonses
figure();
hold on;
plot(W,abs(G_true));
plot(W,abs(G));
plot(W,abs(1./G_true))
legend("G true", "H", "G inverse")
title("Filter frequency response")
xlabel("Radians/sample")
ylabel("Magnitude")
hold off;

% Plot the error over time
figure();
t = (1:length(e));
plot(t,e);
title("Error over time")
xlabel("Sample")
ylabel("Error")

z2_filtered = filter(g, 1, z2);
% sound(x2, 48000);

% sound(z2_filtered, 48000);




