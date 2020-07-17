%% Interface Anti-lock braking system model with Breach 
%   Initialization data for the SLDEMO_ABSBRAKE braking model.
%   Places model parameters in the MATLAB workspace when typed at the
%   command line 
%{
g = 32.18;
v0 = 88;
Rr = 15/12;  % Wheel radius
Kf = 1;
m = 50;
PBmax = 1500;
TB = 0.01;
I = 5;
%}

tic
newfile='absbrake_expanded';
%file='Autotrans_shift_annotated';
warning('off', 'Simulink:LoadSave:EncodingMismatch') %avoid warning encoding conflict windows vs iso
B = BreachSimulinkSystem(newfile);
toc
disp("time for interfacing");

global specno;
global mode;
global res_spec;

% define the formula1
STL_ReadFile('stl/absbrake_specs.stl');
if specno==4
   phi = phi_abs_all;
elseif specno==41
   phi = phi_stable; % this is phi1  TRY: 1(-1.9) -> 0.5(-1.31) -> 0.3(-0.40) ->0.2(Ok)
elseif specno==42
   phi = phi_slp;
end



% We create an input generator that will create different desired relative
% slip
tic
sg = var_step_signal_gen({'des_slip'}, 3);
B.SetInputGen(sg);

% We assign ranges for amplitude of input:
B.SetParamRanges({'des_slip_u0', 'des_slip_u1', 'des_slip_u2'}, ...
                  [0 0.3 ;0 0.3; 0 0.3]);
toc
disp("time for input generation");

tic 
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

toc
disp("Falsification time");
