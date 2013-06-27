%function submit_job_script_patient_multi_job();


for(i=10:10)
  addpath('./matlab_utilities');
  mkdir([pwd, '/', num2str(i)]);
  cd([pwd, '/', int2str(i)]);
  copyfile(['../glucose_model_bifurcation_sweep.m'], '.');
  copyfile(['../feeding.m'], '.');
  copyfile(['../glucose_insulin.m'], '.');
    
  root_path=pwd;
  addpath(root_path);

  %select and set the scheduler

  glucose_schd = findResource('scheduler','type','torque');

  %set the paths for where to run, home, where to execute, etc.

  %execution_path=root_path_slash;
  execution_path=root_path;
  home_directory=(pwd);
  
  %set the output directory
  set(glucose_schd, 'DataLocation', char(execution_path));
  set(glucose_schd, 'HasSharedFilesystem', true);
  set(glucose_schd, 'ClusterMatlabRoot', '\share\apps\matlab\');
  set(glucose_schd, 'SubmitArguments', '-l nodes=1,mem=1gb');
  
  %define a job
  
  glucose_jobs=createJob(glucose_schd);
    
  %now, you have to let the job know where the exacutables and such are
  %so you need to create a cell array of strings, 
  p={execution_path, [home_directory, '/matlab_utilities']};
  set(glucose_jobs, 'PathDependencies', p);

  %define the arguments sent to the function
  number_of_call_parameters=7;

  %define the call parameters
  which_bif_parameter=i;
  %bif_parameter_percent_variation=0.25;
  bif_parameter_percent_variation=2;
  number_of_bif_points=40;
  %integration_iterates=2880; %2 days worth of minutes
  integration_iterates=129600; %90 days worth of minutes
  time_steps_per_hour=60;
  
  %create the task
  
  createTask(glucose_jobs, @glucose_model_bifurcation_sweep, 0, {execution_path, home_directory, which_bif_parameter, bif_parameter_percent_variation, number_of_bif_points, integration_iterates, time_steps_per_hour}); 

  %submit the job
  
  fid=fopen([execution_path, '/', 'foo.txt'], 'a+');                                                                                   
  fprintf(fid, '%s \n', execution_path);                                                                          
  fclose(fid); 
  
  submit(glucose_jobs);
  
  cd('..');
  keep i;

end;


