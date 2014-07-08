% load ('/home/m/Dropbox/Exactas/2011_02_Tesis/compartido-mariano/02_Flujo_magnetico/datos/datos_simulacion_sin_defecto.mat')
% load('/home/m/Dropbox/Exactas/2011_02_Tesis/compartido-mariano/02_Flujo_magnetico/datos/grilla.mat')   

load('D:\Compartido\mariano\02_Flujo_magnetico\datos\datos_simulacion_sin_defecto.mat')
load('D:\Compartido\mariano\02_Flujo_magnetico\datos\grilla.mat')   



%% 00 Parametros de la espira

espira.lx=.001; %semi-longitud espira
espira.lz=1;
espira.xcm = 0;
espira.liftoff=0.002;
% espira.ycm = tubo_OD/2 + tubo_WT + espira.liftoff;
espira.ycm = tubo_OD/2 + espira.liftoff;
espira.amp_ycm=.001;
espira.amp_alpha=0.001;
mallado=100;
% parametros del movimiento
espira.f_alpha=100;
espira.f_ycm=100;


YCM   = espira.amp_ycm*(linspace(-1,1,espira.mallado)) + espira.ycm ;

alpha = espira.amp_alpha*(linspace(-1,1,espira.mallado));



%% 01 phi defecto externo/interno

defect_type= 'externo';
adress = 'datos\amalog2d_v3_externo_OD_244mm_WT_14mm_gap_10mm\'

RPM = [ 50 100 150 200 250];
corrientes = 1000*[5 6 7];
for i=1:length(corrientes)
    for j=1:length(RPM)
        tic	
        filename = [ adress 'amalog2d_v3_' defect_type '_OD_244mm_WT_14mm_gap_10mm_' num2str(RPM(j)) 'rpm_I_' num2str(corrientes(i)) 'mA.mat'];
        load(filename)
        [THETA RHO] = meshgrid(angulos+(pi/2),radios);
        
		%coordenadas de los bordes de la espira
        r1= [( espira.xcm -espira.lx) (YCM-espira.lx)];
        r2= [( espira.xcm +espira.lx) (YCM+espira.lx)];
        [theta_1 rho_1] = cart2pol(r1(1), r1(2));
        [theta_2 rho_2] = cart2pol(r2(1), r2(2));
		
        for t=1:length(tlist)
            aux1= interp2(THETA,RHO,Az(:,:,t),theta_1,rho_1);
            aux2= interp2(THETA,RHO,Az(:,:,t),theta_2,rho_2);
            flujo_defect(t,i,j) = espira.lz*(aux2 - aux1);% phi = lz(A_z(xy_2)-A_z(xy_1))
        end
        toc
       
    end
end

%% 02 phi alpha
clearfor I=1:size(A,3)
	disp(['I = ' num2str(I) ])
	tic
	for i=1:length(alpha)
		for rpm = 1:size(A,4)
			%--------posicion de los bordes de la espira
			r1= [( espira.xcm -espira.lx*cos(alpha(i))) (YCM-espira.lx*sin(alpha(i)))];
			r2= [( espira.xcm +espira.lx*cos(alpha(i))) (YCM+espira.lx*sin(alpha(i)))];
			[theta_1 rho_1] = cart2pol(r1(1), r1(2));
			[theta_2 rho_2] = cart2pol(r2(1), r2(2));
			%calculo el flujo
			potencial_1(rpm)= interp2(rho,theta,A(:,:,I,rpm),rho_1,theta_1);
			potencial_2(rpm)= interp2(rho,theta,A(:,:,I,rpm),rho_2,theta_2);
		end	
		potencial_1 = interp1(rpm_lista,potencial_1,RPM);
		potencial_2 = interp1(rpm_lista,potencial_2,RPM);
		flujo_alpha(i,I,:) = espira.lz*(potencial_2 - potencial_1);
	end
	toc
end

%% 03 phi ycm
for I=1:size(A,3)
	disp(['I =' num2str(I)])
	tic
	for i=1:length(YCM)
		for rpm = 1:size(A,4)
			%--------posicion de los bordes de la espira
			r1= [(espira.xcm-espira.lx)  YCM(i)];
			r2= [(espira.xcm+espira.lx)  YCM(i)];
			[theta_1 rho_1] = cart2pol(r1(1), r1(2));
			[theta_2 rho_2] = cart2pol(r2(1), r2(2));
			%calculo el flujo
			potencial_1(rpm)= interp2(rho,theta,A(:,:,I,rpm),rho_1,theta_1);
			potencial_2(rpm)= interp2(rho,theta,A(:,:,I,rpm),rho_2,theta_2);
			% 			flujo_ycm(i,I,rpm) = espira.lz*(aux2 - aux1);
		end
		potencial_1 = interp1(rpm_lista,potencial_1,RPM);
		potencial_2 = interp1(rpm_lista,potencial_2,RPM);
		flujo_ycm(i,I,:) = espira.lz*(potencial_2 - potencial_1);
	end
	toc
end


%% 04 dphi

dt=tlist(2)-tlist(1);
time=tlist+dt/2;
dphi_alpha=diff(flujo_alpha,1,1)/dt;
dphi_ycm=diff(flujo_ycm,1,1)/dt;
dphi_defect = diff(flujo_defect,1,1)/dt;

%% 05 Amplitud de la senal de ruido



noise_alpha=espira.f_alpha*max(dphi_alpha,[],1)-min(dphi_alpha,[],1);
noise_ycm=espira.f_ycm*max(dphi_ycm,[],1)-min(dphi_ycm,[],1);
noise_defect=max(dphi_defect,[],1)-min(dphi_defect,[],1);


% %% 06 graficos
% %dphi defecto
% figure(600)
% 
% subplot(3,1,1)
% pcolor(squeeze(noise_defect))
% colorbar
% shading interp
% title('Amplitud de ruido por defecto')
% 
% subplot(3,1,2)
% pcolor(squeeze(noise_alpha))
% colorbar
% shading interp
% title('Amplitud de ruido por movimiento angular')
% 
% subplot(3,1,3)
% pcolor(squeeze(noise_ycm))
% colorbar
% shading interp
% title('Amplitud de ruido por movimiento vertical')
% 
% xlabel('RPM')
% ylabel('Corriente [A]')
% 
% 
% for i=1:size(dphi_defect,3)
% 	figure(650 + i)
% 	hold all
% 	for j=1:size(dphi_defect,2)
% 		plot(time(1:end-1),dphi_defect(:,j,i))
% 		ylabel('dphi_defect')
% 		xlabel('tiempo')
% 	end
% end
% 
% 
% % dphi alpha
% 
% 
% for i=1:size(dphi_defect,3)
% 	figure(660+i)
% 	plot(dphi_alpha(:,:,i))
% 	title(['RPM=' num2str(RPM(i))])	
% 	ylabel('dphi_alpha')
% 	xlabel('alpha')
% end
% 
% % dphi ycm
% for i=1:size(dphi_defect,3)
% 	figure(670+i)
% 	title(['RPM=' num2str(RPM(i))])
% 	plot(dphi_ycm(:,:,i))
% 	ylabel('dphi_ycm')
% 	xlabel('ycm')
% 	
% end
%%
clearvars -except dphi_* noise_* espira
filename = ['D:\Compartido\mariano\02_Flujo_magnetico\' 'Ruido_' num2str(espira.amp_alpha) '_' num2str(espira.amp_ycm) '.mat'];
save(filename)

