% Clear all variables
clc, close, clear all;

% Load the variable into the workspace
load("sysIDdata.mat");


% Filter the data using the lms filter
mu = -0.000009;
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


