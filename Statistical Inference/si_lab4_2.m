x=[-4,-3,-2,1,2,4]';
y=[-26,-775,-1104,-1011,-980,702]';

%% Question a
A3=[ones(6,1),x,x.^2,x.^3];
Y=y;
N=A3'*A3;
X_hat_3=N^(-1)*A3'*Y;
Y_hat_3=A3*X_hat_3;
x_p=linspace(-5,5);
y_p_3=P(X_hat_3,x_p,3);

A4=[ones(6,1),x,x.^2,x.^3,x.^4];
Y=y;
N=A4'*A4;
X_hat_4=N^(-1)*A4'*Y;
Y_hat_4=A4*X_hat_4;
y_p_4=P(X_hat_4,x_p,4);

plot(x_p,y_p_3);
hold on;
plot(x_p,y_p_4);
hold on;
plot(x,y,'ro');
legend('d=3','d=4');

%% Question b
A5=[ones(6,1),x,x.^2,x.^3,x.^4,x.^5];
Y=y;
N=A5'*A5;
X_hat_5=N^(-1)*A5'*Y;






function y=P(a,x,n)

if n==3
    y=a(1)+a(2)*x+a(3)*x.^2+a(4)*x.^3;
else
    if n==4
        y=a(1)+a(2)*x+a(3)*x.^2+a(4)*x.^3+a(5)*x.^4;
    else
        if n==5
           y=a(1)+a(2)*x+a(3)*x.^2+a(4)*x.^3+a(5)*x.^4+a(6)*x.^5; 
        end
    end
end

end
        