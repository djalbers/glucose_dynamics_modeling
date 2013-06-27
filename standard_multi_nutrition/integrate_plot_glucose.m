%this script runs the standard sturgis model. parameters are below
%and are largely self explanitory. 

clear all;
close all;

%translating the time to the sturis paper
% at I=216, we have 109 matlab iterates per period
% 110.8 minutes per period
% so, among friends, we will say, that 109 matlab iterates = 109 minutes
% so, that means one iterate per minute
% 1440 minutes per day
% about 6 periods per day
% so, 3 weeks of data: 30240
% 1 week of data: 10080

%set the nutrition scheme:
%the choices include: 1 - continous feeding, 2 - square feeding
%function, 3 - pulse feeding with decay, 4 - random levels of
%continous feeding (for a population), 6 - noisy but structured
%(three meals a day near 8 am, 12 pm and 6 pm) mealtimes, pulse
%with decay, 7 - random breakfast, then retain structured time
%between meals, pulse with decay, 8 - random meal times, pulse with
%decay, 9 - random breakfast, retain time between meals, pulse with
%decay, differing feeding rates (for the population)
type_of_feeding=6;

%set the number of different patients you want to create
number_of_patients=40;
lower_feeding_bound=100;
upper_feeding_bound=225;

% requires defs for the feeding function
%integration_iterates=30240; %3 weeks of minutes
%integration_iterates=1314000; %2.5 years worth of data output every 6 hours
integration_iterates=12960; %9 days worth of minutes
I_baseline=216;
time_steps_per_hour=60;
starting_hour=0; %the day goes from 0-23 hours
number_of_meals=3;
time_of_meals=[8 12 18]; %only relevant for feeding type 4
food_decay_window_length=120; %food decays within 2 hours
eating_decay_constant=30;

%set the options for the
abstol=1e-4;
reltol=1e-4;
options = odeset('RelTol', reltol,'AbsTol',[abstol abstol abstol abstol abstol abstol]);
%here we jusst set the relative tolerance and the absolute tolerance for
%the solver...

%parameters --- as were perscribed in strugis et al
pi_ini=200; %plasma insulin mU
ri_ini=200; %remote insulin mU
%g_ini=12000; %glucose
i_delay_1_ini=0.1;
i_delay_2_ini=0.2;
i_delay_3_ini=0.1;

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
  elseif(type_of_feeding==8)
    g_ini=10600;
  elseif(type_of_feeding==9)
    g_ini=10600;
  end;
  %SET UP FEEDING!!!
   
  I(:,2) = feeding(integration_iterates, I_baseline, time_steps_per_hour, starting_hour, time_of_meals, number_of_meals, type_of_feeding, food_decay_window_length, eating_decay_constant, lower_feeding_bound, upper_feeding_bound);
  I(:,1) = linspace(1,max(size(I(:,2))), max(size(I(:,2))));
  
  %[T,Y] = solver(odefun,tspan,y0,options)
  initial_condition=[pi_ini ri_ini g_ini i_delay_1_ini i_delay_2_ini i_delay_3_ini];
  integration_time=linspace(1,integration_iterates, integration_iterates);
  [T,X] = ode45(@glucose_insulin, integration_time, initial_condition,options, I);
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
fid=fopen('artifical_patient_glucose.data', 'w+');
fid_food=fopen('food.data', 'w+');
for(j=1:number_of_patients)
  b=(j-1)*integration_iterates;
  fprintf(fid_food, '%f \n', feeding_regiment(1, j));
  for(i=1:integration_iterates)
    %let's output every 360 minutes, or 6 hours
    if(mod(i,30)==1)
      fprintf(fid, '%f \t %f \t %f \n', ehr(i+b,1), ehr(i+b,2), ehr(i+b,3));
    end;
  end;
end;
fclose(fid);
fclose(fid_food);






