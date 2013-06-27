%baseline, time, feeding type, parameter to change, percent of
%parameter to change you need to clear variables correctly!

function glucose_model_bifurcation_sweep(execution_path, home_directory, which_bif_parameter, bif_parameter_percent_variation, number_of_bif_points, integration_iterates, time_steps_per_hour)

addpath(execution_path);

fid=fopen([execution_path, '/foo.data'], 'w+');
fprintf(fid, '%s \n', 'phoney doctors, hello.');
fclose(fid);

  
%which_bif_parameter=1;
%bif_parameter_percent_variation=0.25;
%number_of_bif_points=5;
%integration_iterates=2880; %2 days worth of minutes
%integration_iterates=129600; %90 days worth of minutes
%time_steps_per_hour=60;

%clear all;
%close all;

%translating the time to the sturis paper
% at I=216, we have 109 matlab iterates per period
% 110.8 minutes per period
% so, among friends, we will say, that 109 matlab iterates = 109 minutes
% so, that means one iterate per minute
% 1440 minutes per day
% about 6 periods per day
% so, 3 weeks of data: 30240
% 1 week of data: 10080


%set the options for the
abstol=1e-4;
reltol=1e-4;
options = odeset('RelTol', reltol,'AbsTol',[abstol abstol abstol abstol abstol abstol]);
%here we jusst set the relative tolerance and the absolute tolerance for
%the solver...

%set the number of different patients you want to create
number_of_patients=1;
lower_feeding_bound=100;
upper_feeding_bound=225;

%parameters:
% plasma volume V_p
V_1=3;
P(1)=V_1;
% insulin volume V_i
V_2=11;
P(2)=V_2;
% glucose space V_g
V_3=10;
P(3)=V_3;
% E exchange rate for insulin between remote and plasma
E=0.2;
P(4)=0.2;
% compartments
% I_G feeding rate
%THIS IS SET VIA THE FEEDING SCHEMES.
% t_p time constant for plasma insulin degredataion
t_1=6;
P(5)=t_1;
% t_i time constant for remote insulin degredation
t_2=100;
P(6)=t_2;
% t_d delay between plasma insulin and glucose production ---
% important?
t_3=36;
P(7)=t_3;
% R_m NO IDEA
R_m=209;
P(8)=R_m;
% a_1 constant in f_1
a_1=6.6;
P(9)=a_1;
% C_1
C_1=300;
P(10)=C_1; 
% C_2
C_2=144;
P(11)=C_2; 
% C_3
C_3=100;
P(12)=C_3;
% C_4
C_4=80;
P(13)=C_4;
% C_5
C_5=26;
P(14)=C_5;
% U_b
U_b=72;
P(15)=U_b; 
% U_0
U_0=4;
P(16)=U_0;
% U_m
U_m=94;
P(17)=U_m;
% R_g
R_g=180;
P(18)=R_g;
% alpha
alpha=7.5;
P(19)=alpha;
% beta
beta=7.5;
P(20)=beta;

%I=216; %exogenous glucose delivery rate %it is in dx(3)


%initial conditions
pi_ini=200; %plasma insulin mU
ri_ini=200; %remote insulin mU
%g_ini=12000; %glucose
i_delay_1_ini=0.1;
i_delay_2_ini=0.2;
i_delay_3_ini=0.1;

% requires defs for the feeding function
%integration_iterates=30240; %3 weeks of minutes
%integration_iterates=1314000; %2.5 years worth of data output every 6 hours
%integration_iterates=2880; %2 days worth of minutes
%integration_iterates=129600; %90 days worth of minutes
I_baseline=216;
%time_steps_per_hour=60;
starting_hour=0; %the day goes from 0-23 hours
number_of_meals=3;
time_of_meals=[8 12 18]; %only relevant for feeding type 4
type_of_feeding=6;
food_decay_window_length=120; %food decays within 2 hours
eating_decay_constant=30;
%I(:,2) = feeding(integration_iterates, I_baseline, time_steps_per_hour, ...
%                 starting_hour, time_of_meals, number_of_meals, type_of_feeding, food_decay_window_length, eating_decay_constant, lower_feeding_bound, upper_feeding_bound);
%I(1:2400,2)=216;
%I(:,1) = linspace(1,max(size(I(:,2))), max(size(I(:,2))));



