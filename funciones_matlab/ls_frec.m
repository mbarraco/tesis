function [Y, frecuencias, data_int] = ls_frec(data,Fs,nint,w_rango,mallado,armonic)
% ls_frec(data,Fs,num_intervalos,w_rango,mallado)  
% Y (nint x w) con la norma del ajuste  menos la senhal.
% w_rango = [w_min w_max] son las frecuencias de corte para el analisis 
% data debe tener dimensiones: 1 x samples \n')
%armonico = 1, 2 ó 3 es la cantidad de elementos en el subespacio 
% frecuencias
frecuencias = linspace(w_rango(1),w_rango(2),mallado);
time = (1:size(data,1))/Fs;

Y = NaN(nint,length(frecuencias));% output
num_samples=floor(length(data)/nint); % cantidad de samples por intervalo
data_int=NaN(nint,num_samples);       % guardo cada intervalo de data en una matriz

for i=1:nint
	data_int(i,:)=data(num_samples*(i-1)+1:num_samples*i);
end
time_int = time(1:num_samples);      %tiempos para cada intervalos
for int=1:nint
	tic
	s=data_int(int,:);
	for i=1:length(frecuencias)-1;
		if(frecuencias(i)~=0)
			w = 2*pi*frecuencias(i) ;
			switch armonic
				case 1
					A= [ones(size(time_int))' cos(w*time_int)' sin(w*time_int)'];
				case 2
					A= [ones(size(time_int))' cos(w*time_int)' sin(w*time_int)' cos(2*w*time_int)' sin(2*w*time_int)'];
				case 3
					A= [ones(size(time_int))' cos(w*time_int)' sin(w*time_int)' cos(2*w*time_int)' sin(2*w*time_int)' cos(3*w*time_int)' sin(3*w*time_int)'];
			end
			coef= A\s';
			Y(int,i)=norm(A*coef-s');
		end
	end
	toc
end


end

