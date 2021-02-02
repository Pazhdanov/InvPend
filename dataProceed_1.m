clear
clc

fl = fopen('pendulum.log');

pos = [0 0];
spd = [0 0];
angl = [0 0];
anglspd = [0 0];
vecTime = [0];
control = [0 0];
vecPos = [0];
vecSpd = [0];
vecAngl = [0];
vecAnglSpd = [0];
vecAnglRad = [0];
vecAnglSpdRad = [0];
vecCoordinates = [0 0 0 0];
vecControl = [0];
vecPosK = [0];
vecSpdK = [0];
vecAnglK = [0];
vecAnglSpdK = [0];

line = fgets(fl);
while(line ~= -1)
    values = split(line, ',');
    time = str2num(values{1});
    vecTime = [vecTime; time];
    pos = [pos ; time str2num(values{2})];
    spd = [spd; time str2num(values{3})];
    angl = [angl; time str2num(values{4})];
    anglspd = [anglspd; time str2num(values{5})];
    control = [control; time str2num(values{6})];
    vecPos = [vecPos; str2num(values{2})];
    vecSpd = [vecSpd; str2num(values{3})];
    vecAnglRad = [vecAnglRad; (str2num(values{4}) * pi)/180];
    vecAnglSpdRad = [vecAnglSpdRad; (str2num(values{5}) * pi)/180];
    vecAngl = [vecAngl; str2num(values{4})];
    vecAnglSpd = [vecAnglSpd; str2num(values{5})];
    vecPosK = [vecPosK; str2num(values{2}) * 3.1623];
    vecSpdK = [vecSpdK; str2num(values{3}) * 97.6256];
    vecAnglK = [vecAnglK; ((str2num(values{4}) * pi)/180) * 213.0614];
    vecAnglSpdK = [vecAnglSpdK; ((str2num(values{5}) * pi)/180) * 44.5528];
    vecCoordinates = [vecCoordinates; str2num(values{2}) str2num(values{3}) str2num(values{4}) str2num(values{5})];
    vecControl = [vecControl; str2num(values{6})];
    
    line = fgets(fl);
end
i=1;
while(i<1128)
    if(vecAnglRad(i)<0)
        vecAnglRad(i)=abs(vecAnglRad(i))+2*(3.1415+vecAnglRad(i));
    end
    i=i+1;
end
i=1;
while(i<1128)
    if(angl(i,2)<0)
        angl(i,2)=abs(angl(i,2))+2*(180+angl(i,2));
    end
    i=i+1;
end

subplot(2,3,1), plot(pos(:, 1), pos(:, 2)), title('Pos m','FontSize',25), grid on;
subplot(2,3,2), plot(spd(:, 1), spd(:, 2)), title('Speed m/s','FontSize',25), grid on;
subplot(2,3,3), plot((angl(:, 1)), (angl(:,2))), title('AnglePos deg','FontSize',25), grid on;
subplot(2,3,4), plot((anglspd(:, 1)), (anglspd(:, 2))), title('AngularSpeed deg/s','FontSize',25), grid on;
subplot(2,3,5), plot(control(:, 1), control(:, 2)), title('Control miscrosec','FontSize',25), grid on;

clear fl
clear line
clear time
clear values
save('workspace')
savefig('newGraph.fig')