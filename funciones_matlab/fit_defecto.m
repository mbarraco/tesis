function [ajuste, tajuste] = fit_defecto(data,time,malla,RPM)

tvuelta = 60./[50 100 150 200 250]; %tiempo de 1 vuelta
Fs= (malla-1)./tvuelta;

ind=1;
for rpm=1:length(RPM)
	for I=1:3
		t1=time(1,I,RPM(rpm));
		t2=time(end,I,RPM(rpm));	
		tspan= .6*(t2-t1);% fraccion de duracion de datos simulados
		t1=time(1,I,RPM(rpm))-tspan;
		t2=time(end,I,RPM(rpm))+tspan; %tiempo de ajuste a valor medio	
		t_sim(:,rpm) = [0 t1 time(:,I,RPM(rpm))' t2 tvuelta(RPM(rpm))]; %padding para el defecto
		tajuste(:,rpm)=linspace(0,tvuelta(RPM(rpm)),malla);%tiempo del ajuste
		
		signal= data(:,I,RPM(rpm))-mean(data(:,I,RPM(rpm))); %saco DC
		data_sim(:,I,rpm)  = [0 0 signal' 0 0 ]'; % senhal con relleno
		ajuste(:,I,rpm)=interp1(t_sim(:,rpm),data_sim(:,I,rpm),tajuste(:,rpm),'cubic');
	end
	dt(rpm)=tajuste(2,rpm)-tajuste(1,rpm);
end
for rpm=1:length(RPM)
	tajuste(:,rpm) = tajuste(:,rpm) - tajuste(end/2,rpm);
end