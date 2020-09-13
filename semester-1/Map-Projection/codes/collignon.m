function [x,y,z]=collignon(lon,lat,const,option)
% [x,y,z]=collignon(lon,lat,const,option)
% Collignon Projection:
%         x=R*2*Lambda.*((1-sin(Phi))/pi).^(1/2);
%         y=R*pi^(1/2)*(1-(1-sin(Phi)).^(1/2));
% last change: 21/11/2018  correct the coefficients of degree-radius trans
%                          correct the calculation of G
if nargin<4
    option = 'map';
end

Lambda=lon/180*pi;
Phi=lat/180*pi;
R=const(1);

switch option
    case 'map'
        x=R*2*Lambda.*((1-sin(Phi))/pi).^(1/2);
        y=R*pi^(1/2)*(1-(1-sin(Phi)).^(1/2));
        z=[];
    case 'Tissot'
        J(:,4)=(pi*cos(Phi).^2).^(1/2)./(2*(1-sin(Phi)).^(1/2));
        J(:,3)=0;
        J(:,2)=-Lambda.*cos(Phi)./((1-sin(Phi))*pi).^(1/2);
        J(:,1)=2*((1-sin(Phi))/pi).^(1/2);
        J=J*R;
        
        C(:,4)=(pi*pi+4*Lambda.^2).*cos(Phi).^2./(4*pi*(1-sin(Phi)));
        C(:,3)=-2*Lambda.*cos(Phi)/pi;
        C(:,2)=-2*Lambda.*cos(Phi)/pi;
        C(:,1)=4*(1-sin(Phi))/pi;
        C=C*R*R;
        
        G(:,1)=cos(Phi).^2;
        G(:,4)=1;
        G(:,3)=0;
        G(:,2)=0;      
        G=G*R*R;

        x=G;
        y=C;
        z=J;
    otherwise
        error('''option'' cannot be indentified');
end

