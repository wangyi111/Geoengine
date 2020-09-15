function[V]=V_sphere(X,Y,R,Xm,Ym,p)
n=size(X);
m=size(Y);
V=zeros(m(1,2),n(1,2));
G = 6.672*10^(-20);
for i=1:n(1,2)
    for j=1:m(1,2)
        r = sqrt((X(i)-Xm)^2+(Y(j)-Ym)^2);
    if r >= R
        v=4*pi*G*p*(R^3)/(3*r);
    elseif r < R
        v=2*pi*G*p*(R^2-r^2/3);
    end
    V(j,i)=v;
    end
end