bif_par_begin=P(which_bif_parameter) - P(which_bif_parameter)*bif_parameter_percent_variation;
bif_par_end=P(which_bif_parameter) + P(which_bif_parameter)*bif_parameter_percent_variation;

bif_step=(bif_par_end-bif_par_begin)/number_of_bif_points;

%for trial runs with only one parameter
%bif_par=1;
%bif_par_begin=1;
%bif_step=1;
%bif_par_end=1;
parameter_count=0;

%fid=fopen([execution_path, '/foo.data'], 'w+');
%fprintf(fid, '%s \n', 'phoney doctors, hello.'); 
%fclose(fid);

for(bif_par=bif_par_begin:bif_step:bif_par_end)
  parameter_count=parameter_count+1; 
  P(which_bif_parameter)=bif_par;
  for(i=1:number_of_patients)
    if(type_of_feeding==1)
      g_ini=12000;
    elseif(type_of_feeding==2)
      g_ini=12000;
    elseif(type_of_feeding==3)
      g_ini=10600;
    elseif(type_of_feeding==4)
      g_ini=12000;
    elseif(type_of_feeding==5)
      g_ini=10600;
    elseif(type_of_feeding==6)
      g_ini=10600;
    elseif(type_of_feeding==7)
      g_ini=10600;
    end;
    %SET UP FEEDING!!!
    %beginpoint=1+(i-1)*integration_iterates;
    %endpoint=beginpoint+integration_iterates;
    I(:,2) = feeding(integration_iterates, I_baseline, time_steps_per_hour, ...
                     starting_hour, time_of_meals, number_of_meals, type_of_feeding, food_decay_window_length, eating_decay_constant, lower_feeding_bound, upper_feeding_bound);
    I(:,1) = linspace(1,max(size(I(:,2))), max(size(I(:,2))));
    
    %[T,Y] = solver(odefun,tspan,y0,options)
    initial_condition=[pi_ini ri_ini g_ini i_delay_1_ini i_delay_2_ini i_delay_3_ini];
    integration_time=linspace(1,integration_iterates, integration_iterates);
    [T,X] = ode45(@glucose_insulin, integration_time, ...
                  initial_condition,options, I, P);
    %create and maintain the EHR
    beginpoint=1+(i-1)*integration_iterates;
    endpoint=beginpoint+integration_iterates-1;
    ehr(beginpoint:endpoint,1)=i;
    ehr(beginpoint:endpoint,2)=linspace(1,integration_iterates, integration_iterates);
    ehr(beginpoint:endpoint,3)=X(:,3);
    feeding_regiment(:, i)=I(:,2);
  end;
  
  %fig1=figure(1);
  %subplot(2,1,1);
  %title('feeding regiment')
  %plot(I(:,1), I(:,2));
  %subplot(2,1,2);
  %plot(X(:,3));
  %title('glucose');
  
  %fig2=figure(2);
  %plot(I(1:2880,1), I(1:2880,2));
  %xlabel('time in minutes', 'FontSize', 14);
  %ylabel('caloric intake', 'FontSize', 14);
  %saveas(fig2, 'periodic_feeding.pdf');
  
  %fig3=figure(3);
  %plot(I(1:2880,1), X(1:2880,3));
  %xlabel('time in minutes', 'FontSize', 14);
  %ylabel('glucose value', 'FontSize', 14);
  %saveas(fig3, 'periodic_feeding_glucose.pdf');
  
  %now let's dump the glucose out
  fid=fopen([execution_path, '/', num2str(which_bif_parameter), '.', num2str(parameter_count), '.glucose.data'], 'w+');
  fid_food=fopen([execution_path, '/',num2str(which_bif_parameter), '.', num2str(parameter_count), '.food.data'], 'w+');
  for(j=1:number_of_patients)
    b=(j-1)*integration_iterates;
    fprintf(fid_food, '%f \n', feeding_regiment(1, j));
    for(i=1:integration_iterates)
      %let's output every now 1 hour 120 minutes, or 2 hours
      if(mod(i,20)==1)
        fprintf(fid, '%f \t %f \t %f \n', ehr(i+b,1), ehr(i+b,2), ehr(i+b,3));
      end;
    end;
  end;
  fclose(fid);
  fclose(fid_food);
end;
  




