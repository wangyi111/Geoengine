function[V]=V_shell(Ri,Ro,pc,pm,r)
n=size(r);
G = 6.672*10^(-11);
V=zeros(1,n);
for i=1:n(1,2)
    if r(i) > Ro
        v=4*pi*G*((pc-pm)*Ri^3+pm*Ro^3)/(3*r(i));
    elseif r(i) <= Ro && r(i)>Ri
        v=4*pi*G*pc*Ri^3/(3*r(i))+2*pi*G*pm*(Ro^2-1/3*r(i)^2-2/3*Ri^3/r(i));
    else r(i)<= Ri
        v=2*pi*G*(pc*(Ri^2-1/3*r(i)^2)+pm*(Ro^2-Ri^2));
    end
    V(i)=v;
    end
end
