    % init script
    global modelno;
    global specno;
    
    if modelno==1
       init_autotrans;
       %disp("selected model is Autotrans");
    elseif modelno==2
       init_afc;
       %disp("selected model is fuel control");
    elseif modelno==3
       init_narmamaglev;
       %disp("selected model is Neural Network based Maglev");
    elseif modelno==4
       init_absbrake;
       %disp("selected model is Antilock braking system");
    elseif modelno==5
       init_helicopter;
       %disp("selected model is helicopter");
    else
        disp("wrong model selected");
    end