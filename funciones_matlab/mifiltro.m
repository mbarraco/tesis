function Y = mifiltro(data,freq2notch,epsilon,showresponse,frecuencias);
Fs=4000;
% epsilon=0.999;
% freq2notch= [991.5 992.6]
% showresponse=1;

ind = find(frecuencias>freq2notch(1) & frecuencias<freq2notch(2));
freqs = frecuencias(ind);

Y=NaN(size(data));
for i=1:size(data,2)
    aux=data(:,i);
    for j=1:length(freqs)
        % 	Y = minotch(Y,freqs(i),epsilon,Fs);
        omega = 2*pi*freqs(j)/Fs; % fs = sampling frequency
        num = [1 -2*cos(omega) 1];
        den = [1 -2*epsilon*cos(omega) epsilon*epsilon];
        aux = filter(num,den,aux);
        
        if(showresponse)
            figure('name',['notch W=' num2str(freqs(i))],'numbertitle','off')
            NFFT = 2^nextpow2(size(data,2));
            freq = Fs/2*linspace(0,1,NFFT/2+1);
            notch_response(freq,epsilon,freqs(i),Fs);
        end
    end
    Y(:,i)=aux;
end
end

