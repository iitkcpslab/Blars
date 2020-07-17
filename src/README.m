%%% README file

This examples folder in the main directory consists of five base Simulink Models :
1. Autotrans_shift.slx
2. AbstractFuelControl_M11.slx
3. narmamaglev_v1.slx
4. absbrake.slx
5. helicopter.slx

As mentioned in the paper, we use our script "expand_subsystem.m" to 
flatten the above models. The flattening procedure is implemented in
expand_subsystem.m
 
 The flattened versions of above Simulink models are named as:
 1. newfile = 'Autotrans_shift_expanded';  
 2. newfile = 'AbstractFuelControl_expanded';
 3. newfile = 'narmamaglev_expanded';
 4. newfile = 'absbrake_expanded';
 5. newfile = 'helicopter_expanded';
 
 
 We define an initialization files for each of the model namely, 
 init_autotrans, init_afc, init_narmamaglev and init_helicopter. 
 These files contains the interfacing of the models with BREACH, input 
 generation for that model, specifications etc.
 
 Now, if we run any init file with one of the specification of the 
 corresponding model, we get a falsification.
 
 The bug localisation algorithm is implemented in the $bug_localisation_script.m$.
 It contains the implementation of all the algorithms mentioned in the paper.
 The script provides the results mentioned in the paper. 
 
 
The whole procedure is automated (except at some minor places).

Running the TOOL:
execute the script "main_script.m" and select the appropriate model no and 
spec no among the options displayed in the matlab terminal.
Refer modelno and specno from the paper.
NOTE- The main_script.m creates a new file with suffix "_expanded" for the
corresponding fixed model. This file is inside "repaired_models" folder.

Important Points ***
1. Need to annotate each signals in the Simulink model (or atleast those 
   which you need to be analysed. This is necessary as only then Simulink 
   can identify each signal uniquely.
2. The default value of a parameter is generally defined using a name. Instead 
   we need that instead default value is given directly. For instance in the
   parameter tuning script we have defined the default values of a parameter
   directly.
