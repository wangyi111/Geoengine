function [Plm_norm] = Rodrigues_Ferrers(l,m,ts)
    % purpose: to 
    % input: degree l order m, and calculate the normalized associate legendre function (ALF)
    %          with a set of theta (colatitude), substitute with t = cos(theta)
    % output: the calculated ALF with degree l order m at specific
    %           colatitude theta. theta can be a vector input.
    
    syms t
    Pl = 1/(2^l*factorial(l))*diff((t^2-1).^l,l); %Rodrigues
    Plm = (1-t^2)^(m/2)*diff(Pl,m); %Ferrers
    
    % normalize
    if m == 0
        Plm_norm = sqrt(2*l+1)*Plm;
    elseif m > 0
        Plm_norm = sqrt(2*(2*l+1)*factorial(l-m)/factorial(l+m))*Plm;
    end
    
    Plm_norm = vpa(subs(Plm_norm,t,ts));
    % vpa to approximate symbolic results with floating-point numbers:
end