function [flujo_alpha, dphi_alpha, alpha] = flujo_angular(filename_1, filename_2,espira,RPM,mallado)
disp('|______________________________________________________________|')
disp('|______________________   FLUJO_ANGULAR  ______________________|')
disp('|______________________________________________________________|')


load(filename_1)
load(filename_2)
alpha = espira.amp_alpha*(linspace(-1,1,mallado));
% Angular
for I=1:size(A,3)
	tic
	for k=1:length(alpha)
		for rpm = 1:size(A,4)
			r1= [ -espira.lx*cos(alpha(k)) (espira.ycm - espira.lx*sin(alpha(k)))];
			r2= [  espira.lx*cos(alpha(k)) (espira.ycm + espira.lx*sin(alpha(k)))];
			[theta_1 rho_1] = cart2pol(r1(1), r1(2));
			[theta_2 rho_2] = cart2pol(r2(1), r2(2));

			potencial_1(rpm)= interp2(rho,theta,A(:,:,I,rpm),rho_1,theta_1);
			potencial_2(rpm)= interp2(rho,theta,A(:,:,I,rpm),rho_2,theta_2);
		end	
		potencial_1 = interp1(rpm_lista,potencial_1,RPM);
		potencial_2 = interp1(rpm_lista,potencial_2,RPM);
		flujo_alpha(k,I,:) = espira.lz*(potencial_2 - potencial_1);% [] = T.m^2
	end
	toc
	disp(['Corriente ' num2str(I) ' de ' num2str(size(A,3))])
end

dalpha= alpha(2)-alpha(1);
dphi_alpha=diff(flujo_alpha,1,1)/dalpha;% [] = T.m^2
