    
    %movefile('BrFalse.csv','logs');
    %movefile('BrFalse_Robust_neg.csv','logs');
    %movefile('join.csv','logs');
    %movefile(strcat(file,'.xml'),'models')
    %movefile(strcat(newfile,'.xml'),'repair');
    delete '*.xml';
    delete '*.dot';
    delete(strcat(file,'.slx'));
    movefile(strcat(newfile,'.slx'),'../repaired_models');
    movefile(strcat(newfile,'_params.mat'),'../repaired_models');
    delete '*.out';
    delete '*.mexa64';
    %movefile('mylog.out','logs');
