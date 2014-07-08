function [campo, tdefect] = campo_hall_defecto(defect_type,filename_2,YCM,RPM,corrientes) 
% Calculamos el flujo y la FEM para distintas posiciones verticales de la
% espira. 
first = @(v) v(1);
disp('|___________________   Campo Defecto ___________________|')

% adress =['D:\Compartido\mariano\02_Flujo_magnetico\datos\amalog2d_v3_' defect_type '_OD_244mm_WT_14mm_gap_10mm\'];
% adress =['/home/rm/Dropbox/2011_02_Tesis/compartido-mariano/02_Flujo_magnetico/datos/amalog2d_v3_' defect_type '_OD_244mm_WT_14mm_gap_10mm/'];
adress =['/home/m/Dropbox/Exactas/2011_02_Tesis/compartido-mariano/02_Flujo_magnetico/datos/amalog2d_v3_' defect_type '_OD_244mm_WT_14mm_gap_10mm/'];


load(filename_2)

rhos = radios + 0.2440/2;

aux_1=find(YCM>rhos);
aux_1=aux_1(end);
aux_2=find(YCM<rhos);
aux_2=aux_2(1);
ind_rho = [aux_1 aux_2];
% ind_theta = [floor(size(A,1)/2) , floor(size(A,1)/2)+1]; %sensor en theta=0

drho = radios(1,2)-radios(1,1);
dtheta = angulos(1,2)-angulos(1,1);


for I=1:length(corrientes)
	for rpm=1:length(RPM)
		load([ adress 'amalog2d_v3_' defect_type '_OD_244mm_WT_14mm_gap_10mm_' num2str(RPM(rpm)) 'rpm_I_' num2str(corrientes(I)) 'mA.mat']);

		if(first(factor(size(Az,2)))~=2)
			ind_theta = [floor(size(Az,2)/2) floor(size(Az,2)/2)+2];
		else
			ind_theta = [floor(size(Az,2)/2) , floor(size(Az,2)/2)+1];
		end
		
		Az=Az(ind_rho,ind_theta,:);
		
        B_rho =-squeeze(diff(Az,1,2))/dtheta/mean(rhos(1,ind_rho));%[T]
        B_rho=squeeze(mean(B_rho  ,1));
        
        campo(:,I,rpm)= B_rho;
        
        tdefect(:,I,rpm) = tlist';
    end
	disp(['Corriente ' num2str(I) ' de ' num2str(length(corrientes))])
end
