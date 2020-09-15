function y=RF_P(l,m,t)
% theta=0:1:180;
% t=cos(theta/180*pi);
n=length(t);

syms f1(x)
f1(x)=1/(2^l*factorial(l))*diff((x^2-1)^l,l);

syms f2(x)
f2(x)=(1-x^2)^(m/2)*diff(f1(x),m);

if m==0
    y=double(sqrt(2*l+1)*f2(t));
else
    y=double(sqrt(2*(2*l+1)*(factorial(l-m)/factorial(l+m)))*f2(t));
end

end