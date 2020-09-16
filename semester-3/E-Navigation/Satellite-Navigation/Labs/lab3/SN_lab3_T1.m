clear;
clc;


PRN=PRN_GLONASS(7);
PRN(1:20)
PRN(492:511)

figure();
subplot(1,2,1);
%plot(1:20,PRN(1:20),'o');
scatter(1:20,PRN(1:20),'filled');
subplot(1,2,2);
% plot(492:511,PRN(492:511),'o');
scatter(492:511,PRN(492:511),'filled');

function PRN=PRN_GLONASS(n)
SR=[1,1,1,1,1,1,1,1,1];
L=1;
while(L<512)
  
    temp=modulo_add(SR(5),SR(9));
%     SR(2)=SR(1);
  for i=1:8
      SR(10-i)=SR(9-i);
  end
  SR(1)=temp;
%   SR(1)=modulo_add(SR(5),SR(9));
  PRN(L)=SR(n);
  L=L+1;
  
end





end

function y=modulo_add(x1,x2)

if (mod(x1+x2,2)==0)
    y=0;
else
    y=1;
end
end