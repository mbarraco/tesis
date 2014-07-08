%% notch response
function h  = notch_response(frecuencias,epsilon,freq_notch,Fs)
% frequency response of a 2z2p-notch filter
% [h freq] = notch_response(frecuencias,epsilon,freq_notch,Fs)
% num y den son los vectores con 

omega = 2*pi*freq_notch/Fs; % fs = sampling frequency
b= [1 -2*cos(omega) 1];
a = [1 -2*epsilon*cos(omega) epsilon*epsilon];
% f=linspace(0,1,length(data_fft))*Fs/2; %frecuencias
f=frecuencias/Fs;
h = abs(b(1) + b(2)* exp(-i*2*pi*f) + b(3)*exp(-i*4*pi*f))./abs(a(1) + a(2)* exp(-i*2*pi*f) + a(3)*exp(-i*4*pi*f));
plot(frecuencias,h,'o')	
end