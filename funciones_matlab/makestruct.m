%% makestruct
function estructura = makestruct(path_name)
% makestruct(nombre)
% Crea una estructura de datos. La rutina tiene como input el path hasta el
% direcorio de donde sacar los archivos

cd(path_name);
archivos=dir('*.sig');%elijo la extensi�n adecuada

aux_struc = struct([]);
for j=1:length(archivos)
	aux_struc(end+1).file=load(archivos(j).name);
	aux_struc(end).name=archivos(j).name;
end
estructura = aux_struc;

end