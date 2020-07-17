  %% This script implements the bug localisation algorithm
  %% mentioned in the paper.
   
    global modelno;
    global specno;
    tic
    initialize;
    disp("#############################");
    disp("time for falsification");
    toc
    
    tic
    % Extracting the variables from the falf object 
    if falsif_pb.obj_best>=0
        return;
    end
    BrFalse = falsif_pb.GetBrSet_False();
    BrFalse=BrFalse.BrSet;

    A={};
    for i=1:B.P.DimX
      A(i,:) = B.P.ParamList(i);
    end
    %figure;
    %BrFalse.PlotSignals(A);

    %figure;
    %BrFalse.PlotRobustSat(phi1);
    %% Algo 1 starts below
    %tic
    
%     if BrFalse.CheckSpec(phi)<0
%         out = STL_Break(phi,2);
%         out1 = out(1);
%         atom=0;
%         while length(out)>2
%             atom=1;
%             for i=1:length(out)-1
%                 if BrFalse.CheckSpec(out(i))<0
%                     out1=out(i);
%                     break;
%                 end
%             end
%             out = STL_Break(out1,2);
%         end
%     end
%     
     % impl new debug algo
    disp(phi);
    
    % the list of sub-specifications
    flag=0; %if unsat core exists then flag=1
    sub_spec=[];
    sphi=[];
    res_spec=phi;
    tphi = STL_Break(phi,2);
    while(length(tphi)>2)
      pphi = tphi(1);
      sub_spec=[sub_spec pphi];
      sphi = tphi(2);
      tphi = STL_Break(sphi,2);
    end
    sub_spec=[sub_spec sphi];
    
    
    % different comb of sub-specs
    for i=1: length(sub_spec)-1
       %disp("i = "+i); 
       comb_spec = nchoosek(sub_spec,i);
       for j=1:length(comb_spec)
         %disp("j = "+j);  
         jspec = joinspec(comb_spec(j,:));
         %disp(jspec)
         if BrFalse.CheckSpec(jspec)<0
            res_spec=jspec;
            flag=1;
            %disp("break");
            %disp(res_spec)
            %disp(BrFalse.CheckSpec(jspec))
            break;
         end
       end       
       if flag==1
           break;
       end
    end
    
    % if no minimal unsat core found
    if flag==0
      res_spec=phi;
    end
    
    %res_spec = STL_Break(res_spec,2);
    %res_spec = res_spec(1);
    %return;
    %last index
    %i=length(sub_spec);
    %comb_spec = nchoosek(sub_spec,i);
    %jspec = joinspec(comb_spec(1,:));
     
    %out2 = STL_Break(out(2),2);
    %out = STL_Break(res_spec,2);
    error = STL_ExtractSignals(res_spec);
    err1 = ' the suspect is';
    
    %disp(err1);
    disp(error);
    %toc
    %disp("time for Algo1");

     %% Algo 2 : slicing
     %tic
     slice=[];
     for i=1:length(error)
        %disp("  loop");
        %disp(i);
        [status,data]=system(['python3 XML_parser.py ' char(newfile) '.xml ' char(error(i))]);
        %data1=data;
        %pause(1);
        data = erase(data,"[");
        data = erase(data,"]");
        data = erase(data,"'");
        data = split(data,",");
        data=strip(data);
        %disp(data);
        slice = [slice; data];
        slice = [slice; error(i)];
        slice=slice(~cellfun('isempty',slice));
     end


    %slice1=slice; 
    slice=unique(slice);
    %disp("slice");
    %disp(slice);
    %toc
    %disp("time for algo2");
    delete 'BrFalse.csv';
    
    %% Algo3
    
    %tic
    figure;
        BrFalse.PlotSigPortrait(slice(1));
        h = findobj(gca,'Type','line');
        x = h.XData;
        y = h.YData;
        xlswrite('BrFalse',{transpose(x),transpose(y)});

   
    %signals = STL_ExtractSignals(phi); 
    %get_params(phi1);

    for i=2:length(slice)
            figure;
            BrFalse.PlotSigPortrait(slice(i));
            pause(0.1);
            h = findobj(gca,'Type','line');
            y = h.YData;
            %Step 1 - Read the file
            M = csvread('BrFalse.csv');
            % Step 2 - Add a column to the data
            M = [ M transpose(y)];
            % Step 3 - Save the file
            csvwrite('BrFalse.csv', M);
    end


    figure;
    BrFalse.PlotRobustSat(res_spec);
    h = findobj(gca);
    x = h(2).XData;
    y = h(2).YData;
    %xlswrite('BrFalse_Plot_Robust_Sat',{transpose(x),transpose(y)});

    %delete 'BrFalse_Robust_all.csv';
    delete 'BrFalse_Robust_neg.csv';
    disp(res_spec)
    %[p,val]=BrFalse.PlotRobustSat(phi);
    %index=length(p.props);
    %y=p.props_values(index).val;
    %x=p.props_values(index).tau;
    %len=length(p.traj{1}.time);
    %j=1;
    
    for j=1:length(x)
        if y(j)<0
          if j==length(x)  
            dlmwrite('BrFalse_Robust_neg.csv',{transpose(x(j)),transpose(y(j))},'delimiter',',','-append'); 
            break;
          end
          dlmwrite('BrFalse_Robust_neg.csv',{transpose(x(j)),transpose(y(j))},'delimiter',',','-append'); 
          if x(j+1)-x(j)>0.01
            for i=x(j)+0.01:0.01:x(j+1)-0.01
              dlmwrite('BrFalse_Robust_neg.csv',{transpose(i),transpose(y(j))},'delimiter',',','-append');
            end
          end
        end
    end

    
