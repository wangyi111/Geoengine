clear;
clc;
%3.525361612190774e+07
%3.525361612162132e+07
% S14=SV(14).navData;
% S18=SV(18).navData;
% 
% a1=(S14.sqrtA)^2;
% a2=(S18.sqrtA)^2;


filePath='/test.18n';
SV=loadSV(filePath);



%% T2.1
WN=2016;
TOW1=561600;
[P14,v14]=SatPosition(SV,14,WN,TOW1);
[P18,v18]=SatPosition(SV,18,WN,TOW1);
Dis=sqrt(sum((P14-P18).^2));
% disp(Dis);

%% T2.2
TOW2=564600;
[P10_0,v10_0]=SatPosition(SV,10,WN,TOW2);
% disp(v10_0);

%% T2.3 4
[P10_1,v10_1]=SatPosition(SV,10,WN,TOW2-1);
[P10_2,v10_2]=SatPosition(SV,10,WN,TOW2+1);

%% T2.5
v10_5=(P10_2-P10_1)/2;
v_diff=v10_0-v10_5;
% disp(v10_5);
% disp(v_diff);

function y=R1(x)
y=[1,0,0;0,cos(x),sin(x);0,-sin(x),cos(x)];
end
function y=R2(x)
y=[cos(x),0,-sin(x);0,1,0;sin(x),0,cos(x)];
end
function y=R3(x)
y=[cos(x),sin(x),0;-sin(x),cos(x),0;0,0,1];
end


function [position,velocity]=SatPosition(SV,N,WN,TOW)
GM=3.9860044188e14;
OmegaE_DOT=7.2921151467e-5;
data=SV(N).navData;
a=(data.sqrtA)^2;
n0=sqrt(GM/a^3);
n=n0+data.DeltaN;
M=data.M0+n*(TOW-data.TOE);
%E=M;
%E=M+data.e*sin(E); %%% ???
E=EA(M,data.e);
nu=2*atan2(sqrt((1+data.e)/(1-data.e)),1/tan(E/2)); %% atan2?
u=data.omega+nu+data.Cuc*cos(2*(data.omega+nu))+data.Cus*sin(2*(data.omega+nu));
R=a*(1-data.e*cos(E))+data.Crc*cos(2*(data.omega+nu))+data.Crs*sin(2*(data.omega+nu));
i=data.i0+data.IDOT*(TOW-data.TOE)+data.Cic*cos(2*(data.omega+nu))+data.Cis*sin(2*(data.omega+nu));
Omega=data.OMEGA0+(data.OMEGA_DOT-OmegaE_DOT)*(TOW-data.TOE)-OmegaE_DOT*data.TOE;
% lambda???


position=R3(-Omega)*R1(-i)*R3(-u)*[R;0;0];


% velocity vector
cus = data.Cus;
cuc = data.Cuc;
crs = data.Crs;
crc = data.Crc;
cis = data.Cis;
cic = data.Cic;

Mdot = n;
Edot = Mdot/(1.0 - data.e*cos(E)); %3.26
% tak = nu; % vk True Anomaly 
nudot = sin(E)*Edot*(1.0+data.e*cos(nu))/(sin(nu)*(1.0-data.e*cos(E)));
udot = nudot + 2.0*(cus*cos(2.0*u)-cuc*sin(2.0*u))*nudot;
Rdot = a*data.e*sin(E)*n/(1.0-data.e*cos(E)) + 2.0*(crs*cos(2.0*u)-crc*sin(2.0*u))*nudot;
idot = data.IDOT + (cis*cos(2.0*u)-cic*sin(2.0*u))*2.0*nudot;
omegadot = data.OMEGA_DOT-OmegaE_DOT;

xkp=R*cos(u);
ykp=R*sin(u);

xkpdot = Rdot*cos(u) - ykp*udot;
ykpdot = Rdot*sin(u) + xkp*udot;

