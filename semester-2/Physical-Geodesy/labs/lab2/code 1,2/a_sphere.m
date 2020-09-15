function[ax ay]=a_sphere(X,Y,R,Xm,Ym,p)
n=size(X);
m=size(Y);
ax=zeros(m(1,2),n(1,2));
ay=zeros(m(1,2),n(1,2));
G = 6.672*10^(-20);
for i=1:n(1,2)
    for j=1:m(1,2)
        r = sqrt((X(i)-Xm)^2+(Y(j)-Ym)^2);
    if r>= R
        a=-4/3*pi*G*p*R^3/(r^2);
    elseif r < R
        a=-4/3*pi*G*p*r;
    end
    ax(j,i)=a*(X(i)-Xm)/r;
    ay(j,i)=a*(Y(j)-Ym)/r;
    end
    
end

 
