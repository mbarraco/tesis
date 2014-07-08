function phi = miphi(xcm,ycm,alpha,A,rho,theta,rpm,lx,lz)
%phi = miphi(xcm,ycm,alpha,A,rho,theta)
%xmc: x centro de espira
%ycm: vector con altura del centro de la espira
%alpha: vector de angulo de orientacion de la espira
%A: matriz de datos
% rho y theta: grilla. lx : longitud de la espira

for i=1:length(alpha)
	for j=1:length(ycm)
		%posicion de los bordes de la espira
		r1= [(xcm-lx*cos(alpha(i))) (ycm(j)-lx*sin(alpha(i)))];
		r2= [(xcm+lx*cos(alpha(i))) (ycm(j)+lx*sin(alpha(i)))];
		[theta_1 rho_1] = cart2pol(r1(1), r1(2));
		[theta_2 rho_2] = cart2pol(r2(1), r2(2));
		
		%calculo el flujo
		aux1= interp2(rho,theta,A(:,:,rpm),rho_1,theta_1);
		aux2= interp2(rho,theta,A(:,:,rpm),rho_2,theta_2);
		phi(i,j) = lz*(aux2 - aux1);
	end
	
	disp([num2str(floor(i/length(alpha)*100))  '% completado'])
end
end