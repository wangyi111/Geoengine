f1=[0.3,0.2,0.05];
f2=[-30,35,-20];

f1=dms2rad(f1);
f2=dms2rad(f2);

%C=zeros(3,3);
C1_1=DCM1(f1(1),f1(2),f1(3));
C2_1=DCM2(f1(1),f1(2),f1(3));

C1_2=DCM1(f2(1),f2(2),f2(3));
C2_2=DCM2(f2(1),f2(2),f2(3));

ESP1_1=ESP(C1_1);
ESP1_2=ESP(C1_2);
ESP2_1=ESP(C2_1);
ESP2_2=ESP(C2_2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms



function y=dms2rad(x)
y=x/180*pi;
end


function y=R1(x)
y=[1,0,0;0,cos(x),sin(x);0,-sin(x),cos(x)];
end
function y=R2(x)
y=[cos(x),0,-sin(x);0,1,0;sin(x),0,cos(x)];
end
function y=R3(x)
y=[cos(x),sin(x),0;-sin(x),cos(x),0;0,0,1];
end


function y=DCM1(x1,x2,x3)
% y(1,1)=cos(x3)*cos(x1)-cos(x2)*sin(x3)*sin(x1);
% y(1,2)=cos(x3)*sin(x1)+cos(x2)*sin(x3)*cos(x1);
% y(1,3)=sin(x2)*sin(x3);
% y(2,1)=-sin(x3)*cos(x1)-cos(x2)*cos(x3)*sin(x1);
% y(2,2)=-sin(x3)*sin(x1)+cos(x2)*cos(x3)*cos(x1);
% y(2,3)=sin(x2)*cos(x3);
% y(3,1)=sin(x2)*sin(x1);
% y(3,2)=-sin(x2)*cos(x1);
% y(3,3)=cos(x2);
y=R3(x3)*R1(x2)*R3(x1);
end

function y=DCM2(x1,x2,x3)
y=R1(x1)*R2(x2)*R3(x3);
end

function y=ESP(x)
y(1)=1/2*(x(1,1)+x(2,2)+x(3,3)+1)^0.5;
y(2)=(x(2,3)-x(3,2))/(4*y(1));
y(3)=(x(3,1)-x(1,3))/(4*y(1));
y(4)=(x(1,2)-x(2,1))/(4*y(1));
end

