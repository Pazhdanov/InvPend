newobjs = serialportlist;
% if newobjs ~= []
%     fclose(newobjs);
% end

serialPort = 'COM6';           % define COM port #
baudeRate = 9600;
commandsKeys = {'RESET', 'START_SENDING_DATA', 'STOP_EXPERIMENT', 'START_EXPERIMENT', 'CHANGE_DIR', 'UPDATE_PERIOD', 'STOP_MOTOR'};
commandsValues = [45, 50, 55, 60, 65, 70, 75];
commands = containers.Map(commandsKeys, commandsValues);
%after sending any commands there must be a small pause, like pause(0.02)

logFileName='pendulum.log';
logfid = fopen(logFileName, 'w+');

pause(2);
s = serialport(serialPort, baudeRate);

pause(1.5);
write(s, [commands('START_SENDING_DATA'), 0], "uint8");

experimentIsStarted = false;

M=0.36; m=0.2; L=0.4; F_1=0.03; F_2=0.03; I=m*L^2/3; g=9.81;
A=[0 1 0 0
   0 -(F_1*(L^2)*m+F_1*I)*(1/(M*(L^2)*m+I*M+I*m)) -g*(L^2)*(m^2)*(1/(M*(L^2)*m+I*M+I*m)) F_2*L*m*(1/(M*(L^2)*m+I*M+I*m))
   0 0 0 1
   0 F_1*L*m*(1/(M*(L^2)*m+I*M+I*m)) (M*g*L*m+g*L*m^2)/(M*L^2*m+I*M+I*m) (-F_2*M-F_2*m)*(1/(M*(L^2)*m+I*M+I*m))];
B=[0
   -(-L^2*m-I)*(1/(M*(L^2)*m+I*M+I*m))
   0
   -L*m*(1/(M*(L^2)*m+I*M+I*m))];
Q=[1 0 0 0
   0 1 0 0
   0 0 1 0
   0 0 0 1];
R=1;
[K,S,e]=lqr(A,B,Q,R);

write(s, [commands('STOP_EXPERIMENT'), 0], "uint8");

%write(s, [commands('START_EXPERIMENT'), 0], "uint8");

time_new=-1;
time_old=-1;

period = 50;
counter = 0;
%write(s, [commands('UPDATE_PERIOD'), period], "uint8");
while(1)
    data = read(s, 24, "uint8");
    convertedData = typecast( uint8(data) , 'single');
    if(~isempty(convertedData) && length(convertedData)== 6)
        time = convertedData(1);
        pos = convertedData(2); 
        spd = convertedData(3); 
        angl  = convertedData(4) * 57.32;
        anglspd  = convertedData(5) * 57.32;
        control = convertedData(6);
        
        time_new = convertedData(1);
        
        if(time_old==-1)
            time_old=convertedData(1);
        end
        
        write(s, [commands('UPDATE_PERIOD'), period], "uint8");
        
        if(pos <= -0.024 && pos >= -0.0255 && counter == 0)
            %write(s, [commands('STOP_MOTOR'), 0], "uint8");
            disp(sprintf('%f, %f', pos, period));
            write(s, [commands('UPDATE_PERIOD'), period], "uint8");
            write(s, [commands('CHANGE_DIR'), 1], "uint8");
            disp(sprintf('%f, %f', pos, period));
            %if(period == 255 && counter == 0)
            %    period = period - 5;
            %    counter = counter + 1;
            %end
            if(period == 20 && counter == 0)
                write(s, [commands('STOP_MOTOR'), 0], "uint8");
            end
            if(counter == 0 && period > 20)
                period = period - 10;
                counter = counter + 1;
            end
%             if(period == 0)
%                 write(s, [commands('STOP_MOTOR'), 0], "uint8"); 
%             end
             
            counter = counter + 1;
        end
        if(pos <= -0.03)
                write(s, [commands('UPDATE_PERIOD'), period], "uint8");
                write(s, [commands('CHANGE_DIR'), 1], "uint8");
                disp(sprintf('%f', pos));
                counter = 0;
        end
        if(pos >= -0.015)
                write(s, [commands('UPDATE_PERIOD'), period], "uint8");
                write(s, [commands('CHANGE_DIR'), 10], "uint8");
                disp(sprintf('%f', pos));
                counter = 0;
        end
        
        logstr = [num2str(time) ', ' num2str(pos) ', ' num2str(spd) ', ' num2str(angl) ', ' num2str(anglspd) ', ' num2str(control) newline];
        fwrite(logfid, logstr);
        
        %disp(sprintf('%f', pos));
        %disp(sprintf('Time: %f\tPos: %f\tSpd: %f\tAngle: %f\tAngle Speed: %f\tCtrl: %f\t\n', time, pos, spd, angl, anglspd, control));
    end
end