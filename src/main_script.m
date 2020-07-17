%% main script for the ToolBox
%% run it and select the modelno and specno

delete last_run.log;
clear all;
close all;

diary last_run.log;
setenv PYTHON 'LD_LIBRARY_PATH="" python3';
%%export LD_PRELOAD=/lib/x86_64-linux-gnu/libexpat.so.1
addpath models;

disp("*************************");
disp("select 1 for Automatic transmission");
disp("select 2 for Abstract furl control");
disp("select 3 for Neural Network based maglev");
disp("select 4 for Anti Lock braking system");
disp("select 5 for helicopter")
disp("*******************************");

modelno=input('enter the model number'); % select model number
specno=input('enter the specification number');  % select spec no

disp("---------------------------------------");
disp("selected model is"+modelno);
disp("---------------------------------------");

disp("--------------------------------------");
disp("selected specification is phi"+specno);
disp("---------------------------------------");

fixed=0;
tic
expand_subsystem; % flattening script
disp("#############################");
disp("time for flattening");
toc
%global Map1;
%keySet = {'lin_speed','Eii'};
%valueSet = [0 0];
%Map1 = containers.Map(keySet,valueSet);
Map1 = containers.Map;

warning off;
mode=1; % falsification mode
while fixed==0    
  bug_localisation;  % bug localisation script
  %return;
  if length(Map1) == 0
      for i=1:length(slice)
          Map1(char(slice(i)))=0;
      end
  end
  mode=2; % repair mode
  tic
  if falsif_pb.obj_best>=0
    disp("****************************************");
    disp(" NO FALSIFICATION ");
    disp("*******************************************");
    return;
  end
  parameter_tuning;
  Map1(char(sind(index)))=1;
  disp("#############################");
  disp("time for model repair");
  toc
  mode=1; % falsification mode
  initialize;
  if falsif_pb.obj_best>=0
    disp("fixed model");
    fixed=1;
    cleanup;
    return;
  else
    disp("fixing next sub");
  end
  disp("----------------------------------------");
  disp("----FIXING ANOTHER SUBSPEC---------");
end

diary off;