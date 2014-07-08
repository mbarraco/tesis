function  Y = mibandpass(data,a,b,Fs)
%Y = mibandpass(data,a,b,Fs)
	Y=NaN(size(data));
	a = tan(pi*a/Fs); % fs = sampling frequency
	b = tan(pi*b/Fs);
	aux2=(1+a)*(1+b);
	c0 = -b/aux2;
	c1 = 0;
	c2 = b/aux2;
	d1 = ((1+a)*(1-b)+(1-a)*(1+b))/aux2;
	d2 = -((1-a)*(1-b))/aux2;

	num= [c0 c1 c2];
	den = [-1 -d1 -d2];
	for i=1:size(data,2)
	    aux = data(:,i);
	    aux = filter(num,den,aux);
	    Y(:,i) = aux;
	end
end

