function [Plm Plm_all] = Recursive(l,m,t)
    % calculate recursively the non- normalized ALF to the requested order and 
    % degree at specific t which is cos(theta) --the colatitude can be
    % vector
    % return a vector of Legendre for all t (latitude components) 
%% to store calculated value
    global Plm_all;
    global check;
    try 
        if(check(l+3,m+3)== 1)
            Plm(:) = Plm_all(l+3,m+3,:);
            return
        end
    catch
       % extend original size
       extend1 = zeros(l+3,m+3,size(t,2));
       extend2 = logical(zeros(l+3,m+3));
       [n,p,q]=size(Plm_all);
       [r,s]=size(check);
       extend1(1:n,1:p,:) = Plm_all;
       extend2(1:r,1:s) = check;
       Plm_all = extend1; 
       check = extend2; 
   end
%% recursive function        
    % not exist situation, m must be smaller than l
    if (m < 0 || l < 0)
        Plm = zeros(1,size(t,2));
        Plm_all(l+3,m+3,:) = Plm;
        check(l+3,m+3) = 1;
        return
    % two base case of recursive function
    elseif(m == 0 && l == 0)
        Plm = ones(1,size(t,2));
        Plm_all(l+3,m+3,:) = Plm;
        check(l+3,m+3) = 1;
        return
    elseif(m == 0 && l ==1)
        Plm = t;
        Plm_all(l+3,m+3,:) = Plm;
        check(l+3,m+3) = 1;
        return
    elseif( m == 1 && l == 1)
        Plm = sqrt(1-t.^2);
        Plm_all(l+3,m+3,:) = Plm;
        check(l+3,m+3) = 1;
        return
    % diagonal movement calculation
    elseif( m == l)
        Plm = (2*l-1).*sqrt(1-t.^2) .* Recursive(l-1,l-1,t);
        Plm_all(l+3,m+3,:) = Plm;
        check(l+3,m+3) = 1;
        return
    % horizontal movement calculation    
    else 
        Plm = (1/(l-m))*(((2*l-1).* t .* Recursive(l-1,m,t))-...
            ((l-1+m) * Recursive(l-2,m,t)));
        Plm_all(l+3,m+3,:) = Plm;
        check(l+3,m+3) = 1;
        return
    end
    
end