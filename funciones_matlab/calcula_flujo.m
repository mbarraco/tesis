function flujo = calcula_flujo(rho,theta,A,vec,flag,xcm,ycm,lx,lz)
% flujo = calcula_flujo(A,vec,flag)
% Calcula el flujo de B a través de una espira cuadrada.
% A: datos, vec: ycm ó alpha, flag: 0 para ycm, 1 para alpha
% ->flujo(:,rpm)



%defino el movimiento vertical del centro de masa

if(flag==1)
	alpha=vec;
	for rpm=1:size(A,3)%velocidades
		for i=1:length(alpha)%angulos
			%posicion de los bordes de la espira
			r1= [( xcm -lx*cos(alpha(i))) (ycm-lx*sin(alpha(i)))];
			r2= [( xcm +lx*cos(alpha(i))) (ycm+lx*sin(alpha(i)))];
			[theta_1 rho_1] = cart2pol(r1(1), r1(2));
			[theta_2 rho_2] = cart2pol(r2(1), r2(2));
			%calculo el flujo
			aux1= interp2(rho,theta,A(:,:,rpm),rho_1,theta_1);
			aux2= interp2(rho,theta,A(:,:,rpm),rho_2,theta_2);
			
			flujo(i,rpm) = lz*(aux2 - aux1);
		end
	end
else
	ycmt = vec;
	for rpm=1:size(A,3)
		for i=1:length(ycmt)
			%posicion de los bordes de la espira
			r1= [(xcm-lx)  ycmt(i)];
			r2= [(xcm+lx)  ycmt(i)];
			[theta_1 rho_1] = cart2pol(r1(1), r1(2));
			[theta_2 rho_2] = cart2pol(r2(1), r2(2));
			%calculo el flujo
			aux1= interp2(rho,theta,A(:,:,rpm),rho_1,theta_1);
			aux2= interp2(rho,theta,A(:,:,rpm),rho_2,theta_2);
			
			flujo(i,rpm) = lz*(aux2 - aux1);
		end
	end
end

end