function [campo, tdefect] = campo_defecto(defect_type,filename_2,espira,YCM,RPM,corrientes) 
% Calculamos el flujo y la FEM para distintas posiciones verticales de la
% espira. 
disp('|____________________>   CAMPO DEFECTO  <____________________|')

adress =['D:\Compartido\mariano\02_Flujo_magnetico\datos\amalog2d_v3_' defect_type '_OD_244mm_WT_14mm_gap_10mm\'];
% adress =['/home/rm/Dropbox/2011_02_Tesis/compartido-mariano/02_Flujo_magnetico/datos/amalog2d_v3_' defect_type '_OD_244mm_WT_14mm_gap_10mm/'];
% adress =['/home/m/Dropbox/Exactas/2011_02_Tesis/compartido-mariano/02_Flujo_magnetico/datos/amalog2d_v3_' defect_type '_OD_244mm_WT_14mm_gap_10mm/'];

load(filename_2)
aux_1=find(YCM>radios);
aux_1=aux_1(end);
aux_2=find(YCM<radios);
aux_2=aux_2(1);
ind = [aux_1 aux_2]

[THETA RHO] = meshgrid(angulos+(pi/2),radios);% grilla interpolacion


for I=1:length(corrientes)
	tic
	for rpm=1:length(RPM)
		load([ adress 'amalog2d_v3_' defect_type '_OD_244mm_WT_14mm_gap_10mm_' num2str(RPM(rpm)) 'rpm_I_' num2str(corrientes(I)) 'mA.mat']);
		Az=squeeze(mean(Az(ind,[50 51],:),2));
		campo(:,I,rpm)=squeeze(diff(Az,1,1));
		tdefect(:,I,rpm) = tlist';
	end
	toc
	disp(['Corriente ' num2str(I) ' de ' num2str(length(corrientes))])
end
