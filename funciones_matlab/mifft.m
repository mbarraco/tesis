function [Y, freq] = mifft(data,Fs,flag)
% -> [Y, freq] = mifft(data,Fs,flag) 
% -> data es un vector o una matriz de CANALES x SAMPLES
% -> Fs es la frecuencia de sampleo de los datos.		 
% -> Y es una matriz de CANALES x SAMPLES/2  con cada ff.
% -> flag =1 dibuja la FFT de todos los canales en una nueva figura
L=(1:size(data,1));
Y=[];
for i=1:size(data,2)
	y = data(:,i);
	L = size(y,1);          % Length of signal
	NFFT = 2^nextpow2(L);		  % Next power of 2 from length of y
	freq = linspace(0,1,NFFT/2+1)*Fs/2;
	aux = fft(y,NFFT)/L;
	Y(:,i) = aux(1:NFFT/2+1);
end

if(flag==1)
    figure; hold all
    for i=1:size(data,2)
        plot(freq,abs(Y(:,i)))
    end
    grid
    xlabel('Frecuencia [Hz]')
    ylabel('Abs(C_n)')
end
