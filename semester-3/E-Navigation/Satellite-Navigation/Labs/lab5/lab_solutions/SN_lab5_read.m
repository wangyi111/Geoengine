t1_a=load('t1_a_NS_VDOP.txt');
V_VDOP_a=sum((t1_a(:,7)-mean(t1_a(:,7))).^2)/length(t1_a(:,7));
t1_c=load('t1_c_NS_VDOP.txt');
V_VDOP_c=sum((t1_c(:,7)-mean(t1_c(:,7))).^2)/length(t1_c(:,7));

t2_a_xyz=load('t2_a_xyz');
t2_b_xyz=load('t2_b_xyz');

set(0,'defaultfigurecolor',[1 1 1]);

figure();
diff=[t2_a_xyz(:,3)-t2_b_xyz(:,3),t2_a_xyz(:,4)-t2_b_xyz(:,4),t2_a_xyz(:,5)-t2_b_xyz(:,5)];
subplot(3,1,1);
plot(t2_a_xyz(:,2),diff(:,1));
xlabel('GPS time (s)');
ylabel('X (m)');
subplot(3,1,2);
plot(t2_a_xyz(:,2),diff(:,2));
xlabel('GPS time (s)');
ylabel('Y (m)');
subplot(3,1,3);
plot(t2_a_xyz(:,2),diff(:,3));
xlabel('GPS time (s)');
ylabel('Z (m)');


t2_a=load('t2_a');
t2_b=load('t2_b');

figure();
diff=[t2_a(:,3)-t2_b(:,3),t2_a(:,4)-t2_b(:,4),t2_a(:,5)-t2_b(:,5)];
subplot(3,1,1);
plot(t2_a(:,2),diff(:,1));
xlabel('GPS time (s)');
ylabel('Lon (deg)');
subplot(3,1,2);
plot(t2_a(:,2),diff(:,2));
xlabel('GPS time (s)');
ylabel('Lat (deg)');
subplot(3,1,3);
plot(t2_a(:,2),diff(:,3));
xlabel('GPS time (s)');
ylabel('Height (m)');
