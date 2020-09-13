
%% advanced mathematics lab1 main function
% author: Yi Wang
% last change: 09/12/2018

% input an and x0
disp('Please input n,an and x0:')
n=input("the order of the ODE: n=");
an=zeros(1,n+1);
an=input("the coefficient vector of the ODE: an=");
% check dimension
if length(an)!=n+1
  error('dimension incorrect!');
end
x0=input("guess one root: x0=");
disp('*****************************');
xx=zeros(1,n);
bb=zeros(n,n+1);
[bb,xx]=horner(an,x0);

disp(['the roots are:',num2str(xx)]);
disp('the horner scheme parameters ai,bi(bi=ai+b(i+1)*x0) are:');
for i=1:n
  disp(['x0=',num2str(xx(i))]);  
  disp(['ai:',num2str(an)]);
  disp(['bi:',num2str(bb(i,:))]);
%  disp(newline);
end
disp(['the general solution is:','y=C1*e^',num2str(xx(1)),'+C2*e^',num2str(xx(2)),'+C3*e^',num2str(xx(3)),'+C4*e^',num2str(xx(4))])
