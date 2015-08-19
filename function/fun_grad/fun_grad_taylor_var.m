function y  = fun_grad_taylor_var(u,y,p,opt)
dt  = opt.dt;
N   = opt.N;
M   = opt.M;
Nx      = length(opt.x0);
Nmat    = length(opt.Hc);
y       = zeros((Nmat+1)*Nx,N*M+1);
S       = [ones(Nx,1) ; zeros(Nmat*Nx,1)];
y(1:Nx,1)  = opt.x0;
for i1 = 1:N %---- control step
    %---- choose between linear control and non linear provided by user
    U       = u(i1:N:end);
    Dyn     = opt.Hd;
    for i3 = 1:Nmat
        Dyn = Dyn + U(i3)*opt.Hc{i3};
    end
    for i4 = 1:M  %---- sub grid step
        idx = (i1-1)*M + i4;
        %---- compute the propagator as a taylor serie expansion
        dy          = S.*y(:,idx); % opt.S, set grad part to zero !!!
        cdy         = dy;
        n_old       = 1;
        for i2 = 1:opt.m
            dy          = (dt/i2)*(Dyn*dy);
            cdy         = cdy  + dy;
            n_new       = norm(dy);
            if n_new + n_old < opt.eps
%             if n_new < opt.eps
                break
            end
            n_old       = n_new;
        end
        if i2 == opt.m
            fprintf('Maximum order of Taylor expansion reached!!!\n')
        end
        y(:,idx+1)  = cdy;
    end
end
%----
gr      = zeros(size(u));
Nmat    = length(opt.Hc);
for i1 = 1:opt.N
    for i2 = 1:opt.M
        idx     = (i1-1)*opt.M + i2;
        for i3 = 1:Nmat
%                 gr(i1+(i3-1)*opt.N)     = gr(i1+(i3-1)*opt.N) + p(:,idx+1).'*x(:,i3+1,idx+1);
            gr(i1+(i3-1)*opt.N)     = gr(i1+(i3-1)*opt.N) + p(:,idx+1).'*x((i3*Nx+1):(i3+1)*Nx,idx+1);
        end
    end
end