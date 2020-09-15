 function Yl_m = spherical_harmonic (l,m,lamda,Pl_m)
    % longitude components
    cos_term = cosd(m * lamda);
    sin_term = sind(m * lamda);
    cos_2D = meshgrid(cos_term, linspace(1,180));
    sin_2D = meshgrid(sin_term, linspace(1,180));

    % co-latitude components
    % t= cos(theta)
    Pl_m_2D = meshgrid(Pl_m, lamda)';

    % combination Ylm = Plm *cos(mlamda) or sin(mlamda)
    Yl_m_1 = Pl_m_2D .* cos_2D;
    Yl_m_2 = Pl_m_2D .* sin_2D;
    Yl_m = double(Yl_m_1 + Yl_m_2);
 
%         x = sin(theta).*cos(lamda);
%         y = sin(theta).*sin(lamda);
%         z = cos(theta);
%         surf(x,y,z,[0 360 0 180])
end 
    