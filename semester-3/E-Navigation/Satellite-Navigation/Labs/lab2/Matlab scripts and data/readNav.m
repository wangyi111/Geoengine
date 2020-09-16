function [SV] = readNav(SV, file)
count1 = 0;

if (file ~= -1)
    
    while( feof(file) == 0)
        
        while( feof(file) == 0)
            
            line = fgets(file);
                          
            if(line(61:63) == 'END')
               break;
            end;                     
        end;
        
        while( feof(file) == 0)
        
            line = fgets(file);
            sv = str2double(line(1,1:2));                                       % Satellit                         
        
            SV(sv).navData.year = 2000 + str2double(line(1,4:6));                      % year
            SV(sv).navData.month = str2double(line(1,7:9));                     % month
            SV(sv).navData.day = str2double(line(1,10:12));                     % day            
            SV(sv).navData.hour = str2double(line(1,13:15));                    % hour    
            SV(sv).navData.minute = str2double(line(1,16:18));                  % minute        
            SV(sv).navData.second = str2double(line(1,19:22));                  % second    
        
            SV(sv).navData.af0 = str2num(line(1,23:41));                  % clockBias [sec]
            SV(sv).navData.af1 = str2num(line(1,42:60));                 % clockDrift [sec/sec]
            SV(sv).navData.af2 = str2num(line(1,61:79));             % clockDriftRate [sec/sec2]
            
            line = fgets(file);                                                 % erste Zeile
            
            SV(sv).navData.IODE = str2num(line(1,3:22));                        % IODE []
            SV(sv).navData.Crs = str2num(line(1,23:41));                        % Crs [m]
            SV(sv).navData.DeltaN = str2num(line(1,42:60));                     % Delta N [rad/sec]
            SV(sv).navData.M0 = str2num(line(1,61:79));                         % M0 [rad]
        
            line = fgets(file);                                                 % zweite Zeile                
            
            SV(sv).navData.Cuc = str2num(line(1,3:22));                         % Cuc [rad]
            SV(sv).navData.e = str2num(line(1,23:41));                          % e [Eccentricity]
            SV(sv).navData.Cus = str2num(line(1,42:60));                        % Cus[rad]
            SV(sv).navData.sqrtA = str2num(line(1,61:79));                      % sqrt A [rad]
            
            line = fgets(file);                                                 % dritte Zeile
            
            SV(sv).navData.TOE = str2num(line(1,3:22));                         % Time of Ephemeris (TOE) [sec of GPS week]
            SV(sv).navData.Cic = str2num(line(1,23:41));                        % Cic [rad]
            SV(sv).navData.OMEGA0 = str2num(line(1,42:60));                     % OMEGA [rad]
            SV(sv).navData.Cis = str2num(line(1,61:79));                        % Cis [rad]
            
            line = fgets(file);                                                 % vierte Zeile
            
            SV(sv).navData.i0 = str2num(line(1,3:22));                          % i0 [rad]
            SV(sv).navData.Crc = str2num(line(1,23:41));                        % Crc [m]
            SV(sv).navData.omega = str2num(line(1,42:60));                      % omega [rad]
            SV(sv).navData.OMEGA_DOT = str2num(line(1,61:79));                  % OMEGA_DOT [rad/sec]

            line = fgets(file);                                                 % fuenfte Zeile
            
            SV(sv).navData.IDOT = str2num(line(1,3:22));                        % IDOT [rad]
            SV(sv).navData.CodesOnL2Channel = str2num(line(1,23:41));           % Codes on L2 Channel [m]
            SV(sv).navData.GPSWeek = str2num(line(1,42:60));                    % GPS Week 
            SV(sv).navData.GPSWeek2 = str2num(line(1,61:79));                   % GPS Week2 

            line = fgets(file);                                                 % sechste Zeile
            
            SV(sv).navData.SVaccuracy = str2num(line(1,3:22));                  % SVaccuracy 
            SV(sv).navData.SVhealth = str2num(line(1,23:41));                   % SVhealth
            SV(sv).navData.TGD = str2num(line(1,42:60));                        % TGD "Total Group Delay"
            SV(sv).navData.IODCIssueOfData = str2num(line(1,61:79));            % IODCIssueOfData
            
            line = fgets(file);                                                 % siebte Zeile
            
            SV(sv).navData.TransmissionTimeOfMessage = str2num(line(1,3:22));   % Transmission Time Of Message
            % navData(35,sv) = str2num(line(1,23:41));                          % spare1 
            % navData(36,sv) = str2num(line(1,42:60));                          % spare2 
            % navData(37,sv) = str2num(line(1,61:79));                          % spare3                         
                                                    
        end;
              
    end;
    fclose(file);
end   