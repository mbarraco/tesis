function [flujo_ycm, dphi_ycm] = flujo_centro_de_masa(filename_1, filename_2,espira,YCM,RPM,mallado)


disp('|___________________   Campo en el centro de masa  ___________________|')


load(filename_1)
load(filename_2)

for I=1:size(A,3)
	tic
	for ycm=1:length(YCM)
		for rpm = 1:size(A,4)
			r= [-espira.lx ,  YCM(ycm)];
	       	[theta rho] = cart2pol(r1(1), r1(2));
			

			potencial_1(rpm)= interp2(rho,theta,A(:,:,I,rpm),rho_1,theta_1);
		end
		potencial_1 = interp1(rpm_lista,potencial_1,RPM);
		potencial_2 = interp1(rpm_lista,potencial_2,RPM);
		flujo_ycm(ycm,I,:) = espira.lz*(potencial_2 - potencial_1);% [] = T.m^2
	end
	toc
	disp(['Corriente ' num2str(I) ' de ' num2str(size(A,3))])
end

dycm= YCM(2)-YCM(1);
dphi_ycm=diff(flujo_ycm,1,1)/dycm;% [] = T.m

end