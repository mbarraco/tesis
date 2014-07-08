function [Y , frecuencias, time] = miwproyeccion(data,frange,nint,mallado,Fs,armonic) 
%[Y , frecuencias, time] = miwproyeccion(data,wrange,nint,mallado,Fs,armonic) 
% En esta funcion tomamos una señal y buscamos su proyeccion sobre un subespacio compuesto por senos y cosenos
% de una frecuencia fundamental y uno o dos armonicos. Es, en definitiva, Fourier.
% Devuelve la norma de Frobenius de la proyecciòn menos la señal.  
	
	num_samples=floor(length(data)/nint); % cantidad de samples por intervalo
	frecuencias = linspace(frange(1),frange(2),mallado);
	time = (1:size(data,1))/Fs;
	time = time(1:num_samples);%tiempo para cada intervalo
	tic
	for i=1:length(frecuencias)-1;
	    w = 2*pi*frecuencias(i) ;
		switch armonic
			case 1
				A= [ones(size(time))' cos(w*time)' sin(w*time)'];
			case 2
				A= [ones(size(time))' cos(w*time)' sin(w*time)' cos(2*w*time)' sin(2*w*time)'];			
			case 3
				A= [ones(size(time))' cos(w*time)' sin(w*time)' cos(2*w*time)' sin(2*w*time)' cos(3*w*time)' sin(3*w*time)'];
		end
		
		for int=1:nint
	        signal=data(num_samples*(int-1)+1:num_samples*int,:);
	        coef= A\signal;
			Y(int,i)=norm(A*coef-signal,'fro');	
	    end
	    
	end
	toc
end
