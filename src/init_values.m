   global model no;
   global index;
   global newval;
   global newfile;
   global handle;
   global Map1;
   global sind;
   %M = containers.Map('KeyType','char','ValueType','double');
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
  
   
   if modelno==1
       if sind(index)=="lin_speed"
         if Map1('lin_speed')==0  
           newval=6.28;
           %Map1('lin_speed')=1;
         else
           newval=get_param(handle,block.BlockType);
           newval=str2num(newval);
           disp("######## using prev iter val ######");
           disp(newval);
         end
       elseif sind(index)=="Eii"
         if Map1('Eii')==0
           newval=50;
         else
           newval=get_param(handle,block.BlockType);
           newval=str2num(newval);
           disp("######## using prev iter val ######");
           disp(newval);
         end
       else
          disp("initialize param");
       end
   end
   
   if modelno==2
       if sind(index)=="l13"
          newval=9.55;
       end
   end
   if modelno==3
       newval=12; 
   elseif modelno==4 
       newval=1;
   elseif specno==20
       newval=100;
   elseif modelno==5
       newval=10;
   else
       disp("initialize param");
       %break;
   end
   
