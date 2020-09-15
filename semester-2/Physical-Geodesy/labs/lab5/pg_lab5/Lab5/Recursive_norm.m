function [Plm_norm Plm_norm_all] = Recursive_norm(l,m,t)
    % calculate recursively the normalized ALF to the requested order and 
    % degree at specific t which is cos(theta) --the colatitude can be
    % vector
    % return a vector of Legendre for all t (latitude components) 
 %% to store calculated value
   global Plm_norm_all;  %% a 3D matrix to store each l,m and calculated at vector t
   global check2; % a 2D logical matrix to check2 which l and m is calculated. 
   try 
       if(check2(l+3,m+3)== 1) 
            Plm_norm(:) = Plm_norm_all(l+3,m+3,:);
            return
       end
   catch
       % extend original size
       extend1 = zeros(l+3,m+3,size(t,2));
       extend2 = logical(zeros(l+3,m+3));
       [n,p,q]=size(Plm_norm_all);
       [r,s]=size(check2);
       extend1(1:n,1:p,:) = Plm_norm_all;
       extend2(1:r,1:s) = check2;
       Plm_norm_all = extend1; 
       check2 = extend2; 
   end
%% recursive function
    % not exist situation, m must be smaller than l
    if (m < 0 || l < 0)
        Plm_norm = zeros(1,size(t,2));
        Plm_norm_all(l+3,m+3,:) = Plm_norm;
        check2(l+3,m+3) = 1;
        return
    % two base case of recursive function
    elseif(m == 0 && l == 0)
        Plm_norm = ones(1,size(t,2));
        Plm_norm_all(l+3,m+3,:) = Plm_norm;
        check2(l+3,m+3) = 1;
        return
    elseif( m == 1 && l == 1)
        Plm_norm = sqrt(3*(1-t.^2));
        Plm_norm_all(l+3,m+3,:) = Plm_norm;
        check2(l+3,m+3) = 1;
        return
    % diagonal movement calculation
    elseif( m == l)
        Plm_norm = sqrt((2*l+1)/(2*l))*sqrt(1-t.^2) .* Recursive_norm(l-1,l-1,t);
        Plm_norm_all(l+3,m+3,:) = Plm_norm;
        check2(l+3,m+3) = 1;
        return
        
    % horizontal movement calculation    
    else 
        Plm_norm = sqrt((2*l+1)/((l+m)*(l-m)))*...
            ((sqrt(2*l-1)*t.*Recursive_norm(l-1,m,t))-...
            ((sqrt((l-1+m)*(l-1-m)/(2*l-3)))*Recursive_norm(l-2,m,t)));
        Plm_norm_all(l+3,m+3,:) = Plm_norm;
        check2(l+3,m+3) = 1;
        return
    end
    
end