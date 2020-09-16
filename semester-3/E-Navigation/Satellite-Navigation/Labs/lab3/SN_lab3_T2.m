%%%%%%%%%%%%%%%%%%%%%
% shift 1 bit
clear;
clc;

%% b
for i=1:15
PRN(i,:)=PRN_Beidou(i);
end
PRN_control_start=PRN(:,1:10);
PRN_control_end=PRN(:,2037:2046);

figure(1);
for i=1:15
subplot(3,5,i);
scatter(1:10,PRN_control_start(i,:),'filled');
end
title('first 10 bits');

figure(2);
% title('last 10 bits');
for i=1:15
subplot(3,5,i);
scatter(2037:2046,PRN_control_end(i,:),'filled');
end
% title('last 10 bits');

% c

bds=load('bds.txt');
figure(3);
for i=1:15
    [corr(i,:),lag(i,:)]=xcorr(bds,PRN(i,:));
%     corr(i,:)=corr(i,:)/max(abs(corr(i,:)));

%     x = PRN(i,:);
%     for j=0:length(x)-1
%         xi=circshift(x,j);
%         CC(i,j+1)=sum(xi.*bds);
%     end
    subplot(3,5,i);
%     plot(1:2046,CC(i,:));
    plot(lag(i,:),corr(i,:));
end
% figure(4);
% plot(lag(1,:),corr(1,:));



%% functions
function PRN=PRN_Beidou(n)
G1=[0,1,0,1,0,1,0,1,0,1,0];
G2=[0,1,0,1,0,1,0,1,0,1,0];
L=1;
while(L<2047)
    
    m1=[G1(1),G1(7:11)];
    temp1=modulo_add(m1);
  for i=1:10
      G1(12-i)=G1(11-i);
  end
  G1(1)=temp1;

    G1_out=G1(11);
    
    m2=[G2(1:5),G2(8:9),G2(11)];
    temp2=modulo_add(m2);
    for i=1:10
      G2(12-i)=G2(11-i);
    end
    G2(1)=temp2;
    
    if(n<5)
        G2_out=modulo_add([G2(1),G2(n+2)]);
    elseif(n<9)
        G2_out=modulo_add([G2(1),G2(n+3)]);
    elseif(n==9)
        G2_out=modulo_add([G2(2),G2(7)]);
    elseif(n<13)
        G2_out=modulo_add([G2(3),G2(n-6)]);
    elseif(n<16)
        G2_out=modulo_add([G2(3),G2(n-5)]);
    elseif(n>15)
        error('input out of num range!');
    end
    
    PRN(L)=modulo_add([G1_out,G2_out]);

%   PRN(L)=G1(n);
  L=L+1;
  
end





end

function y=modulo_add(x)

if (mod(sum(x),2)==0)
    y=0;
else
    y=1;
end
end