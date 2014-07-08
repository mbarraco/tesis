function [campo,   tcost] = campo_hall_costelatura(espira,corrientes,YCM,RPM,adress)
first = @(v) v(1);
disp('|___________________   Campo Costelatura  _____________________|')

load([adress 'grilla_v4.mat'])

rhos = radios + 0.2440/2;

aux_1=find(YCM>=rhos );
aux_1=aux_1(end);
aux_2=find(YCM<=rhos);
aux_2=aux_2(1);
ind_rho = [aux_1 aux_2];

drho = radios(1,2)-radios(1,1);
dtheta = angulos(1,2)-angulos(1,1);
for I=1:length(corrientes)
	for rpm=1:length(RPM)
		filename = [ adress 'amalog2d_v4_3_OD_244mm_WT_14mm_gap_10mm_' num2str(RPM(rpm)) 'rpm_I_' num2str(corrientes(I)) 'mA.mat'];
		load(filename)		
		if(first(factor(size(Az1,2)))~=2)
			ind_theta = [floor(size(Az1,2)/2) floor(size(Az1,2)/2)+2];
		else
			ind_theta = [floor(size(Az1,2)/2) , floor(size(Az1,2)/2)+1];
		end
				
		Az = cat(3,Az1,-Az2);
		Az = Az(ind_rho,ind_theta,:);
		B_rho =-squeeze(diff(Az,1,2))/dtheta/mean(rhos(1,ind_rho));%[T]
		B_rho=squeeze(mean(B_rho  ,1));
		campo(:,I,rpm)= B_rho;
		
		tcost(:,rpm) = (0:2*length(tlist)-1)*first(diff(tlist))+tlist(1);
	end
	disp(['Corriente ' num2str(I) ' de ' num2str(length(corrientes))])
end

