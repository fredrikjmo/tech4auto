%% Setup and Initializations
close all; clc; clear all; 
warning('off');

%% Load Tyre Data
% Load Pacejka model coefficients for tyre data
WheelFile = 'Tyre215_50_19_Comb';
eval(['[Pacejka]=' WheelFile ';']);
Pacn = struct2cell(Pacejka);
for ii = 1:size(Pacn)
    Pace(ii) = Pacn{ii};
end
Pacn = Pace'; % array containing the coefficients of Pacejka tyre model

%% Constants for Vehicle Physical Parameters
velstart = 20;

m = 1812; % Mass of car [kg]
Rho = 0.27; % Aerodynamic drag coefficient of car
Cx = 1;
Af = 2.37; % Vehicle frontal area [m^2]
Ir = 1.46; % Moment of inertia for wheel, approx. 12kg [kg*m^2]
R = 0.3488; % Wheel radius [m]
f0 = 0.009; % Rolling resistance coefficient
f2 = 6.5*10^(-6); % Rolling resistance speed dependent factor
g = 9.81; % Acceleration due to gravity [m/s^2]
L = 2.77; % Wheelbase (distance between front and rear wheels) [m]
h = 0.55; % Height of center of mass from ground [m]
a = 0.5 * L;
b = 0.5 * L;
alpha_slope = 0; % Slope of ground [radians]



%% Brake System Parameters
b_f = 0.75; % Front brake percentage
b_r = 1 - b_f; % Rear brake percentage
tau_b = 20*10^(-3); % Brake system deadtime [s]
rise_b = 25*10^(-3); % Rise time for brakes [s]

%% Battery and Electrical System
bat_cap = 58000; % Battery capacity [Wh]
bat_per = 1; % Battery charge level [0-1]
bat_volt = 800; % Battery voltage [V]

%% Motor and Drivetrain Parameters
P_max = 150000; % Maximum power [W]
T_max = 310; % Maximum torque [Nm]
omega_max_rpm = 16000; % Maximum speed [rpm]
omega_max_rad = omega_max_rpm * (2 * pi / 60); % Convert RPM to rad/s

K_m = T_max / omega_max_rad; % Motor constant [Nm/A or V/(rad/s)]
K_b = K_m; % Back EMF constant [V/(rad/s)]
i_max = T_max / K_m; % Current at maximum torque [A]
E_max = K_b * omega_max_rad; % Back EMF at maximum speed [V]

drivetrain_gain = 10.5;
motor_eff = 0.9;
trans_eff = 0.95;
tors_stiff = 9000; % Torsional stiffness [Nm/rad]
tau_m = 50*10^(-3); % Motor time constant [s]
R_motor = 2.5;
L_motor = tau_m * R_motor;
J_motor = (2 * Ir * (1 / drivetrain_gain^2)); % Motor inertia