%     figure;
%     BrFalse.PlotRobustSat(res_spec);
%     
%    for j=1:len
%         if y(j)<0
%            if x(j)-x(j-1)>0.01
%               for i=x(j-1):0.01:x(j)-0.01
%                 dlmwrite('BrFalse_Robust_neg.csv',{transpose(i),transpose(y(j-1))},'delimiter',',','-append');
%               end
%               dlmwrite('BrFalse_Robust_neg.csv',{transpose(x(i)),transpose(y(i))},'delimiter',',','-append');
%             end
%         end
%         %dlmwrite('BrFalse_Robust_all.csv',{transpose(x(i)),transpose(y(i))},'delimiter',',','-append');
%     end
% 

    %below is the linux command for joining two csv files
    ! sort -t , -k 1,1 BrFalse.csv > sort1.csv
    ! sort -t , -k 1,1 BrFalse_Robust_neg.csv > sort2.csv
    ! join -t , -1 1 -2 1 sort1.csv sort2.csv > join.csv
  
    
    M = csvread('join.csv');
    %M=[slice;M];
   
    
    % Step 2 - Add a column to the data
    %min=Inf;
    col=length(slice)+2;
    [ m , n ] = size(M);
     %for i=1:m
     %    if M(i,col)<=min
             %min=M(i,col);
    %         E=M(i,:);
     %    end
     %end
     %disp('min robustness is');
     %disp(min);
     %disp('values at this point are');
     %slice{end+1} =  'rob';
     %disp('time');
     %disp(E(1));
     %for i=1:col-1
     %   disp(slice(i));
     %   disp(E(i+1));
     %end
     %toc
     %disp("time for algo3");

     close all; 

     %profile on;
     
     %% Algo 4
     %tic
     M(:,1)=[];
     N=M(:,1:end-1); % removing robustness column
     %N=M(:,1:end);
     %[status,data]=system(['python3 heatmap.py ' N]);
     %h = heatmap(cdata);
     tol=0.01;
     id=licols(N,tol);
     while length(id)==0
        tol=tol*10; 
        id=licols(N,tol);
     end
     
     %[C,ia,ib] = intersect(slice,B.P.ParamList(id), 'stable');
     disp("the suspected signals are");
     sind=slice(id);
     disp(slice(id));
     disp("#############################");
     disp("time for bug localisation");
     toc
     %[Y,id1]=lu_licols(N,0.01);
     %[W,id2]=svd_licols(N,0.01);
     %toc
     %disp("time to compute algo4");
     %plot(svd(N));
    %sind=bug_localisation(ans); 

    %function sind=bug_localisation(ans) 
    %   sind=ans;
    %end
    %% to delete ith column use a(:,i) = []; 
    % toc
    % disp("total time");
    %disp(length(B.P.ParamList));
    %disp(length(slice));
    %disp(length(sind));
    
    delete 'sort1.csv';
    delete 'sort2.csv'; 
    delete 'join.csv';
    delete 'BrFalse_Robust_neg.csv'; 
    delete 'BrFalse.csv'; 
    
 function idx=licols(X,tol)
%Extract a linearly independent set of columns of a given matrix X
     if ~nnz(X) %X has no non-zeros and hence no independent columns
         Xsub=[]; idx=[];
         return
     end
     if nargin<2, tol=1e-10; end
       [Q, R, E] = qr(X,0); 
       if ~isvector(R)
        diagr = abs(diag(R));
       else
        diagr = R(1);   
       end
       %Rank estimation
       r = find(diagr >= tol*0.1*diagr(1), 1, 'last');
       %r = find(diagr > 0, 1, 'last'); %rank estimation
       %idx=E(1);
       idx=E(1:r);
       %Xsub=X(:,idx);
 end
 
 
%lu decomposition
 function [Xsub,idx]=lu_licols(X,tol)
%Extract a linearly independent set of columns of a given matrix X
     if ~nnz(X) %X has no non-zeros and hence no independent columns
         Xsub=[]; idx=[];
         return
     end
     if nargin<2, tol=1e-10; end
       [Q,R] = lu(X);
       if ~isvector(R)
        diagr = abs(diag(R));
       else
        diagr = R(1);   
       end
       [diagr1,E]=sort(diagr,'descend');
       E=transpose(E);
       %Rank estimation
       r = find(diagr1 >= tol*diagr1(1), 1, 'last'); %rank estimation
       idx=sort(E(1:r));
       Xsub=X(:,idx);
 end
 
 %svd
  function [Xsub,idx]=svd_licols(X,tol)
%Extract a linearly independent set of columns of a given matrix X
     if ~nnz(X) %X has no non-zeros and hence no independent columns
         Xsub=[]; idx=[];
         return
     end
     if nargin<2, tol=1e-10; end
       [U,R,V] = svd(X,0);
       if ~isvector(R)
        diagr = abs(diag(R));
       else
        diagr = R(1);   
       end
       [diagr1,E]=sort(diagr,'descend');
       E=transpose(E);
       %Rank estimation
       r = find(diagr1 >= tol*diagr1(1), 1, 'last'); %rank estimation
       idx=sort(E(1:r));
       Xsub=X(:,idx);
  end
  
  function cspec=joinspec(phi)
       if length(phi)==1
          cspec=phi;
          return; 
       end
       sp = [disp(phi(1))];
       for j=2:length(phi)
           sp = [sp ' and ' disp(phi(j))];
       end
       cspec = STL_Formula('cspec',sp);
  end
  
 
 
