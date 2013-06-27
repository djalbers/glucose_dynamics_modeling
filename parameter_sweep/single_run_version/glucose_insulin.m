% we need to add which parameter we change, and by how much.


% x' = sigma*(y-x)
% y' = x*(rho - z) - y
% z' = x*y - beta*z
function dx = glucose_insulin(t, X, I, P)

  %parameters:
  % plasma volume V_p
  V_1=P(1);
  % insulin volume V_i
  V_2=P(2);
  % glucose space V_g
  V_3=P(3);
  % E exchange rate for insulin between remote and plasma
  E=P(4);
  % compartments
  % I_G feeding rate
  %THIS IS SET VIA THE FEEDING SCHEMES.
  % t_p time constant for plasma insulin degredataion
  t_1=P(5);
  % t_i time constant for remote insulin degredation
  t_2=P(6);
  % t_d delay between plasma insulin and glucose production ---
  % important?
  t_3=P(7);
  % R_m NO IDEA
  R_m=P(8);
  % a_1 constant in f_1
  a_1=P(9);
  % C_1
  C_1=P(10); 
  % C_2
  C_2=P(11); 
  % C_3
  C_3=P(12);
  % C_4
  C_4=P(13);
  % C_5
  C_5=P(14);
  % U_b
  U_b=P(15); 
  % U_0
  U_0=P(16);
  % U_m
  U_m=P(17);
  % R_g
  R_g=P(18);
  % alpha
  alpha=P(19);
  % beta
  beta=P(20);
  
  dx = zeros(6,1);
  dx(1) = R_m/(1+exp(-X(3)/(C_1*V_3) + a_1)) - E*(X(1)/V_1 - X(2)/V_2) - X(1)/t_1;
    
  dx(2) = E*(X(1)/V_1 - X(2)/V_2) - X(2)/t_2;
  
  %I_tmp=216;
  I_interpolated=interp1(I(:,1),I(:,2),t);
  
  %dx(3) = 180/(1 + exp(0.29*X(6)/V_1 - 7.5)) + I_interpolated - U_b*(1- exp(-X(3)/(C_2*V_3))) - ...
  %    (0.01*X(3)/V_3)*(90/(1+exp(-1.772 * log(X(2)*(1/V_2 + 1/(E*t_2))) + 7.76)) + 4);
  
  kappa=(1/C_4)*(1/V_2 + 1/(E*t_2));
  
  dx(3) = R_g/(1 + exp(alpha*(X(6)/(C_5*V_1) - 1))) + I_interpolated ...
          - U_b*(1- exp(-X(3)/(C_2*V_3))) - (1/(C_3*V_3))*(U_0 + (U_m - U_0)/(1+ power(kappa*X(2),-beta)))*X(3);
  
  dx(4) = 3*(X(1)-X(4))/t_3;
  
  dx(5) = 3*(X(4)-X(5))/t_3;
  
  dx(6) = 3*(X(5)-X(6))/t_3;
  return;
end



