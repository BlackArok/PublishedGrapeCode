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
Tmax    = 150e-6*bound;
scale   = linspace(-Smax,Smax,NSmax) + 1;
offset  = linspace(-Dmax,Dmax,NDmax);
%-------------------------------------------------------------------------%



%-------------------------------------------------------------------------%
% common option
opt     = fun_set_grape('Constraint','@fun_constr_1rf_2component_max_amp',...
                        'Dynamics','@fun_rotation',...
                        'Gradient','exact');
% opt     = fun_set_grape();
opt.N   = 10;
opt.dt  = Tmax/opt.N;
opt.amp = 1;
X0      = [0;0;1];
Xf      = [0;0;-1];
opt.x0  = repmat(X0,NDmax*NSmax,1)/sqrt(NDmax*NSmax);
opt.xf  = repmat(Xf,NDmax*NSmax,1)/sqrt(NDmax*NSmax);
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

DYN = str2func( opt.Dynamics);
y   = DYN(u,opt);
Y   = y(:,end) * sqrt(NSmax*NDmax);
Y   = reshape(Y,3,size(Offset,1),size(Offset,2));
figure;
couleur     = hsv(NSmax);
for i2 = 1:3
    subplot(6,1,[1 2]+2*(i2-1));box on;hold on
    for i1 = 1:NSmax
        plot(offset,Y(i2,:,i1),'color',couleur(i1,:))
    end
end