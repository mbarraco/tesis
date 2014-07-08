function [flujo_cost, dphi_cost,  tcost] = flujo_costelatura(espira,corrientes,YCM,RPM,mallado,adress)
disp('|________________________________________________________________|')
disp('|_____________________   FLUJO_COSTELATURA  _____________________|')
disp('|________________________________________________________________|')

load([adress 'grilla_v4.mat'])

% 01 phi defecto externo/interno
for I=1:length(corrientes)
	tic
	for rpm=1:length(RPM)	
		filename = [ adress 'amalog2d_v4_3_OD_244mm_WT_14mm_gap_10mm_' num2str(RPM(rpm)) 'rpm_I_' num2str(corrientes(I)) 'mA.mat'];
		load(filename)
		[THETA RHO] = meshgrid(eval_angulos+(pi/2),radios);
		%coordenadas de los bordes de la espira
		for ycm=1:length(YCM)
			r1= [-espira.lx , YCM(ycm)];
			r2= [ espira.lx , YCM(ycm)];
			
            [theta_1 rho_1] = cart2pol(r1(1), r1(2));
			[theta_2 rho_2] = cart2pol(r2(1), r2(2));
			
			for t=1:length(tlist)
				% tenemos 2 calculos por la forma en la que vino la
				% simulacion
				aux1= interp2(THETA,RHO,Az1(:,:,t),theta_1,rho_1);
				aux2= interp2(THETA,RHO,Az1(:,:,t),theta_2,rho_2);
				
				aux3= interp2(THETA,RHO,Az2(:,:,t),theta_1,rho_1);
				aux4= interp2(THETA,RHO,Az2(:,:,t),theta_2,rho_2);
				
				flujo_cost_1(t,ycm,I,rpm)   = espira.lz*(aux2 - aux1);%  [] = T.m^2
				flujo_cost_2(t,ycm,I,rpm) = espira.lz*(aux4 - aux3);
			end
		end
		flujo_cost_2(:,:,I,rpm)=-flujo_cost_2(:,:,I,rpm);
		%output1
		flujo_cost(:,:,I,rpm)=cat(1,flujo_cost_1(:,:,I,rpm),flujo_cost_2(:,:,I,rpm));

		dt=tlist(2)-tlist(1);
		%output2
		dphi_cost = diff(flujo_cost,1,1)/dt;% [] = T.m^2/s
		
		%output3
		tcost(:,rpm) = (0:2*length(tlist)-1)*dt+tlist(1);
	end
	toc
	disp(['Corriente ' num2str(I) ' de ' num2str(length(corrientes))])
end



