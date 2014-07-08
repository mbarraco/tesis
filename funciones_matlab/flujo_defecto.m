function [flujo_defect,dphi_defect,tdefect] = flujo_defecto(defect_type,filename_2,espira,YCM,RPM,corrientes) 
% Calculamos el flujo y la FEM para distintas posiciones verticales de la
% espira. 
disp('|____________________________________________________________|')
disp('|____________________>   FLUJO_DEFECTO  <____________________|')
disp('|____________________________________________________________|')

adress =['D:\Compartido\mariano\02_Flujo_magnetico\datos\amalog2d_v3_' defect_type '_OD_244mm_WT_14mm_gap_10mm\'];
% adress =['/home/rm/Dropbox/2011_02_Tesis/compartido-mariano/02_Flujo_magnetico/datos/amalog2d_v3_' defect_type '_OD_244mm_WT_14mm_gap_10mm/'];
% adress =['/home/m/Dropbox/Exactas/2011_02_Tesis/compartido-mariano/02_Flujo_magnetico/datos/amalog2d_v3_' defect_type '_OD_244mm_WT_14mm_gap_10mm/'];

load(filename_2)

[THETA RHO] = meshgrid(angulos+(pi/2),radios);% grilla interpolacion
for I=1:length(corrientes)
	tic
	for rpm=1:length(RPM)
		load([ adress 'amalog2d_v3_' defect_type '_OD_244mm_WT_14mm_gap_10mm_' num2str(RPM(rpm)) 'rpm_I_' num2str(corrientes(I)) 'mA.mat']);
		for ycm=1:length(YCM)
			r1= [ -espira.lx , YCM(ycm)];
			r2= [  espira.lx , YCM(ycm)];
            
			[theta_1 rho_1] = cart2pol(r1(1), r1(2));
			[theta_2 rho_2] = cart2pol(r2(1), r2(2));
			
			for t=1:length(tlist)
				aux1= interp2(THETA,RHO,Az(:,:,t),theta_1,rho_1);
				aux2= interp2(THETA,RHO,Az(:,:,t),theta_2,rho_2);
				
				%output 1
				flujo_defect(t,ycm,I,rpm) = espira.lz*(aux2 - aux1);% [] = T.m^2
			end
			
			dt=tlist(2)-tlist(1);
			%output 2
			dphi_defect(:,ycm,I,rpm) = diff(flujo_defect(:,ycm,I,rpm),1,1)/dt;% [] = T.m^2/s
			
			
		end
		%output 3
		tdefect(:,I,rpm) = tlist';
	end
	toc
   	disp(['Corriente ' num2str(I) ' de ' num2str(length(corrientes))])
end

