%% Lagrange interpolating polynomial
% author: Yi Wang
% last update: 08/01/2019
x=[-4,-3,-2,1,2,4]';
y=[-26,-775,-1104,-1011,-980,702]';

a=polyLagrange(x,y);
a=fliplr(a) %[a0,a1,a2,a3,a4,a5] wrt. [1,x,x^2,x^3,x^4,x^5]


%% function polyLagrange
% import the set of points
% return the coefficients of the interpolating polynomial
function a=polyLagrange(x,y)
                   
if(length(x)==length(y))    
    n=length(x);            
else 
    disp('dimension error.')   
    return;   
end
for i=1:n
    p{i}=[1,-x(i)];  %the coefficients of basic vector
end
%%%% or simply: poly(x)
a=zeros(1,n);
L{n}=NaN;
for i = 1:n
    LL=1;
    num=1;
    for j=1:i-1
        pp{i}{num}=p{j};
        LL=LL*(x(i)-x(j));
        num=num+1;
    end
    for j=i+1:n
        pp{i}{num}=p{j};
        LL=LL*(x(i)-x(j));
        num=num+1;
    end
    
    L{i}=pp{i}{1};
    for k=2:n-1
        L{i}=conv(L{i},pp{i}{k});
    end
    
    L{i}=L{i}/LL*y(i);
    a=a+L{i};    
end
          
end    
