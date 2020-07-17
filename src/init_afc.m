%% Interface Abstract Fuel Control model with Breach 

%InitBreach;
fuel_inj_tol = 1.0; 
MAF_sensor_tol = 1.0;
AF_sensor_tol = 1.0; 
pump_tol = 1;
kappa_tol=1; 
tau_ww_tol=1;
fault_time=50;
kp = 0.04;
ki = 0.14;

global specno;
global mode;
global res_spec;
%tic
% newfile = 'AbstractFuelControl_expanded';
%if specno==5 || specno==7
%   newfile = 'AbstractFuelControl_function_expanded';
%else
    newfile = 'AbstractFuelControl_expanded';
%end
%newfile = 'AbstractFuelControl_M11'; 
B = BreachSimulinkSystem(newfile);
%toc
%disp("time for interfacing");

STL_ReadFile('stl/AFC_simple_spec.stl');
%STL_ReadFile('stl/AFC_settling_spec.stl');

if specno==2
    phi=phi_all_afc;
elseif specno==21
   phi=AF_alw_ok; % this is phi4  TRY: f3: .10->.08->.05
elseif specno==22
   phi=AF_overshoot_req; %this is phi2 good example to show how we move in direction of robustness TRY: f3: .10->.08->.05
elseif specno==23
   phi=AF_ok_controller; %this is phi1   TRY:9.55 -> (10 X) ->(9 OK) -> (8 FIX)
elseif specno==24
    phi=AF_alw_settle;
end
%}

%B = BrAFC.copy();
%tic
sg = var_step_signal_gen({'speed','throttle'},3);
B.SetInputGen(sg); 

B.SetParam({'throttle_dt0', 'throttle_dt1', 'throttle_dt2'}, ...
                  [10; 10;  10]);
B.SetParam({'speed_dt0','speed_dt1','speed_dt2'}, ...
                  [ 10;  10;  10]);
B.SetParamRanges({'speed_u0','speed_u1','speed_u2'}, ... 
                  [ 900 1100; 900 1100; 900 1100]);
B.SetParamRanges({'throttle_u0','throttle_u1','throttle_u2'},...
                    [0 50;  0 50; 0 50]);                
%toc
%disp("time for input generation");  

%tic
%% Falsify property
if mode==1 % falsification mode
   falsif_pb = FalsificationProblem(B, phi);
else
   falsif_pb = FalsificationProblem(B, res_spec);
end
%falsif_pb = FalsificationProblem(B, phi);
falsif_pb.max_time = 180;
falsif_pb.solve();
if falsif_pb.obj_best>=0
    return;
end
%toc
%disp("Falsification time");

