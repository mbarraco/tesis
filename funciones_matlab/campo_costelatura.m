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
			r= [0 , YCM(ycm)];
            [theta rho] = cart2pol(r(1), r(2));
			for t=1:length(tlist)
				% tenemos 2 calculos por la forma en la que vino la
				% simulacion
				campo_cost_1= interp2(THETA,RHO,Az1(:,:,t),theta,rho);
				campo_cost_2= interp2(THETA,RHO,Az2(:,:,t),theta,rho);
			end
		end
		campo_cost_2(:,:,I,rpm)=-campo_cost_2(:,:,I,rpm);
		%output1
		flujo_cost(:,:,I,rpm)=cat(1,flujo_cost_1(:,:,I,rpm),flujo_cost_2(:,:,I,rpm));
		%output3
		tcost(:,rpm) = (0:2*length(tlist)-1)*dt+tlist(1);
	end
	toc
	disp(['Corriente ' num2str(I) ' de ' num2str(length(corrientes))])
end



