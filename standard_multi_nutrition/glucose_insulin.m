% x' = sigma*(y-x)
% y' = x*(rho - z) - y
% z' = x*y - beta*z
function dx = glucose_insulin(t, X, I)
%function dx = glucose_insulin(t, X)
    %%parameters
    %rho = 28; 
    %sigma = 10; 
    %beta = 8/3;
    %%initialize
    %dx = zeros(3,1);
    %%set up the function
    %dx(1) = sigma*(X(2) - X(1));
    %dx(2) = X(1)*(rho - X(3)) - X(2);
    %dx(3) = X(1)*X(2) - beta*X(3);
    %return
    
    %general constants
    t_1=6;
    t_2=100;
    t_3=36;
    V_1=3;
    V_2=11;
    V_3=10;
    E=0.2;
    %I=216; %exogenous glucose delivery rate %it is in dx(3)
    
    %f_1 constants
    R_m=209;
    a_1=6.6;
    C_1=300;
    %f2 constants
    U_b=72;
    C_2=144;
    %f3 constants
    
    %f3 constants
    
    %f4 constants
    
    %f5 constants
    
    dx = zeros(6,1);
    dx(1) = R_m/(1+exp(-X(3)/(C_1*V_3) + a_1)) - E*(X(1)/V_1 - X(2)/V_2) - X(1)/t_1;
    
    dx(2) = E*(X(1)/V_1 - X(2)/V_2) - X(2)/t_2;
    
    %I_tmp=216;
    I_interpolated=interp1(I(:,1),I(:,2),t);
    
    dx(3) = 180/(1 + exp(0.29*X(6)/V_1 - 7.5)) + I_interpolated - U_b*(1- exp(-X(3)/(C_2*V_3))) - ...
        (0.01*X(3)/V_3)*(90/(1+exp(-1.772 * log(X(2)*(1/V_2 + 1/(E*t_2))) + 7.76)) + 4);
    
    dx(4) = 3*(X(1)-X(4))/t_3;
    
    dx(5) = 3*(X(4)-X(5))/t_3;
    
    dx(6) = 3*(X(5)-X(6))/t_3;
    return;
end



