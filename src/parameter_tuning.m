%% This file implements SA-based parameter tuning algorithm 
% One of the assumption that we make is that the parameters are not some 
% variables but constants. For instance in case of suspect signal Eii, the
% source block of Eii has parameter "1/Iei". Since the value of Iei is 
% 0.02, we replace the parameter of source block by 50 (i.e. 1/0.02).

%% Another imporant point is the way we generate the "newval" (v) using 
% the "val" (p.val). We can use various functions of our choice to 
% generate the newvalue using val. For instance, we can use stochastic 
% techniques i.e. P(newval|val). 

global newfile;
global Map1;

old_rob=0;
newrob=0;
max_rob=log(0);

index=1; %% most suspected signal

%global handle;
%global block;
 
%% SIMULATED ANNEALING  
iter=10;
optimal_rob=1;
alpha=0.8;
c=0;
old_rob=falsif_pb.obj_best; % storing the old robustness valueglobal old_rob;
% we accept alpha wih some probability
    
alpha_l=0.6;
alpha_r=1.1;
%for alpha = [0.8,1.1,0.9,0.5,0.4,1.5]
while alpha>0 && alpha<2
    %% below we mention the default parameter value
    %% identified the case of a specification
    %% NOTE- spec 13,14,15 are for regression testing
   %init_values;
   [status,data]=system(['python3 src_dst.py ' char(newfile) '.xml ' char(sind(index))]);
   data=parse_data(data);
   open_system(newfile);
   b = find_system(newfile,'Type','Block');  
    for i=1:length(b)
       prefix = strsplit(char(b(i)),'/');
       if length(prefix)>2
           continue;
       end

       if strcmp(prefix(2),data)
          %ph = get_param(b{i},'PortHandles');
          handle = get_param(b{i},'handle');
          block = get(handle);
       elseif length(data)==2 && strcmp(prefix(2),data(2))
           %ph = get_param(b{i},'PortHandles');
           handle = get_param(b{i},'handle');
           block = get(handle);
       end
       
    end
  
    
 if Map1(char(sind(index)))==1
       newval=get_param(handle,block.BlockType);
       newval=str2num(newval);
       disp("######## using prev iter val ######");
       disp(newval);
 else
     %% assigning the initial parameter values in the model 
     if modelno==1
         if sind(index)=="lin_speed"
           newval=6.28;
         elseif sind(index)=="Eii"
           newval=50;
         end
     elseif modelno==2
         newval=9.55;
     elseif modelno==3
         newval=12; 
     elseif modelno==4
         if sind(index)=="filt_rate"
           newval=100;
         elseif sind(index)=="brake_torque"
           newval=1;
         end
     elseif modelno==5
         newval=10;
     else
       disp("initialize param");
       %break;
     end
 end
  
   
   
 for k=1:iter
   total=c+k+1;
   disp("------------------ITERATION");
   disp(total);
   disp("----------------------------");
   [status,data]=system(['python3 src_dst.py ' char(newfile) '.xml ' char(sind(index))]);
   data=parse_data(data);
   open_system(newfile);
   b = find_system(newfile,'Type','Block');  
    for i=1:length(b)
       prefix = strsplit(char(b(i)),'/');
       if length(prefix)>2
           continue;
       end

       if strcmp(prefix(2),data)
          %ph = get_param(b{i},'PortHandles');
          handle = get_param(b{i},'handle');
          block = get(handle);
       elseif length(data)==2 && strcmp(prefix(2),data(2))
           %ph = get_param(b{i},'PortHandles');
           handle = get_param(b{i},'handle');
           block = get(handle);
       end
       
     end
  
       %val=block.(block.BlockType);
       %disp("current value");
       %disp(val);
       %val=str2num(val);
       %for i=1:5
       %newval=PS(val,x,y,z);
  
       newval=newval*alpha;
       disp("#####");
       disp(k);
       disp(newval);
       
       if block.BlockType=="Gain"
          set_param(handle,block.BlockType,num2str(newval));
       elseif block.BlockType=="TransferFcn"
          set_param(handle,'Numerator',num2str(newval));   
       else
           index=index+1;
           if Map1(char(sind(index)))==1
               newval=get_param(handle,block.BlockType);
               newval=str2num(newval);
               disp("######## using prev iter val ######");
               disp(newval);
           else
               %% assigning the initial parameter values in the model
               if modelno==1
                   if sind(index)=="lin_speed"
                       newval=6.28;
                   elseif sind(index)=="Eii"
                       newval=50;
                   end
               elseif modelno==2
                   newval=9.55;
               elseif modelno==3
                   newval=12;
               elseif modelno==4
                   if sind(index)=="filt_rate"
                       newval=100;
                   elseif sind(index)=="brake_torque"
                       newval=1;
                   end
               elseif modelno==5
                   newval=10;
               else
                   disp("initialize param");
                   %break;
               end
           end
           disp("trying index ="+index);
       end
       %return;
       save_system(newfile);
       close_system(newfile);
       disp("changing parameter to");
       disp(newval);
       
       if modelno==1
          init_autotrans;
       elseif modelno==2
          init_afc;
       elseif modelno==3
          init_narmamaglev;
       elseif modelno==4
          init_absbrake;
       elseif modelno==5
          init_helicopter;
       end
       %% checking whether the robustness has improved
       new_rob=falsif_pb.obj_best;
       disp(new_rob);
       if new_rob>max_rob
          max_rob=new_rob;
       end
       
       if falsif_pb.obj_best>=0
          disp("****************************************");
          disp(" the model is fixed in "+total+"iterations");
          disp(" the final value of the parameter is "+newval); 
          disp("*******************************************");
          return;
       end       
   end
   alpha_old=alpha;
   if alpha<1
     if max_rob>old_rob
       alpha=alpha_l;
       alpha_l=alpha_l-0.2;
     else
       alpha=alpha_r;    
       alpha_r=alpha_r+0.2;
     end
   else
      if max_rob>old_rob
       alpha=alpha_r;
       alpha_r=alpha_r+0.2;
     else
       alpha=alpha_l;
       alpha_l=alpha_l-0.2 
      end
   end
   c=c+10;
end
close_system(newfile);

function data=parse_data(data)
   data = erase(data,"[");
   data = erase(data,"]");
   data = split(data,", ");
   data = erase(data,"'");
   data=strip(data);
end

