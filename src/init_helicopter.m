%% Creating an interface for helicopter model with Breach 

%%
% Name of the Simulink model:
%tic
newfile = 'helicopter_expanded';
%% Analysis of a simple Simulink example (Example 2.5 from Lee and Seshia, Chapter 2)

%%
% Next, we define the parameters needed to run the model in the workspace.
% These parameters will be detected by Breach, and included in its 
% interface with the system. 
K = 10;
i = 0; 
a = 1;


%%
% By default, Breach will look for inputs, outputs and logged signals. 
% Breach interface will then allow to change parameters and constant 
% input signals, simulate the model and collect and observe the resulting 
% trace. 
B = BreachSimulinkSystem(newfile);
%toc
%disp("time for interfacing");


%tic
sg = var_step_signal_gen({'psi'},3);

B.SetInputGen(sg);                
%B.SetParam({'psi_dt0','psi_dt1','psi_dt2'},...
%                     [10;   10;  10 ]);
B.SetParam({'psi_u0','psi_u1','psi_u2'},...
                     [10;  10;  10 ]);

%toc
%disp("time for input generation");
%B.SetTime(0:.01:4);
STL_ReadFile('stl/specs.stl');
%%
% The value computed by solving the synthesis problem is store in x_best:
%tau_tight = 0.65;
tau_tight = 1;
% Weupdate the formula and plot its satisfaction:
global specno;
if specno==5
  phi = set_params(phi, 'tau', tau_tight);
end
falsif_params.names = {'a' ... ,
                      };
falsif_params.ranges = [0.5 1.5; ...
];

%% 
%tic
%% Falsification 
% We prepare a falsification problem.
falsif_pb = FalsificationProblem(B, phi,falsif_params.names,falsif_params.ranges);
falsif_pb.max_time = 180;

falsif_pb.solve();
if falsif_pb.obj_best>=0
    return;
end

%% falsif_pb.BrSet_False.P.traj{1}.X
%tr=falsif_pb.BrSet_False.P.traj{1}.X;
%plot(tr)
%Sim(B,10);
%plot(B.P.traj{1}.X)


