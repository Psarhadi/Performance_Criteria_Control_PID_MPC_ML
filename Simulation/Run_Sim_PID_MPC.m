clear all, close all, clc

% Switch the controller in Simulink to PID or MPC
% Load MPCs from here: mpc4 is MPC1 and MPC5 is MPC2 (constrained)
load mpc4.mat % Linear: sysd, Ny=120, Nu=1, W=1,0.1
load mpc5.mat % Constrained like above, Sat = 20, RSat = 30

% Simulation parameters
Sim_time = 10;
dt = 0.01;

Set_Amp = 1; %Setpoint amplitude 1 or 20

% System parameters
Sat = inf; % inf or 20
RSat = inf; % inf or 30

% Uncertaities
Ktest = 1; % Gain margin test
Dtest = 0; % Delay margin test
num_u = 1;225; % Rohrs 229;
den_u = 1;[1 12 225]; % Rohrs [1 30 229];
dist_amp = 2;
noise_var = 0.0025;

% PID 
Kp = 6; % C1: 6 and C2: 2
Ki = 0.0;
Kd = 4;
Kaw = 0; % 4 only for C6

% AUV 3 state
% Define the system
% System state derivatives
% State vector: x = [v; r; psi] 
% Output y = [psi]
% A = [-2.72, -0.43, 0; 
%      -3.38, -2.51, 0; 
%      0, 1, 0];
% B = [0.24; 
%      -1.82; 
%      0];
% C = [0, 0, 1]; 
%%%%%%%%%%%%%

num = [1.816 5.737];
den = [1 5.235 5.375 0];
sys = tf(num, den);

% Discretize the system
sys_d = c2d(sys, dt);

% Extract state-space matrices
[A, B, C, D] = ssdata(ss(sys_d));

% Open and simulate the system
open('Sim_Test_PID_MPC');
sim('Sim_Test_PID_MPC');

%fetching data
time = ans.tout;
r = ans.r;
y = ans.y;
e = ans.e;
u_c = ans.u_c;
u_ac = ans.u_ac;
n = ans.n;


% plot setpoint and output
figure,
subplot(211)
plot(time,r,'r--',time,y,'k','linewidth',1.5)
ylabel('Output')
legend('r','y')

subplot(212)
plot(time,u_c,'r--',time,u_ac,'k','linewidth',1.5)
set(gca,'TickLabelInterpreter','latex','fontsize',10)
ylabel('Control Signal')
legend('u_c','u_ac')

% Steady state error
e_ss = e(end);

% integral of error
ine_e = sum(e)

% Integral of the square error
ISE = sum((e).^2)/Sim_time

% Integral of the time multiplied by absolute error
ITAE = sum(time.*abs(e))/Sim_time

% Control effort
IACE = sum(abs(u_c))/Sim_time

% Control rate effort
IACER = sum(abs(diff(u_c)/dt))/Sim_time

% Max control
uc_max = max(u_ac);


% saving analysis criteria
fid = fopen('Criteria.txt','wt');
fprintf(fid,'%.2f\n',e_ss,ISE,ITAE,IACE,IACER,uc_max);
fclose(fid);

% saving simulation results
fid = fopen('PID1.txt','wt');
fprintf(fid,'%.4f %.4f %.4f %.4f %.4f %.4f\n', [time, r, y, e, u_c, u_ac]');
fclose(fid);