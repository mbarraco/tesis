function [Y, frecuencias] = mifftplot(data,Fs)

[data_fft frecuencias] = mifft(data,Fs);

plot(frecuencias, abs(data_fft),'o')
xlabel('Frecuencias [hz]')
ylabel('abs(fft)')

for canal=1:size(data_fft,1)
	leg{canal}= ['canal:' num2str(canal) '°'];
end
legend(leg)

end