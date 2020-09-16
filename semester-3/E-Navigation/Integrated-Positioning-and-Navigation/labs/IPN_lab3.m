
%% Task 2
a1_p = -0.5;
a2_p = 0.6;
g = 9.8;
omega_ip1 = 4.6035e-5;
omega_ip2 = -8.1172e-6;
yaw = atan(-omega_ip2/omega_ip1);
pitch = asin(-a1_p/g);
roll = asin(a2_p/g/cos(pitch));

s_a1_p=0.003;
s_a2_p=0.003;
s_omega_ip1=3.0e-8;
s_omega_ip2=3.0e-8;


s_pitch = s_a1_p/(g*cos(pitch));
s_roll = sqrt(cos(pitch)^2*s_a2_p^2+sin(pitch)^2*a2_p^2*s_pitch^2)/g/cos(pitch)^2/cos(roll);
s_yaw = cos(yaw)^2*sqrt(omega_ip2^2*s_omega_ip1^2+omega_ip1^2*s_omega_ip2 ^2)/omega_ip1^2;
s_yaw2=sqrt(omega_ip2^2*s_omega_ip1^2+omega_ip1^2*s_omega_ip2 ^2)/(omega_ip1^2+omega_ip2^2);
%% Task 3

Lon1=[13,17,34.187];
Lat1=[0,0,0];
H1=50;

Lon2=[17,17,24.356];
Lat2=[47,21,26.483];
H2=125.13;

Lon3=[12,13,12.156];
Lat3=[90,0,0];
H3=50;


Lon1=dms2rad(Lon1);
Lat1=dms2rad(Lat1);
Lon2=dms2rad(Lon2);
Lat2=dms2rad(Lat2);
Lon3=dms2rad(Lon3);
Lat3=dms2rad(Lat3);
Ome_n_ie1=Omega_n_ie(Lat1,Lon1);
Ome_n_ie2=Omega_n_ie(Lat2,Lon2);
Ome_n_ie3=Omega_n_ie(Lat3,Lon3);




function y=Omega_n_ie(phi,lambda)


C_en=[-sin(phi)*cos(lambda),-sin(lambda),-cos(phi)*cos(lambda);
     -sin(phi)*sin(lambda),cos(lambda),-cos(phi)*sin(lambda);
     cos(phi),0,-sin(phi)];
 wE=7.292115816e-5;
 Omega_e_ie=[0,-wE,0;wE,0,0;0,0,0];
 C_ne=C_en';
 y=C_ne*Omega_e_ie*C_en;
 
end

function y=dms2rad(x)

y=(x(1)+x(2)/60+x(3)/3600)*pi/180;
end

