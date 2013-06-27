clear all;
close all;

data=load('artifical_patient_glucose.data');


%NOTE, before you can use the data, you need to adjust the start times of
%these suckers!!!!!

%data(:,4)=load('food.data');
if(min(size(data))==3) %food data was not recorded so we'll use
                       %random numbers as a place holder
  foo=max(size(data));
  data(:,4)=rand(foo,1);
  no_food=1;
else
  no_food=0;
end;
  
clear foo;
foo=diff(data(:,1));
chpts=find(foo(:,1)>0);
%note that chpts(i) is the LAST point for the i'th patient

num_patients=max(size(chpts))+1;

num_measurements(1,1)=chpts(1);
for(i=2:num_patients-1)
    num_measurements(i,1)=chpts(i)-chpts(i-1);
end;
num_measurements(num_patients,1)=max(size(data(:,3)))-chpts(num_patients-1);

begin_pt=1;
end_pt=chpts(1);
for(i=1:(num_patients-2))
  
  mean_glucose(i)=mean(data(begin_pt:end_pt, 3));
  std_glucose(i)=std(data(begin_pt:end_pt, 3));
  data_normalized_glucose(1:num_measurements(i),i)=(data(begin_pt:end_pt, 3)-mean_glucose(i))/std_glucose(i);  
  glucose(1:num_measurements(i),i)=(data(begin_pt:end_pt, 3)-mean_glucose(i))/std_glucose(i);
  
  mean_food(i)=mean(data(begin_pt:end_pt, 4));
  std_food(i)=std(data(begin_pt:end_pt, 4));
  %note, one of the patient's food regiment doesn't change!
  if(std_food(i)==0)
    data_normalized_food(1:num_measurements(i),i)=(data(begin_pt:end_pt, 4)-mean_food(i));  
  else
    data_normalized_food(1:num_measurements(i),i)=(data(begin_pt:end_pt, 4)-mean_food(i))/std_food(i);  
  end;
  food(1:num_measurements(i),i)=data(begin_pt:end_pt, 4);
  mean_diff_food(i)=mean(diff(data(begin_pt:end_pt, 4)));
  
  time(1:num_measurements(i),i)=data(begin_pt:end_pt, 2);
  
  %data_normalized_glucose(1:num_measurements(i),i)=(data(begin_pt:end_pt, 3));%-mean_glucose(i))/std_glucose(i); 
  begin_pt=chpts(i)+1;
  end_pt=chpts(i+1);
    
end;

%do the last 2 patients
i=num_patients-1;
begin_pt=chpts(i-1)+1;
end_pt=chpts(i);
mean_glucose(i)=mean(data(begin_pt:end_pt, 3));
std_glucose(i)=std(data(begin_pt:end_pt, 3));
data_normalized_glucose(1:num_measurements(i),i)=(data(begin_pt:end_pt, 3)-mean_glucose(i))/std_glucose(i);  
glucose(1:num_measurements(i),i)=(data(begin_pt:end_pt, 3)-mean_glucose(i))/std_glucose(i);
  
mean_food(i)=mean(data(begin_pt:end_pt, 4));
std_food(i)=std(data(begin_pt:end_pt, 4));
data_normalized_food(1:num_measurements(i),i)=(data(begin_pt:end_pt, 4)-mean_food(i))/std_food(i);  
food(1:num_measurements(i),i)=data(begin_pt:end_pt, 4);
mean_diff_food(i)=mean(diff(data(begin_pt:end_pt, 4)));
  
time(1:num_measurements(i),i)=data(begin_pt:end_pt, 2);

i=num_patients;
begin_pt=chpts(i-1)+1;
end_pt=max(size(data(:,3)));
mean_glucose(i)=mean(data(begin_pt:end_pt, 3));
std_glucose(i)=std(data(begin_pt:end_pt, 3));
data_normalized_glucose(1:num_measurements(i),i)=(data(begin_pt:end_pt, 3)-mean_glucose(i))/std_glucose(i);  
glucose(1:num_measurements(i),i)=(data(begin_pt:end_pt, 3)-mean_glucose(i))/std_glucose(i);
  