xkdot = ( xkpdot-ykp*cos(i)*omegadot )*cos(Omega)...
        - ( xkp*omegadot+ykpdot*cos(i)-ykp*sin(i)*idot )*sin(Omega);
ykdot = ( xkpdot-ykp*cos(i)*omegadot )*sin(Omega)...
        + ( xkp*omegadot+ykpdot*cos(i)-ykp*sin(i)*idot )*cos(Omega);
zkdot = ykpdot*sin(i) + ykp*cos(i)*idot;
velocity=[xkdot;ykdot;zkdot];
% vx = xkdot;
% vy = ykdot;
% vz = zkdot;
% vx=-n*a^2/R*sin(E);
% vy=n*a*a*sqrt(1-data.e*data.e)*cos(E);
% vz=0;
% velocity=R3(-Omega)*R1(-i)*R3(-u)*[vx;vy;vz];

end

function [SV]=loadSV(filePath)

format long;

% opening the NAV RINEX files
%fileNav = fopen([pwd '/test.18n']);               
fileNav = fopen([pwd filePath]); 
% structure of SV 
SV(1:37) = struct(...
                        'navData', ...
                                struct(...
                                    'year',0,...                            % [year]
                                    'month',0,...                           % [month]
                                    'day',0,...                             % [day]    
                                    'hour',0,...                            % [h]
                                    'minute',0,...                          % [min]
                                    'second',0,...                          % [sec]
                                    'af0',0,...                             % [sec]
                                    'af1',0,...                             % [sec/sec]    
                                    'af2',0,...                             % [sec/sec^2]
                                    'IODE',0,...                            % [-]
                                    'Crs',0,...                             % [m]
                                    'DeltaN',0,...                          % [rad/sec]
                                    'M0',0,...                              % [rad]
                                    'Cuc',0,...                             % [rad]
                                    'e',0,...                               % [eccentricity]
                                    'Cus',0,...                             % [rad]
                                    'sqrtA',0,...                           % [rad]
                                    'TOE',0,...                             % [sec of GPS week], time of ephemeris
                                    'Cic',0,...                             % [rad]
                                    'OMEGA0',0,...                          % [rad]
                                    'Cis',0,...                             % [rad]
                                    'i0',0,...                              % [rad]
                                    'Crc',0,...                             % [m]
                                    'omega',0,...                           % [rad]
                                    'OMEGA_DOT',0,...                       % [rad/sec]
                                    'IDOT',0,...                            % [rad]
                                    'CodesOnL2Channel',0,...                % [m]
                                    'GPSWeek',0,...                         % [-]
                                    'GPSWeek2',0,...                        % [-]
                                    'SVaccuracy',0,...                      %
                                    'SVhealth',0,...                        %
                                    'TGD',0,...                             % [sec], time group delay
                                    'IODCIssueOfData',0,...                 %
                                    'TransmissionTimeOfMessage',0,...       % [sec]
                                    'Spare1',0,...                          %
                                    'Spare2',0,...                          %
                                    'Spare3',0,...
                                    'Ek',0, ...
                                    'Ek_dot',0),...
                        'obs',zeros(3600, 10),...                           % [year, month, day, hour, minute, second, C1[m], L1[cycle], D1[Hz], SN1[dBHz]]   
                        'POSITION',zeros(3600,3));                          % [X[m], Y[m], Z[m]], ECEF coordinates 
                    

[SV] = readNav(SV, fileNav);
end


function [Ek] = EA(Mk, e)
% EA calculates the eccentric anomoly by iteration
dEk = inf;
eps = 1e-12;   
itermax = 100;
counter = 0;
Ek = zeros(itermax,1);
Ek(1) = Mk;
while abs(dEk) > eps && counter < itermax
    counter = counter+1;
    Ek(counter+1) = Mk + e*sin(Ek(counter));
    dEk = Ek(counter+1) - Ek(counter);
end
Ek = Ek(counter);
end

