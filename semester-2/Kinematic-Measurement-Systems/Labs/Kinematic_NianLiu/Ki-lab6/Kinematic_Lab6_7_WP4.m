% clear command window
clc
% clear workspace
clear    
% close all graphics
close all
% make the format long
format longG

%% Import Data

ds = xlsread('Gnss_P_controller.xlsx', 'Gnss_P_controller', 'i2:i2426') ;
y  = xlsread('Gnss_P_controller.xlsx', 'Gnss_P_controller', 'c2:c2426') ;
x  = xlsread('Gnss_P_controller.xlsx', 'Gnss_P_controller', 'd2:d2426') ;
t  = xlsread('Gnss_P_controller.xlsx', 'Gnss_P_controller', 'a2:a2426') ;
t  =(t(:,1) - t(1)) ./1e3 ; 

%% Calculate RMS of lateral deviation

l_1 = [211:400 754:989];
cu_1 = [1:138 472:676 1064:1209];
cl_1 = [139:210 400:471 677:753 990:1063];

l_2 = [1372:1560 1917:2150];
cu_2 = [1210:1300 1634:1838 2225:2425];
cl_2 = [1301:1371 1561:1633 1839:1916 2151:2224];

RMS_1 = sqrt(sum(ds(1:1209).^2) / 1209) ;
RMS_2 = sqrt(sum(ds(1210:end).^2) / length(ds(1210:end))) ;
RMS = sqrt(sum(ds.^2) / length(ds)) ;

fprintf('\nRMS of lateral deviation first round : %f [m] \n',RMS_1);
fprintf('\nRMS of lateral deviation second round : %f [m] \n',RMS_2);
fprintf('\nRMS of lateral deviation whole drive : %f [m] \n',RMS);

RMS_1_cu = sqrt(sum(ds(cu_1).^2) / length(cu_1)) ;
RMS_1_cl = sqrt(sum(ds(cl_1).^2) / length(cl_1)) ;
RMS_1_l  = sqrt(sum(ds(l_1).^2) / length(l_1)) ;

fprintf('\nRMS of lateral deviation (curve first round) : %f [m] \n',RMS_1_cu);
fprintf('\nRMS of lateral deviation (clothoid first round) : %f [m] \n',RMS_1_cl);
fprintf('\nRMS of lateral deviation (line first round) : %f [m] \n',RMS_1_l);

RMS_2_cu = sqrt(sum(ds(cu_2).^2) / length(cu_2)) ;
RMS_2_cl = sqrt(sum(ds(cl_2).^2) / length(cl_2)) ;
RMS_2_l  = sqrt(sum(ds(l_2).^2) / length(l_2)) ;

fprintf('\nRMS of lateral deviation (curve second round) : %f [m] \n',RMS_2_cu);
fprintf('\nRMS of lateral deviation (clothoid second round) : %f [m] \n',RMS_2_cl);
fprintf('\nRMS of lateral deviation (line second round) : %f [m] \n',RMS_2_l);

RMS_all_cu = sqrt(sum(ds([cu_1 cu_2]).^2) / length([cu_1 cu_2])) ;
RMS_all_cl = sqrt(sum(ds([cl_1 cl_2]).^2) / length([cl_1 cl_2])) ;
RMS_all_l  = sqrt(sum(ds([l_1 l_2]).^2) / length([l_1 l_2])) ;

fprintf('\nRMS of lateral deviation (curve whole drive) : %f [m] \n',RMS_all_cu);
fprintf('\nRMS of lateral deviation (clothoid whole drive) : %f [m] \n',RMS_all_cl);
fprintf('\nRMS of lateral deviation (line whole drive) : %f [m] \n',RMS_all_l);

%% Plot the trajectory of the vehicle

figure (1)
plot(y(1:1209), x(1:1209),y(1210:end), x(1210:end),'LineWidth',0.8);
curtick = get(gca, 'XTick');
set(gca, 'XTickLabel', cellstr(num2str(curtick(:))));
curtick = get(gca, 'YTick');
set(gca, 'YTickLabel', cellstr(num2str(curtick(:))));
ylabel(' Hoch [m]','FontWeight','bold');
xlabel('Rechts [m]','FontWeight','bold');
legend('First round','Second round')
title('Trajectory of the vehicle using P controller and GNSS sensor');

figure (2)
plot(t,ds,'LineWidth',0.4);
ylabel(' Lateral deviation ds [m]','FontWeight','bold');
xlabel('Time [s]','FontWeight','bold');
title('Lateral deviation using P controller and GNSS sensor');