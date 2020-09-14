D=xlsread('Gnss_PID_controller.xlsx');

figure;
plot(D(:,3)/1e4,D(:,4)/1e4,'--');hold on;
plot(D(:,10)/1e4,D(:,11)/1e4);
curtick = get(gca, 'XTick');
set(gca, 'XTickLabel', cellstr(num2str(curtick(:))));
curtick = get(gca, 'YTick');
set(gca, 'YTickLabel', cellstr(num2str(curtick(:))));
daspect([1 1 1]);
title('trajectories (GNSS sensor,PID controller)');
legend('GNSS trajectory','reference trajectory');
xlabel('Rechts(Y)[m]');
ylabel('Hoch(X)[m]');

figure
plot(D(:,9));
title('lateral deviation');
xlabel('measurements');
ylabel('lateral deviation[m]');

rms=sqrt(sum(D(:,9).^2)/size(D(:,9),1));
rms2=sqrt(sum(D(1000:end,9).^2)/size(D(1000:end,9),1));


