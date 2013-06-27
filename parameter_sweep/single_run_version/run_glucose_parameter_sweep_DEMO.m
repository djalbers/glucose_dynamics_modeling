%this is a demo script for how to run the parameter sweep for the
%sturgis model.  the feeding optoins are the same as the other
%cases  the parameter sweep options and other parameters are
%discussed below.

%1 - plasma volume V_p; 2 - insulin volume V_i; 3 - glucose space V_g;
%4 - E exchange rate for insulin between remote and plasma
%compartments; 5 - I_G feeding rate THIS IS SET VIA THE FEEDING
%SCHEMES; 6 - t_p time constant for plasma insulin degredation; 6 - t_i
%time constant for remote insulin - degredation; 7 - t_d delay between
%plasma insulin and glucose production; - 8 - R_m; 9 - a_1 constant in
%f_1; 10 - C_1; 11 - C_2; 12 - C_3; 13 - C_4; - 14 - C_5; 15 - U_b; 16
%- U_0; 17 - U_m; 18 - R_g; 19 - alpha; 20 - beta.

which_bif_parameter=10; %example, sweep C_1
%bif_parameter_percent_variation=0.25;
bif_parameter_percent_variation=2;
number_of_bif_points=40;
%integration_iterates=2880; %2 days worth of minutes
integration_iterates=129600; %90 days worth of minutes
time_steps_per_hour=60;

addpath('./matlab_utilities');
mkdir([pwd, '/', num2str(which_bif_parameter)]);
cd([pwd, '/', int2str(which_bif_parameter)]);
copyfile(['../glucose_model_bifurcation_sweep.m'], '.');
copyfile(['../feeding.m'], '.');
copyfile(['../glucose_insulin.m'], '.');

root_path=pwd;
addpath(root_path);

execution_path=root_path;
home_directory=(pwd);

glucose_model_bifurcation_sweep(execution_path, home_directory, which_bif_parameter, bif_parameter_percent_variation, number_of_bif_points, integration_iterates, time_steps_per_hour);
cd('..');



