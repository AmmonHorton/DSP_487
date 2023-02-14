%% Expirement 2
% Clear all variables
clc, clear, close all;

% Load the variable into the workspace
load("sysIDdata.mat");


% Filter the data using the lms filter
mu = 0.000056;
h_init = zeros(1,length(h_true));

% Filter the input
[filtered,e,h] = lms(p,z,mu,h_init);

% Get the frequency Repsonse for our adaptive filter
[H_true, W] = freqz(h_true);
[H, W] = freqz(h);

% Plot both responses
figure();
hold on;
plot(W,abs(H_true));
plot(W,abs(H));
legend("H true", "H")
hold off;


% Plot the error over time
figure();
t = (1:length(e));
plot(t,e);


%% Expirement 3
clc, clear, close all
% Load the variable into the workspace
load("noiseCancelData.mat");

% Filter the data using the lms filter
mu = 0.00001;
h_init = zeros(1,length(h_true));

% Filter the input
[z_filtered,e,h] = lms(eta2,z2,mu,h_init);

% Get the frequency Repsonse for our adaptive filter
[H_true, W] = freqz(h_true2);
[H, W] = freqz(h);

% Plot both responses
figure();
hold on;
plot(W,abs(H_true));
% plot(W,abs(H));
legend("H true", "H")
hold off;


% Plot the error over time
figure();
t = (1:length(e));
plot(t,e);

% sound(eta, 8000);
% sound(z, 8000);
% sound(z2, 8000);

sound(e(floor(length(e)/2)), 8000);


%% Expirement 4
clc, clear, close all
% Load the variable into the workspace
load("EqualizerData.mat");

% Filter the data using the lms filter
gfirLen = 71;
myfirLen = 80;
mu = 0.00026;
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
legend("H true", "H")
hold off;

% Plot the error over time
% figure();
% t = (1:length(e));
% plot(t,e);

z2_filtered = filter(g, 1, z2);
% sound(x2, 48000);

% sound(z2_filtered, 48000);




