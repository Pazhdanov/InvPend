M=0.36; m=0.2; L=0.4; F_1=0.03; F_2=0.03; I=m*4*L^2/3; g=9.81;
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
X=transpose([pos, spd, angl, anglspd]);
f=-K*X;
