%% Interface Automatic Transmission model with Breach 

% Folder = cd;
% Folder = fullfile(Folder, '..');
% addpath Folder/examples;
%Autotrans_shift_vars;
%tic
newfile='Autotrans_shift_expanded';
%newfile='Autotrans_shift_expanded';
B = BreachSimulinkSystem(newfile);
%toc
%disp("time for interfacing");

%define the formula
STL_ReadFile('stl/Autotrans_spec.stl');
global specno;
global mode;
global res_spec;


%% To select one of the specifications, uncomment the one of the below 
%% three phi's. 


if specno==1
    phi = phi_join_all;
elseif specno==11
   phi = speed_bnded; % this is phi1  TRY: .02 -> .03 -> .05 -> .1 -> .2 -> .5 -> .7(FIX)
elseif specno==12
   phi = RPM_bnded;
elseif specno==13
   phi = never_gear3_and_speed_low; %this is phi2  TRY: Rw=1 -> (2X) ->(0.8X) -> (0.5X)  -> 0.33 (FIX) - > 0.16(FIX)
elseif specno==14
   phi = phi_vmax;  % this is phi3  TRY: Iei=0.02 - >(0.01 X)-> 0.03 -> 0.1 -> 1 -> 5(FIX) ->10(FIX)
elseif specno==15
   phi = phi_vmin;
elseif specno==16
   phi = phi_21;
elseif specno==17
   phi = phi_100;
end
%phi = phi_join  %joining phi1 and phi2  FIX: same as phi3

%% Note: If you want to check the repair file for spec phi1, then 
%% simply prefix the newfile variable (line4) with "phi1_" i.e for phi1 spec
%% and Autotrans_shift_expanded model the newfile should be 
%% newfile='phi1_Autotrans_shift_expanded';


%% Running one simulation
%B.SetTime(0:.01:30); 
%B.SetParam({'throttle_u0'}, 100);
%B.Sim();
%B.PlotSignals({'throttle', 'RPM', 'speed', 'gear'});

%% Describes complex driving scenarios 
% We create an input generator that will alternates between acceleration and braking 
%tic
sg = var_step_signal_gen({'throttle', 'brake'}, 5);
B.SetInputGen(sg);

% We assign ranges for duration and amplitude of each input:
B.SetParamRanges({'dt_u0', 'dt_u1', 'dt_u2', 'dt_u3'}, ...
                  [.1 10  ;  .1 10;    0.1 10;    0.1 10]);
B.SetParamRanges({'throttle_u0','brake_u1', 'throttle_u2', 'brake_u3'}, ... 
                  [0 100;        0 325;      0 100;         0 325]);
%toc
%disp("time for input generation");

%tic i
if mode==1 % falsification mode
   falsif_pb = FalsificationProblem(B, phi);
else
   falsif_pb = FalsificationProblem(B, res_spec);
end
falsif_pb.max_time = 180;
falsif_pb.solve();

if falsif_pb.obj_best>=0
    return;
end

%toc
%disp("Falsification time");
%close all;
