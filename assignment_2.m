%% TAV module
close all; clc; clear all; 
warning off

% Load tyre data (Pacejka model coefficients)
% File with the tyre data
WheelFile = 'Tyre215_50_19_Comb';      
% Wheel Initialization
pacn = [];
eval(['[Pacejka]=' WheelFile ';'])
pacn = struct2cell(Pacejka);
for ii = 1:size(pacn)
    Pace(ii) = pacn{ii};
end
Pacn = Pace';     % array containing the coefficients of Pacejka tyre model

%% Constants

velstart = 22; 
Rho = 0.27; % aerodynamic drag coefficient of car
Cx = 1;
Ir = 1.46; % Reasonable moment of inertia for wheel, weighing approximately 12kg
Af = 2.37; % Vehicle frontal area
f0 = 0.009; % Rolling resistance
f2 = 6.5*10^(-6); % Rolling resistance wheel to be multiplied by speed

b_f = 0.75; % Front break percentage
b_r = 1-b_f; % Rear break percentage

tau_b = 20*10^(-3); % Generation deadtime of the friction brakes [s]
rise_b = 25*10^(-3); % Rise time for friction brakes (time constant) [s]

R = 0.3488; % Wheel radius
bat_cap = 58; % Maximum battery capacity [kWh]
bat_per = 1; % Percentage charge of battery [0-1]

drivetrain_gain = 10.5;
peak_m_power = 150; % [kW]
peak_m_torque = 310; % [Nm] 
motor_eff = 0.9;
trans_eff = 0.95;

peak_regen = peak_m_torque*trans_eff/drivetrain_gain; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEFINE THIS!!!!! %%%%%%%%%%%



%% Vehicle dynamics constants
g = 9.81; % Gravity constant
L = 2.77; % Distance between front and rear wheels [m]
h = 0.55; % Height of mass centre from ground [m]
m = 1812; % Mass of car [kg]
a = 0.5*L;
b = 0.5*L;
alpha_slope = 0; % Slope of ground [rad]