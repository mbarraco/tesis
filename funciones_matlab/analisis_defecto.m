
function [defect_struct] = analisis_defecto(data,time,RPM,malla)
%function [defect_struct] = analisis_defecto(data,time,RPM,malla)

%% -------------------------------AJUSTE-----------------------

tvuelta = 60./RPM; %tiempo de 1 vuelta
Fs= (malla-1)./tvuelta; 

for rpm=1:size(data,4)
	for I=1:size(data,3)
		t1=time(1,I,rpm);
		t2=time(end,I,rpm);
		
		tspan= .6*(t2-t1);% fraccion de duracion de datos simulados
		t1=time(1,I,rpm)-tspan;
		t2=time(end,I,rpm)+tspan; %tiempo de ajuste a valor medio
		
		t_sim(:,rpm) = [0 t1 time(:,I,rpm)' t2 tvuelta(rpm)]; %padding para el defecto
		tajuste(:,rpm)=linspace(0,tvuelta(rpm),malla);%tiempo del ajuste
	
		for ycm=1:size(data,2)
			signal= data(:,ycm,I,rpm)-mean(data(:,ycm,I,rpm)); %saco DC
			data_sim(:,ycm,I,rpm)  = [0 0 signal' 0 0 ]'; % senhal con relleno
			AJUSTE(:,ycm,I,rpm)=interp1(t_sim(:,rpm),data_sim(:,ycm,I,rpm),tajuste(:,rpm),'cubic');
		end
	end
	dt(rpm)=tajuste(2,rpm)-tajuste(1,rpm);
	DAJUSTE(:,:,:,rpm) = diff(AJUSTE(:,:,:,rpm),1)/dt(rpm);	% Derivada temporal del ajuste
end

%-------------------------------ESPECTRO-----------------------
for ycm=1:size(data,2)
	for I=1:size(data,3)
		for rpm=1:size(data,4)
			[aux , f_ajuste(:,rpm)]  = mifft(AJUSTE(:,ycm,I,rpm),Fs(rpm));
			[aux2 ,f_dajuste(:,rpm)] = mifft(DAJUSTE(:,ycm,I,rpm),Fs(rpm));
			AJUSTE_fft(:,ycm,I,rpm)  = aux;
			DAJUSTE_fft(:,ycm,I,rpm) = aux2;
		end
	end
end

defect_struct.data_sim = data_sim;
defect_struct.t_sim = t_sim;
defect_struct.ajuste_senal = AJUSTE;
defect_struct.ajuste_derivada = DAJUSTE;
defect_struct.tajuste = tajuste;
defect_struct.ajuste_senal_fft= AJUSTE_fft;
defect_struct.f_ajuste =f_ajuste;
defect_struct.ajuste_derivada_fft= DAJUSTE_fft;
defect_struct.f_dajuste =f_dajuste;
defect_struct.dt = dt;

end