%% minotch
function data_filt = minotch(data,freq2notch,epsilon,Fs)
% data_filt = notch_2p(data,freq_notch,epsilon,Fs)
% freq_notch: frecuencia a filtrar (en hz)
% epsilon: "ancho del filtro"
% Fs: frecuencia de sampleo de los datos

omega = 2*pi*freq2notch/Fs; % fs = sampling frequency
num = [1 -2*cos(omega) 1];
den = [1 -2*epsilon*cos(omega) epsilon*epsilon];
data_filt = filter(num,den,data');

end