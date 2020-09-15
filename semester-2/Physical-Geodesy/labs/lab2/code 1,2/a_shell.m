function[a]=a_shell(Ri,Ro,pc,pm,r)
n=size(r);
G = 6.672*10^(-11);
a = zeros(1,n);
for i=1:n(1,2)
    if r(i) > Ro
        A=-4/3*pi*G*((pc-pm)*Ri^3+pm*Ro^3)/r(i)^2;
    elseif r(i) <= Ro && r(i) > Ri
        A=-4/3*pi*G*(pm*(r(i)-Ri^3/r(i)^2)+pc*Ri^3/r(i)^2);
    else r(i)<= Ri
        A=-4/3*pi*G*pc*r(i);
    end
    a(i)=A;
    end
end
