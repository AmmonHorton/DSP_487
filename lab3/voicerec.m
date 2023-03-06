clear, clc, close all

fs = 8000;
recObj_fr = audiorecorder();
recObj_pl = audiorecorder();

recDuration = 1;
disp("Pronounce Sashay, Frankfurt.");
recordblocking(recObj_fr,recDuration);
recObj_fr = getaudiodata(recObj_fr);
save("fricatives.mat","recObj_fr")

disp("Pronounce Plot, Hyperbole");
recordblocking(recObj_pl,recDuration);
recObj_pl = getaudiodata(recObj_pl);
save("plosives.mat","recObj_pl")


% sound(recObj_fr,fs)
% sound(recObj_pl,fs)
