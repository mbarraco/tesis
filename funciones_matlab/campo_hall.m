function [Bradial, Btangencial ,B_vertical , B_angular] = campo_hall(filename_1,espira,RPM)
%B(theta/rho,rpm,I)
disp('|___________________   Campo Hall ___________________|')



alpha = espira.amp_alpha*(linspace(-1,1,3)); % angulos tilt
ycm = espira.amp_ycm*(linspace(-1,1,3)) + espira.ycm; % angulos tilt

%% angular
load(filename_1)
% A=A(range_theta,:,:,:);
A = permute(A,[4 1 2 3]);
A = interp1(rpm_lista,A(),RPM);
A = permute(A,[2 3 4 1]);

radios = rho(1,:) + tubo_OD/2;
a=find(espira.ycm>radios);
a=a(end);
b=find(espira.ycm<radios);
b=b(1);
range_rho = [a b]; % sensor en espira.ycm
range_theta = [floor(size(A,1)/2) , floor(size(A,1)/2)+1]; %sensor en theta=0
A=A(range_theta,range_rho,:,:);

dtheta = theta(2,1)-theta(1,1);
drho = rho(1,2)-rho(1,1);

%movimiento angular
B_theta = -squeeze(diff(A,1,2))./drho;%[T]
B_rho   =  squeeze(diff(A,1,1))./dtheta./mean(rho(1,range_rho)); %[T]

B_theta =squeeze(mean(B_theta,1));%interpolamos
B_rho   =squeeze(mean(B_rho  ,1));

for i=1:length(alpha)
	B_angular(i,:,:) = B_theta .* sin(alpha(i)) + B_rho.*cos(alpha(i));%campo efectivo
end

%% vertical
load(filename_1)

radios = rho(1,:) + tubo_OD/2;
range_theta = [floor(size(A,1)/2) , floor(size(A,1)/2)+1]; %sensor en theta=0
dtheta = theta(2,1)-theta(1,1);

%------------------------------------------------- Guardo A para devolverlo
A=A(range_theta,:,:,:);
A_nodefect = permute(A,[4 1 2 3]);
A_nodefect = interp1(rpm_lista,A_nodefect(),RPM);
A_nodefect = permute(A_nodefect,[2 3 4 1]);

Bradial = squeeze(-diff(A,1,1));%[T.m]
Btangencial = squeeze(mean(diff(A,1,2),1));%[T.m]
for I=1:3
    for rpm=1:5
        Bradial(:,I,rpm) = Bradial(:,I,rpm)./radios';%[T]
    end
end
%--------------------------------------------------------------------------


B_rho = squeeze(diff(A,1,1))./dtheta; %[T.m]
[velocidades R] = meshgrid(rpm_lista,radios);% grilla interpolacion

for I=1:size(B_rho,2)
    B_vertical(:,I,:) = interp2(velocidades,R,squeeze(B_rho(:,I,:)),RPM,ycm');
end		
%Divido por r para "que me den las unidades"
for I=1:3
    for rpm=1:length(RPM)
        B_vertical(:,I,rpm)= B_vertical(:,I,rpm)./ycm';%[T]
    end
end

