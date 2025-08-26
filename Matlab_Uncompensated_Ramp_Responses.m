%% Program to design the Lead compensator for a given system 
% Consider a numerical from Advanced Control Theory, 
% G(s)=K/s^3-s^2+4 to satisfy the following specifications 
% (i) The phase  margin of the system =50 degrees, 
 
%% Design a Lead compensator for the given open-loop system such that the closed-loop system

close all
clear all
clc
%% Uncompensated control system transfer function (assuming H(s)=1)
num=[1];
den=[1 1 4 0];
G=tf(num,den);

 
%% Bode plot of the uncompensated system 
figure(1)
den=[1 1 4 0];
G=tf(num,den);
bode(G), grid on            % To check PM and GM of the uncompensated system 
title('Bode plot of uncompensated system')
[Gm,Pm,Wcg,Wcp] = margin(G);
 
%% Lead compensator Design
%(b) In the second design, consider placing the compensator zero at the real part of the desired poles.
Pmd=50;                       % Desired Phase Margin (PM)
Phi_m=Pmd-Pm+5;               % Maximum phase lead angle (degree)
% Check different values for the safety factor to get the desired PM
 
Phi_mr=Phi_m*(pi/180);        % Maximum phase lead angle (radian)
% Determine the transfer function of the lead compensator 
alpha=(1+sin(Phi_mr))/(1-sin(Phi_mr));
Mc=-10*log10(alpha);          % Magnitude to be compensated in db
 
% Locate the frequency in Figure(1) for Mc
wm=5.32;
p=wm*sqrt(alpha);             % Pole of lead compensator
z=p/alpha;                    % Zero of lead compensator
gain=alpha;
numc=[1 z];
denc=[1 p];
Gc=tf(numc,denc);
 
% Total forward transfer function of the compensated system
Gt=gain*Gc*G;
 
%% Comparison of compensated and uncompensated bode plots
figure(2)
bode(G,'--r', Gt,'-'), grid on
legend('Uncompensated system', 'Compensated system')
title('Comparison of compensated and uncompensated bode plots')
hold on;
%% Since H(s)=1, the feedback transfer function 
Gc1u=feedback(G,1);         % Closed loop TF of uncompensated system
Gclc=feedback(Gt,1);        % Closed loop TF of compensated system
 
% Comparison of compensated and uncompensated step responses
figure(3)
step(Gc1u, '--r', Gclc, '-'); grid on  
legend('Uncompensated system' , 'Compensated system')
title('Comparison of compensated and uncompensated step responses')
 
%% Comparison of compensated and uncompensated ramp responses
t=0:0.002:2;
figure(4)
[y1,z1]=step(1, [1 1 1 0],t);   % Take num and den coefficients of Gclu with a pole at origin
[y2,z2]=step([56.04 154.2], [1 11.28 66.32 154.2 0],t);
                                % Take num and den coefficients of Gclc with a pole at the origin
plot(t,y1,'.',t,y2,'-'), grid on
legend('Uncompensated system', 'Compensated system')
title('Comparison of compensated and uncompensated ramp responses')