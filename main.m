%-------------------------------------------------------------------------%
clear all % refresh workspace
close all % close all open object
clc       % clear command window screen
mystartup;% set different required path for Grape Code
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
T1      = 1.350;
T2      = 50e-3;
g       = 1/T1;
G       = 1/T2;
NSmax   = 10;
Smax    = 1/3;
Tmax    = 210e-3;
scale   = linspace(-Smax,Smax,NSmax) + 1;
[Hd,Hc] = fun_build_mat_1spin_half_1control_decoherence(G,g,scale);
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
% common option
opt     = fun_set_grape('Constraint','@fun_constr_1rf_1component_max_amp');
% opt     = fun_set_grape();
opt.N   = 100;
opt.amp = 100;
X0      = [0;1];
Xf      = [0;0];
opt.x0  = [1;repmat(X0,NSmax,1)];
opt.xf  = [1;repmat(Xf,NSmax,1)];
% specific option for dynamics
opt.M   = 1;
opt.dt  = Tmax/opt.M/opt.N;
opt.Hd  = Hd;
opt.Hc  = Hc;
opt.m   = 40;
opt.eps = 1e-10;
%
opt.disp    = 'iter';
opt.iter    = 100;
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
Nr      = 5;
u_ini    = opt.amp*spline(0:1/(Nr-1):1,(2*rand(1,Nr)-1),0:1/(opt.N-1):1);
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
[u, fval, exitflag,output] = fun_interface_opt(u_ini,opt);

DYN = str2func( opt.Dynamics);
y   = DYN(u,opt);
figure;hold on
    for i1 = 1:NSmax
        plot(y(1+2*(i1-1)+1,:),y(1+2*(i1-1)+2,:))
    end
    axis equal