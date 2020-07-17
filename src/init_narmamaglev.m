%% Interface of Neural-Network based controller model with Breach 
 
InitBreach;
%narmamaglev_v1;

%% Model and inputs
u_ts = 0.001;

%tic
newfile = 'narmamaglev_expanded';
B = BreachSimulinkSystem(newfile); 
%toc
%disp("time for interfacing");
B.SetTime(0:.01:20);
global specno;
global mode;
global res_spec;
%% Checking specifications
STL_ReadFile('stl/NNspecs.stl');

if specno==3
   phi=phi_NN_all; % this is phi2 
elseif specno==31
   phi=alw_reach_ref_in_tau;   % this is phi1 15 -> 10 ->8 -> 5 ->3 ->2(ok) , 1(ok) Use both rob and time of falf
elseif specno==32
   phi=never_far_ref; 
end



%% Test with piecewise constant inputs  
u_min = 1;
u_max = 3;

%tic
sg = var_step_signal_gen({'Ref'},3);
B.SetInputGen(sg);
%B.SetInputGen('UniStep3');
B.SetParamRanges({'Ref_u0','Ref_u1','Ref_u2'}, [u_min u_max; u_min u_max; u_min u_max]);
%toc
%disp("time for input generation");

%tic
if mode==1 % falsification mode
   falsif_pb = FalsificationProblem(B, phi);
else
   falsif_pb = FalsificationProblem(B, res_spec);
end
falsif_pb.max_time= 50; falsif_pb.solve();

if falsif_pb.obj_best>=0
    return;
end
%toc
%disp("Falsification time");
