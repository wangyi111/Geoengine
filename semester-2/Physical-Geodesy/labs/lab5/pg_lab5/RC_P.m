function y=RC_P(l,m,t)
% theta=0:1:180;
% t=cos(theta/180*pi);
n=length(t);

if l<m
    y=0;
elseif l==0&&m==0
    y=ones(1,n);

elseif l==1&&m==1
    y=sqrt(3*(1-t.^2));

elseif l==m
    y=sqrt((2*l+1)/(2*l))*sqrt(1-t.^2).*RC_P(l-1,l-1,t);
elseif l~=m
    y=sqrt((2*l+1)/((l+m)*(l-m)))*(sqrt((2*l-1))*t.*RC_P(l-1,m,t)-sqrt((l-1+m)*(l-1-m)/(2*l-3)).*RC_P(l-2,m,t));
end
end