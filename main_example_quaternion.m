%-------------------------------------------------------------------------%
clear all % refresh workspace
close all % close all open object
clc       % clear command window screen
mystartup;% set different required path for Grape Code
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
NDmax   = 1e2+1;
NSmax   = 11;
Smax    = 1/3;
bound   = 1e4*2*pi;
Dmax    = 1e4*2*pi/bound;
Tmax    = 200e-6*bound;
scale   = linspace(-Smax,Smax,NSmax) + 1;
offset  = linspace(-Dmax,Dmax,NDmax);
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
% common option
opt     = fun_set_grape('Constraint','@fun_constr_1rf_2component_max_amp',...
                        'Dynamics','@fun_quaternion',...
                        'Gradient','exact');
% opt     = fun_set_grape();
opt.N   = 100;
opt.dt  = Tmax/opt.N;
opt.amp = 1;
X0      = [1 0 0 0]; % quaternion identity
% example of pi_x rotation :
chi     = pi; % rotation angle of the tranformation
theta   = pi/2; % azimutal angle of the principal axis of rotation
phi     = 0; % polar angle of the principal axis of rotation
Xf      = [cos(chi/2) sin(chi/2)*[sin(theta)*[cos(phi) sin(phi)] cos(theta)]];
opt.x0  = repmat(X0,NDmax*NSmax,1)/sqrt(NDmax*NSmax);
opt.xf  = repmat(Xf,NDmax*NSmax,1)/sqrt(NDmax*NSmax);
opt.xf  = opt.xf(:);
% specific option for dynamics
[Offset,Scale]  = ndgrid(offset,scale);
opt.par     = [Offset(:) Scale(:)];
%
opt.disp    = 'iter';
opt.iter    = 100;
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
Nr      = 5;
u_ini    = 0.1*opt.amp*[spline(0:1/(Nr-1):1,(2*rand(1,Nr)-1),0:1/(opt.N-1):1)...
                        spline(0:1/(Nr-1):1,(2*rand(1,Nr)-1),0:1/(opt.N-1):1)];
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
[u, fval, exitflag,output] = fun_interface_opt(u_ini,opt);