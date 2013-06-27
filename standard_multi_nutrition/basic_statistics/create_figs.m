clear all;
close all;

food_mean=load('food_by_hour_mean.data');
food_std=load('food_by_hour_std.data');
glucose_mean=load('glucose_by_hour_mean.data');
glucose_std=load('glucose_by_hour_std.data');

fig1=figure(1);
errorbar(food_mean, food_std);
xlabel('hour of the day', 'FontSize', 14);
ylabel('nomralized caloric intake', 'FontSize', 14);


fig2=figure(2);
hourly_glucose_plot=figure(2);
errorbar(glucose_mean, glucose_std);
xlabel('hour of the day', 'FontSize', 14);
ylabel('nomralized glucose value', 'FontSize', 14);

saveas(fig1, 'nicu_food.pdf');
saveas(fig2, 'nicu_glucose.pdf');
