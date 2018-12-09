

% advanced mathematics lab1
% author: Yi Wang
% last change: 09/12/2018

% function [bb,xx]=horner(an,x0)
% bb is the horner parameter matrix according to each root 
% xx is the roots
% an is the coefficient vector [an,a(n-1),...,a1,a0]
% x0 is the guess of the characteristic equation

% this function considers the solution of homogeneous higher order differential equations with constant coefficients 
% Necessarty condition: all roots of the characteristic equation are real and different from each other.
% we use Horner scheme to calculate the polynomials

function [bb,xx]=horner(an,x0)

c=1;d=1e-10;
b=0;x1=x0;
n=length(an)-1;
% calculate initial b and y
for i=1:n+1
    b=b*x0+an(i);
end
y=b;
y1=y;t=0;s=0;anss=0;xx=zeros(1,n);
bb=zeros(n,n+1);
% judge if all the roots are figured out
while abs(y)>d || anss<n
    % gradually change x0 and look for the root
    x0=x0+c;b=0;bbb=zeros(1,n+1);
    % calculate each b and y according to each x0
    for i=1:n+1
        b=b*x0+an(i);
        bbb(i)=b;
    end
    y=b;
    % luckily we find one root
    if y==0
        anss=anss+1;
        xx(anss)=x0;
        bb(anss,:)=bbb;
    end
    % the root is between x0 and x0+c, so we reduce the interval
    if y*y1<0
        x0=x0-c;c=0.1*c;
    end
    t=t+1;s=s+1;
    % no more positive roots
    if t>100
        t=-1;x0=x1;c=-1;
    end
    % no more negative roots
    if s>200
        disp("not applicable in this question");
        break;
    end
end

end
