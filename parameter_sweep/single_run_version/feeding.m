%feeding function!
function I = feeding(integration_iterates, I_baseline, time_steps_per_hour, ...
                     starting_hour, time_of_meals, number_of_meals, ...
                     type_of_feeding, food_decay_window_length, ...
                     eating_decay_constant, lower_feeding_bound, upper_feeding_bound)
%%%%%%%%%%%%
number_of_hours=integration_iterates/time_steps_per_hour;
number_of_days=number_of_hours/24;
number_of_grid_points_per_day=time_steps_per_hour*24;
%right now, let's assume we can eat for an hour

%create the entire vector 
%food=zeros(time_steps_per_hour*integration_time,1);
food=zeros(integration_iterates,1);

if(type_of_feeding==1) %continous feeding
    food(1:number_of_days*number_of_grid_points_per_day)=I_baseline;
    I=food;
elseif(type_of_feeding==2) %square feeding function
    for(j=1:number_of_days)
        day_adjustment=(j-1)*number_of_grid_points_per_day;
        for(i=1:number_of_meals)
            food(time_steps_per_hour*time_of_meals(i)+day_adjustment:time_steps_per_hour*(time_of_meals(i)+1)+day_adjustment)=I_baseline;
        end;
    end;
    I=food;
    %time_human_units=linspace(1,integration_iterates, integration_iterates);
    %time_human_units=time_human_units/50;
elseif(type_of_feeding==3) %pulse feeding with decay
    %create eating profile
    eating_profile(:,1)=linspace(1,food_decay_window_length, food_decay_window_length);
    for(i=1:food_decay_window_length) 
        eating_profile(i,2)=(I_baseline*exp(1/eating_decay_constant))/exp(eating_profile(i,1)/eating_decay_constant); 
    end;
    
    for(j=1:number_of_days)
        day_adjustment=(j-1)*number_of_grid_points_per_day;
        for(i=1:number_of_meals)
            %food(time_steps_per_hour*time_of_meals(i)+day_adjustment:time_steps_per_hour*(time_of_meals(i)+1)+day_adjustment)=I_baseline;
            food(time_steps_per_hour*time_of_meals(i)+day_adjustment:time_steps_per_hour*time_of_meals(i)+day_adjustment+food_decay_window_length-1,1)=eating_profile(:,2);
        end;
    end;
    I=food;
elseif(type_of_feeding==4) %random levels of continous feeding
  food(1:number_of_days*number_of_grid_points_per_day)= ...
      randi([lower_feeding_bound upper_feeding_bound], 1);
  I=food;
elseif(type_of_feeding==5) % "rossler" type feeding

elseif(type_of_feeding==6) %random times, pulse with decay
  %create eating profile
    eating_profile(:,1)=linspace(1,food_decay_window_length, food_decay_window_length);
    for(i=1:food_decay_window_length) 
        eating_profile(i,2)=(I_baseline*exp(1/eating_decay_constant))/exp(eating_profile(i,1)/eating_decay_constant); 
    end;
    
    for(j=1:number_of_days)
        day_adjustment=(j-1)*number_of_grid_points_per_day;
        for(i=1:number_of_meals)
          time_of_meals_foo(i)=time_of_meals(i)+(rand(1)-0.5)*4;
          %the time +/- up to two hours
          %food(time_steps_per_hour*time_of_meals(i)+day_adjustment:time_steps_per_hour*(time_of_meals(i)+1)+day_adjustment)=I_baseline;
          food(time_steps_per_hour*time_of_meals_foo(i)+day_adjustment:time_steps_per_hour*time_of_meals_foo(i)+day_adjustment+food_decay_window_length-1,1)=eating_profile(:,2);
        end;
    end;
    I=food;
elseif(type_of_feeding==7) %random breakfast, retain time between
                           %meals, pulse with decay
  %create eating profile
    eating_profile(:,1)=linspace(1,food_decay_window_length, food_decay_window_length);
    for(i=1:food_decay_window_length) 
        eating_profile(i,2)=(I_baseline*exp(1/eating_decay_constant))/exp(eating_profile(i,1)/eating_decay_constant); 
    end;
    
    for(j=1:number_of_days)
        day_adjustment=(j-1)*number_of_grid_points_per_day;
        time_of_meals_foo(1)=time_of_meals(1)+(rand(1)-0.5)*4;
        time_of_meals_foo(2)=time_of_meals_foo(1)+4;
        time_of_meals_foo(3)=time_of_meals_foo(2)+6;
        for(i=1:number_of_meals)
          %the time +/- up to two hours
          %food(time_steps_per_hour*time_of_meals(i)+day_adjustment:time_steps_per_hour*(time_of_meals(i)+1)+day_adjustment)=I_baseline;
          food(time_steps_per_hour*time_of_meals_foo(i)+day_adjustment:time_steps_per_hour*time_of_meals_foo(i)+day_adjustment+food_decay_window_length-1,1)=eating_profile(:,2);
        end;
    end;
    I=food;
end;
    