mean_food(i)=mean(data(begin_pt:end_pt, 4));
std_food(i)=std(data(begin_pt:end_pt, 4));
data_normalized_food(1:num_measurements(i),i)=(data(begin_pt:end_pt, 4)-mean_food(i))/std_food(i);  
food(1:num_measurements(i),i)=data(begin_pt:end_pt, 4);
mean_diff_food(i)=mean(diff(data(begin_pt:end_pt, 4)));
  
time(1:num_measurements(i),i)=data(begin_pt:end_pt, 2);

%check to see if the glucose is mean zero
for(i=1:num_patients) 
  check(i)=mean(glucose(:,i)); 
end;
gotta_be_close_to_zero=sum(check);

%let's make the 24 hour plots!

%86400 seconds in a day
%secs_day=86400;
min_day=1440; %this is actually the number of minutes in a day,
               %but hat is how we are going...
food_normalized_by_time_of_day(1,24)=0;
glucose_normalized_by_time_of_day(1,24)=0;
for(i=1:num_patients)
    for(j=1:num_measurements(i))
        %secs_in_day=mod(time(j,i),secs_day); % this gives you the
                                             % seconds during the
                                             % day...
        min_in_day=mod(time(j,i),min_day);%number of minutes in a day
        %hour_of_day=floor(secs_in_day/(60*60))+1;
        hour_of_day=floor(min_in_day/60)+1;
        
        %food!!!
        if(food_normalized_by_time_of_day(1,hour_of_day)==0)
            k=0;
        else
            k=max(size(food_normalized_by_time_of_day(:,hour_of_day)));
        end;
        food_normalized_by_time_of_day(k+1,hour_of_day)=data_normalized_food(j,i); 
        
        %glucose!!!!
        if(glucose_normalized_by_time_of_day(1,hour_of_day)==0)
            k=0;
        else
            k=max(size(glucose_normalized_by_time_of_day(:,hour_of_day)));
        end;
        glucose_normalized_by_time_of_day(k+1,hour_of_day)=data_normalized_glucose(j,i); 
        
    end;
end;

if(no_food==0)

  clear foo;
  for(i=1:24)
    foo=find(food_normalized_by_time_of_day(:,i)>0);
    global_m_per_hour(i)=max(size(foo));
    for(j=1:global_m_per_hour(i))
      food_per_time_of_day(j,i)=food_normalized_by_time_of_day(foo(j),i);
    end;
    food_by_hour_mean(i)=mean(food_per_time_of_day(1:global_m_per_hour(i),i));
    food_by_hour_std(i)=std(food_per_time_of_day(1:global_m_per_hour(i),i));
  end;
  
end;

%this creates!!??
clear foo;
for(i=1:24)
    %foo=find(glucose_normalized_by_time_of_day(:,i)>0);
    foo=find(glucose_normalized_by_time_of_day(:,i)~=0);
    global_m_per_hour(i)=max(size(foo));
    for(j=1:global_m_per_hour(i))
        glucose_per_time_of_day(j,i)=glucose_normalized_by_time_of_day(foo(j),i);
    end;
    glucose_by_hour_mean(i)=mean(glucose_per_time_of_day(1:global_m_per_hour(i),i));
    glucose_by_hour_std(i)=std(glucose_per_time_of_day(1:global_m_per_hour(i),i));
end;

if(no_food==0)
  food_plot=figure(1);
  for(i=1:num_patients-2)
    semilogy(food(1:num_measurements(i),i));
    hold all;
  end;

  hourly_food_plot=figure(2);
  errorbar(food_by_hour_mean, food_by_hour_std);
end;

hourly_glucose_plot=figure(2);
errorbar(glucose_by_hour_mean, glucose_by_hour_std);

fid=fopen('glucose_by_hour_mean.data', 'w+');
fprintf(fid, '%d \n', glucose_by_hour_mean);
fclose(fid);
fid=fopen('glucose_by_hour_std.data', 'w+');
fprintf(fid, '%d \n', glucose_by_hour_std);
fclose(fid);

if(no_food==0)
  fid=fopen('food_by_hour_mean.data', 'w+');
  fprintf(fid, '%d \n', food_by_hour_mean);
  fclose(fid);
  fid=fopen('food_by_hour_std.data', 'w+');
  fprintf(fid, '%d \n', food_by_hour_std);
  fclose(fid);
end;



