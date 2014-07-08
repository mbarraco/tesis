function [dphi_defect, dphi_alphat, dphi_ycmt] = calcula_dphi(corriente,liftoff,amp_alpha,amp_ycm,mallado) 
% [dphi_defect, dphi_alphat, dphi_ycmt] = calcula_dphi(corriente,liftoff,amp_alpha,amp_ycm) 
% Calcula las derivadas del flujo magnetico debido
% al desplazamiento vertical, angular y por un defecto simulado
% corriente es el numero que identifica al archivo
% ej. corriente = 10 => Az_10

filename= ['D:\Compartido\mariano\02_Flujo_magnetico\datos_Az\Az_' num2str(corriente)];
load (filename)
load ('D:\Compartido\mariano\02_Flujo_magnetico\datos_Az\Az_data')
aux= ceil(size(theta,1)/3);
theta_range=(aux:aux*2);
theta=theta(theta_range,:);
rho=rho(theta_range,:);

ind= num2str(corriente);
eval(['A=Az_' ind '(theta_range,:,:,:);'])
A=squeeze(A);

filename_defecto = ['D:\Compartido\mariano\02_Flujo_magnetico\datos_simulacion_ruido\amalog2d_v3_externo_OD_244mm_WT_14mm_gap_10mm\amalog2d_v3_externo_OD_244mm_WT_14mm_gap_10mm_100rpm_I_' num2str(I_lista(corriente)*1000) 'mA.mat'];
load(filename_defecto)
load ('D:\Compartido\mariano\02_Flujo_magnetico\datos_simulacion_ruido\grilla.mat')


% [THETA RHO] = meshgrid(angulos+(pi/2),radios);

%---------------------------------------------------parametros del problema
dt=tlist(2)-tlist(1);
% time=tlist+dt/2;


lx=.001; %semi-longitud espira
lz=2;
xcm = 0;
ycm = tubo_OD/2 + liftoff ;


%-------------------------------Phi(t)---------------------Fuentes de ruido

ycmt   = amp_ycm*(linspace(-1,1,mallado)) + ycm ;
alphat = amp_alpha*(linspace(-1,1,mallado))+ pi/2 ;
flujo_alphat = calcula_flujo(rho,theta,A,alphat,1,xcm,ycm,lx,lz)';
flujo_ycmt   = calcula_flujo(rho,theta,A,ycmt,0,xcm,ycm,lx,lz)';


%------------------------------------------------------------------ Defecto
tic
[theta rho] = meshgrid(angulos+(pi/2),radios);

r1= [( xcm -lx) (ycm-lx)];
r2= [( xcm +lx) (ycm+lx)];
[theta_1 rho_1] = cart2pol(r1(1), r1(2));
[theta_2 rho_2] = cart2pol(r2(1), r2(2));
for t=1:length(tlist)
	aux1= interp2(theta,rho,Az(:,:,t),theta_1,rho_1);
	aux2= interp2(theta,rho,Az(:,:,t),theta_2,rho_2);
	flujo_defect(t) = lz*(aux2 - aux1);
end
toc
%-----------------------------------------------------------------d(Phi)/dt
time=tlist+dt/2;

%Fuentes de ruido

dphi_alphat=diff(flujo_alphat,1,2)/dt;
dphi_ycmt=diff(flujo_ycmt,1,2)/dt;

%defecto
dphi_defect = diff(flujo_defect)/dt;

end


