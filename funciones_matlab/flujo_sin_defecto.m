function [flujo_alpha, flujo_ycm, dphi_alpha, dphi_ycm, alpha] = flujo_sin_defecto(filename_1, filename_2,espira,YCM,RPM,mallado)

disp('|____________________________________________________________|')
disp('|__________________   FLUJO_SIN_DEFECTO  ____________________|')
disp('|____________________________________________________________|')

load(filename_1)
load(filename_2)
alpha = espira.amp_alpha*(linspace(-1,1,mallado));
% Angular
for I=1:size(A,3)
	disp(['Corriente ' num2str(I) ' de ' num2str(size(A,3))])
	tic
	for k=1:length(alpha)
		for rpm = 1:size(A,4)
			r1= [( espira.xcm - espira.lx*cos(alpha(k))) (YCM - espira.lx*sin(alpha(k)))];
			r2= [( espira.xcm + espira.lx*cos(alpha(k))) (YCM + espira.lx*sin(alpha(k)))];
			[theta_1 rho_1] = cart2pol(r1(1), r1(2));
			[theta_2 rho_2] = cart2pol(r2(1), r2(2));

			potencial_1(rpm)= interp2(rho,theta,A(:,:,I,rpm),rho_1,theta_1);
			potencial_2(rpm)= interp2(rho,theta,A(:,:,I,rpm),rho_2,theta_2);
		end	
		potencial_1 = interp1(rpm_lista,potencial_1,RPM);
		potencial_2 = interp1(rpm_lista,potencial_2,RPM);
		flujo_alpha(k,I,:) = espira.lz*(potencial_2 - potencial_1);
	end
	toc
end


% Centro de masa
for I=1:size(A,3)
	disp(['Corriente ' num2str(I) ' de ' num2str(size(A,3))])
	tic
	for k=1:length(YCM)
		for rpm = 1:size(A,4)
			%--------posicion de los bordes de la espira
			r1= [(espira.xcm-espira.lx)  YCM(k)];
			r2= [(espira.xcm+espira.lx)  YCM(k)];
			[theta_1 rho_1] = cart2pol(r1(1), r1(2));
			[theta_2 rho_2] = cart2pol(r2(1), r2(2));
			%calculo el flujo
			potencial_1(rpm)= interp2(rho,theta,A(:,:,I,rpm),rho_1,theta_1);
			potencial_2(rpm)= interp2(rho,theta,A(:,:,I,rpm),rho_2,theta_2);
			% 			flujo_ycm(i,I,rpm) = espira.lz*(aux2 - aux1);
		end
		potencial_1 = interp1(rpm_lista,potencial_1,RPM);
		potencial_2 = interp1(rpm_lista,potencial_2,RPM);
		flujo_ycm(k,I,:) = espira.lz*(potencial_2 - potencial_1);
	end
	toc
end


dalpha= alpha(2)-alpha(1);
dycm= YCM(2)-YCM(1);
dphi_alpha=diff(flujo_alpha,1,1)/dalpha;
dphi_ycm=diff(flujo_ycm,1,1)/dycm;

end