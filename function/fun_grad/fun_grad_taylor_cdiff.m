function gr  = fun_grad_taylor_cdiff(u,y,x0,opt)
dt      = opt.dt;
N       = opt.N;
M       = opt.M;
Nmat    = length(opt.Hc);
p       = x0;
gr      = zeros(size(u));
epsi    = 1e-10;
for i1 = 1:N %---- control step
    for i5 = 1:Nmat
        p2      = p;
        %---- choose between linear control and non linear provided by user
        U       = u((N-i1+1):N:end);
        U(i5)   = U(i5) + 1i*epsi;
        Dyn     = opt.Hd;
        for i3 = 1:Nmat
            Dyn     = Dyn + U(i3) * opt.Hc{i3};
        end
        for i4 = 1:M  %---- sub grid step
            n_old   = 1;
            %---- compute the propagator as a taylor serie expansion
            dp      = p2;
            cdp     = dp;
            for i2 = 1:opt.m
                dp          = (dt/i2)*(dp * Dyn);
                cdp         = cdp  + dp;
                %             n_new       = max(abs(dy(:)));
                n_new       = norm(dp);
                if n_new + n_old < opt.eps
                    break
                end
                n_old       = n_new;
            end
            p2  = real(cdp);
            if i2 == opt.m
                fprintf('taylor accuracy\n')
            end
            idx           = (N-i1+1) * M - i4+1;
            gr(i5*N-i1+1) = gr(i5*N-i1+1) + imag(cdp*y(:,idx))/epsi;
        end
    end
    p   = p2;
end