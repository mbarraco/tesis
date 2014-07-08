function  norma = miproyeccion(data,wrango,mallado,num_int,Fs)
% mallado=1000;
% wrango = [10 60];
% num_int = 4;
% canales = (1:4);
% data_05 = data(canales,:);

aux=data;
norma=NaN(num_int,mallado,size(aux,1));

for canal=1:size(data,1)
	[norma(:,:,canal)  frecuencias] =ls_frec(aux,Fs,num_int,wrango,mallado);
end


% for canal=1:size(data,1)
% 	figure(500 + canal)
% 	for int=1:num_int
% 		plot(frecuencias,norma(int,:,canal))
% 		ylabel('norma')
% 	end
% 	xlabel('frecuencia [hz]')
% end
end