function [A]=jacobipq(A,iterMax,tol)
% author: Yi Wang
% last change: 26/11/2018
if A'~=A
    error('A is not symmetric!');
end

temp=1;
n=size(A);
U=zeros(n);
iter=0;
p=1;
q=2;

while temp>tol && iter<iterMax 
    iter=iter+1;
    max=abs(A(p,q));
    U=zeros(n);
    for i=1:n
        for j=1:n
            if i~=j && max<abs(A(i,j))
                max=abs(A(i,j));
                p=i;
                q=j;
            end
        end
    end
    temp=max;
    for i=1:n
        U(i,i)=1;
    end
    Phi=1/2*acot((A(q,q)-A(p,p))/(2*A(p,q)));
    U(p,p)=cos(Phi);
    U(q,q)=cos(Phi);
    U(p,q)=sin(Phi);
    U(q,p)=-sin(Phi);
    A=U'*A*U;
    if iter==1
        A
    end
end

   

            
        