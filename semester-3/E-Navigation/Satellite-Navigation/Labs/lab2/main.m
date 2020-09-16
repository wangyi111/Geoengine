clear all;
close all;
clc;

format long;

% opening the NAV RINEX files
fileNav = fopen([pwd '/test.18n']);               
   
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





