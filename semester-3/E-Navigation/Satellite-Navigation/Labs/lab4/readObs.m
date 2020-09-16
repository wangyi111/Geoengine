function [G, R, S, E, C, J, numEpoche, numSat,numSat_epoch] = readObs(file)
% GPS, GLONASS, SBAS paylaod, Galileo, Beidou, Qzss, IRNSS
% Start timer
tic;
row = countlines(file);
% Open file
fid = fopen(file);
% Initialzie waitbar.  Allows monitoring progress of reading
wB = waitbar(0,'GNSS-Beobachtungsdaten einlesen ....');

numEpoche = 0;
numline = 0;
% head of Observations
while(~feof(fid))
    line = fgets(fid);
    numline = numline + 1;
    waitbar(numline/row,wB);
    
    if(strcmp(line(61:63),'END'))
        break;
    end;                     
end;

J=cell(1,11); % yi 13.12.2019  initialize J for argument not assigned error
while(~feof(fid))
    line = fgets(fid);
    numline = numline + 1;
    waitbar(numline/row,wB);

    %leere Zeile
    if(size(line,2) == 1)
        break;
    end
    % naechste Epoche
    numEpoche = numEpoche + 1;

    year = str2double(line(1,3:6));
    month = str2double(line(1,7:10));
    day = str2double(line(1,11:13));
    hour = str2double(line(1,14:16));       
    minute = str2double(line(1,17:19)); 
    second = str2double(line(1,20:29)); 
    numSat(1,numEpoche) = str2double(line(1,34:35));% number of satellites

    % Initialisierung
    % Anzahl der empfangenen Satelliten jedes Systems
    num_G = 0;
    num_S = 0;
    num_R = 0;
    num_E = 0;
    num_J = 0;
    num_C = 0;
    
    for i = 1:numSat(1,numEpoche) %Zeile i (ein Satellit) in einer Epoche
        line = fgets(fid);
        numline = numline + 1;
        waitbar(numline/row,wB);
        
        Satsys = line(1,1);
        if Satsys == 'G'
            [~,n] = size(line);
            Satnum = str2double(line(2:3));
            G{Satnum}.C1C(numEpoche,1) = str2double(line(6:17));
            G{Satnum}.L1C(numEpoche,1) = str2double(line(21:33));
            G{Satnum}.S1C(numEpoche,1) = str2double(line(44:49));
            if n>=65
                G{Satnum}.C2W(numEpoche,1) = str2double(line(54:65));
            end
            if n>=83
                G{Satnum}.L2W(numEpoche,1) = str2double(line(69:81));
            end
            if n>=97
                G{Satnum}.S2W(numEpoche,1) = str2double(line(92:97)); 
            end
            if n>=113
                G{Satnum}.C2X(numEpoche,1) = str2double(line(102:113));
            end
            if n>=129
                G{Satnum}.L2X(numEpoche,1) = str2double(line(117:129));
            end
            if n>=144
                G{Satnum}.S2X(numEpoche,1) = str2double(line(140:144));
            end
            if n>=162
                G{Satnum}.C5X(numEpoche,1) = str2double(line(150:162));
            end
            if n>=177
                G{Satnum}.L5X(numEpoche,1) = str2double(line(165:177));
            end
            if n>=193
                G{Satnum}.S5X(numEpoche,1) = str2double(line(188:193));
            end

            G{Satnum}.year(numEpoche,1) = year;
            G{Satnum}.month(numEpoche,1) = month;
            G{Satnum}.day(numEpoche,1) = day;
            G{Satnum}.hour(numEpoche,1) = hour;
            G{Satnum}.minute(numEpoche,1) = minute;
            G{Satnum}.second(numEpoche,1) = second;

            num_G = num_G + 1;
        end

        if Satsys == 'S'
            Satnum = str2double(line(2:3));
            S{Satnum}.C1C(numEpoche,1) = str2double(line(6:17));
            S{Satnum}.L1C(numEpoche,1) = str2double(line(21:33));
            S{Satnum}.S1C(numEpoche,1) = str2double(line(44:49));

            S{Satnum}.year(numEpoche,1) = year;
            S{Satnum}.month(numEpoche,1) = month;
            S{Satnum}.day(numEpoche,1) = day;
            S{Satnum}.hour(numEpoche,1) = hour;
            S{Satnum}.minute(numEpoche,1) = minute;
            S{Satnum}.second(numEpoche,1) = second;

            num_S = num_S + 1;
        end

        if Satsys == 'R'
            [~,n] = size(line);
            Satnum = str2double(line(2:3));
            R{Satnum}.C1C(numEpoche,1) = str2double(line(6:17));
            R{Satnum}.L1C(numEpoche,1) = str2double(line(21:33));
            R{Satnum}.S1C(numEpoche,1) = str2double(line(44:49));
            if n>=65
                R{Satnum}.C1P(numEpoche,1) = str2double(line(54:65));
            end
            if n>=81
                R{Satnum}.L1P(numEpoche,1) = str2double(line(69:81));
            end
            if n>=97
                R{Satnum}.S1P(numEpoche,1) = str2double(line(92:97));
            end
            if n>=113
                R{Satnum}.C2C(numEpoche,1) = str2double(line(102:113));
            end
            if n>=129
                R{Satnum}.L2C(numEpoche,1) = str2double(line(117:129));
            end
            if n>=145
                R{Satnum}.S2C(numEpoche,1) = str2double(line(140:145));
            end
            if n>=161
                R{Satnum}.C2P(numEpoche,1) = str2double(line(150:161));
            end
            if n>=178
                R{Satnum}.L2P(numEpoche,1) = str2double(line(165:178));
            end
            if n>=193
                R{Satnum}.S2P(numEpoche,1) = str2double(line(188:193));
            end

            R{Satnum}.year(numEpoche,1) = year;
            R{Satnum}.month(numEpoche,1) = month;
            R{Satnum}.day(numEpoche,1) = day;
            R{Satnum}.hour(numEpoche,1) = hour;
            R{Satnum}.minute(numEpoche,1) = minute;
            R{Satnum}.second(numEpoche,1) = second;
            
            num_R = num_R + 1;
        end

        if Satsys == 'E'
            [~,n] = size(line);
            Satnum = str2double(line(2:3));
            E{Satnum}.C1X(numEpoche,1) = str2double(line(6:17));
            E{Satnum}.L1X(numEpoche,1) = str2double(line(21:33));
            E{Satnum}.S1X(numEpoche,1) = str2double(line(44:49));
            if n>=65
                E{Satnum}.C5X(numEpoche,1) = str2double(line(54:65));
            end
            if n>=81
                E{Satnum}.L5X(numEpoche,1) = str2double(line(69:81));
            end
            if n>=97
                E{Satnum}.S5X(numEpoche,1) = str2double(line(92:97));
            end
            if n>=113
                E{Satnum}.C7X(numEpoche,1) = str2double(line(102:113));
            end
            if n>=129
                E{Satnum}.L7X(numEpoche,1) = str2double(line(117:129));
            end
            if n>=145
                E{Satnum}.S7X(numEpoche,1) = str2double(line(140:145));
            end
            if n>=161
                E{Satnum}.C8X(numEpoche,1) = str2double(line(150:161));
            end
            if n>=178
                E{Satnum}.L8X(numEpoche,1) = str2double(line(165:178));
            end
            if n>=193
                E{Satnum}.S8X(numEpoche,1) = str2double(line(188:193));
            end

            E{Satnum}.year(numEpoche,1) = year;
            E{Satnum}.month(numEpoche,1) = month;
            E{Satnum}.day(numEpoche,1) = day;
            E{Satnum}.hour(numEpoche,1) = hour;
            E{Satnum}.minute(numEpoche,1) = minute;
            E{Satnum}.second(numEpoche,1) = second;

            num_E = num_E + 1;
        end

        if Satsys == 'J'
            [~,n] = size(line);
            Satnum = str2double(line(2:3));
            J{Satnum}.C1C(numEpoche,1) = str2double(line(6:17));
            J{Satnum}.L1C(numEpoche,1) = str2double(line(21:33));
            J{Satnum}.S1C(numEpoche,1) = str2double(line(44:49));
            if n>= 67
                J{Satnum}.C1X(numEpoche,1) = str2double(line(54:65));
            end
            if n>=83
                J{Satnum}.L1X(numEpoche,1) = str2double(line(69:81));
            end
            if n>=97
                J{Satnum}.S1X(numEpoche,1) = str2double(line(92:97));
            end
            if n>=115
                J{Satnum}.C2X(numEpoche,1) = str2double(line(102:113));
            end
            if n>=131
                J{Satnum}.L2X(numEpoche,1) = str2double(line(117:129));
            end
            if n>=145
                J{Satnum}.S2X(numEpoche,1) = str2double(line(140:145));
            end
            if n>=163
                J{Satnum}.C5X(numEpoche,1) = str2double(line(150:161));
            end
            if n>=179
                J{Satnum}.L5X(numEpoche,1) = str2double(line(165:177));
            end
            if n>=193
                J{Satnum}.S5X(numEpoche,1) = str2double(line(188:193));
            end
            if n>=211
                J{Satnum}.C6X(numEpoche,1) = str2double(line(198:209));
            end
            if n>=227
                J{Satnum}.L6X(numEpoche,1) = str2double(line(213:225));
            end
            if n>= 241
                J{Satnum}.S6X(numEpoche,1) = str2double(line(236:241));
            end

            J{Satnum}.year(numEpoche,1) = year;
            J{Satnum}.month(numEpoche,1) = month;
            J{Satnum}.day(numEpoche,1) = day;
            J{Satnum}.hour(numEpoche,1) = hour;
            J{Satnum}.minute(numEpoche,1) = minute;
            J{Satnum}.second(numEpoche,1) = second;
            
            num_J = num_J + 1;
        end

        if Satsys == 'C'
            [~,n] = size(line);
            Satnum = str2double(line(2:3));
            C{Satnum}.C2I(numEpoche,1) = str2double(line(6:17));
            C{Satnum}.L2I(numEpoche,1) = str2double(line(21:33));
            C{Satnum}.S2I(numEpoche,1) = str2double(line(44:49));
            if n>= 65
                C{Satnum}.C7I(numEpoche,1) = str2double(line(54:65));
            end
            if n>=81
                C{Satnum}.L7I(numEpoche,1) = str2double(line(69:81));
            end
            if n>=97
                C{Satnum}.S7I(numEpoche,1) = str2double(line(92:97));
            end
            if n>=113
                C{Satnum}.C6I(numEpoche,1) = str2double(line(102:113));
            end
            if n>=129
                C{Satnum}.L6I(numEpoche,1) = str2double(line(117:129));
            end
            if n>=145
                C{Satnum}.S6I(numEpoche,1) = str2double(line(140:145));
            end

            C{Satnum}.year(numEpoche,1) = year;
            C{Satnum}.month(numEpoche,1) = month;
            C{Satnum}.day(numEpoche,1) = day;
            C{Satnum}.hour(numEpoche,1) = hour;
            C{Satnum}.minute(numEpoche,1) = minute;
            C{Satnum}.second(numEpoche,1) = second;  

            num_C = num_C + 1;

        end
    end
    % Anzahl Sat. je System pro Epoch
    numSat_epoch(1:6,numEpoche) = [num_G; num_S; num_R; num_E; num_J; num_C];
end

fclose(fid);

%   Close waitbar and stop timer
close(wB);
toc; 
end

function row = countlines(file)
% tic;
if(ispc)
    if(exist('countlines.pl','file')~=2)
        fid=fopen('countlines.pl','w');
        fprintf(fid,'%s\n%s','while(<>){}','print $.,"\n";');
        fclose(fid);
    end
    row=str2double(perl('countlines.pl',file));
elseif(isunix)
    [~,numstr]=system(['wc -l',file]);
    row = str2double(numstr);
end
% toc;
return;
end