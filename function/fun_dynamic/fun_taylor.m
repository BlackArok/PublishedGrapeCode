function y  = fun_taylor(u,opt)
% fun_taylor(u,opt) : action of exponential of matrix on state computed
% trough Taylor series
% u is the control
% opt contain the required parameter :
% opt.dt  : time step
% opt.N   : number of time step
% opt.M   : number of sub time step (if Taylor series do not converge after
% the treshold max value, we should refine the time step and increase
% opt.M)
% opt.Hd : matrix containing the drift
% opt.Hc : cell containing all the interaction matrix
% opt.amp : contain the maximum amplitude
% opt.m : contain the maximal power of Taylor series
dt  = opt.dt;
N   = opt.N;
M   = opt.M;
Nmat    = length(opt.Hc);
y       = zeros(length(opt.x0),N*opt.M+1);
y(:,1)  = opt.x0;
for i1 = 1:N %---- control step
    %---- choose between linear control and non linear provided by user
    U   = u(i1:N:end);
    Dyn         = opt.Hd;
    for i3 = 1:Nmat
        Dyn     = Dyn + U(i3) * opt.Hc{i3};
    end
    nold    = 1;
    for i4 = 1:M  %---- sub grid step
        idx = (i1-1)*M + i4;
        %---- compute the propagator as a taylor serie expansion
        dy          = y(:,idx);
        cdy         = dy;
        for i2 = 1:opt.m
            dy          = (dt/i2)*(Dyn * dy);
            cdy         = cdy  + dy;
            tmp         = norm(dy);
            if nold + tmp < opt.eps
                break
            else
                nold    = tmp;
            end
        end
        if i2 == opt.m
            fprintf('taylor accuracy\n')
        end
        y(:,idx+1)  = cdy;
    end
end