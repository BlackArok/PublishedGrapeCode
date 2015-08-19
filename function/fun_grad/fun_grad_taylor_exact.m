function grad = fun_grad_taylor_exact(u,x,p,opt)
dt      = opt.dt;
N       = opt.N;
M       = opt.M;
% nc      = length(u)/N;
Nmat    = length(opt.Hc);
grad    = zeros(1,Nmat*N);
tmp2x   = cell(opt.m,1);
tmp     = cell(opt.m,1);
tmp2p   = cell(1,opt.m);
for i1 = 1:N %---- control step
    %---- choose between linear control and non linear provided by user
    U       = u((N-i1+1):N:end);
    for i4 = 1:M  %---- sub grid step
        idx     = (N-i1) * M + M-i4+1;  %---- indices describing backward gradient computation on total grid
        %---- computation of u-gradient of taylor series ---------------------%
        %---- precomputation of (p,pU_N,...) and (...,U_1x,x)
        Dyn         = opt.Hd;
        for i2 = 1:Nmat
            Dyn     = Dyn + U(i2) * opt.Hc{i2};
        end
        done        = zeros(1,opt.m); %---- put done at zeros
        done(1)     = 1;
        tmp2x{1}    = x(:,idx);
        tmp2p{1}    = p;
        %---- loop over the gradient of each component of the control
        for i5 = 1:Nmat
            A       = opt.Hc{i5};
            tmp3    = 0;
            tmp4    = dt;
            tmp5    = 1;
            %---- derivative of taylor series of propagator
            for i2 = 1:opt.m %- sum of taylor
                if done(i2) ~= 1
                    tmp2x{i2}   = Dyn*tmp2x{i2-1};
                    tmp2p{i2}   = tmp2p{i2-1}*Dyn;
                    done(i2)    = 1;
                end
                tmp{i2}     = A*tmp2x{i2}; %---- compute A^i x_j
                for i3 = 1:i2
                    tmp3        = tmp3 + tmp4*tmp2p{i2-i3+1}*tmp{i3};
                end
                if abs(tmp5-tmp3) < 1e-12
                    break
                end
                tmp5        = tmp3;
                tmp4        = tmp4/(i2+1)*dt;
            end
%             fprintf('gr : i2 = %d\n',i2)
            grad(i5*N-i1+1)    = grad(i5*N-i1+1) + tmp3; %---- summed over intervalle M
        end
        %---- backpropagation of adjoint vector ------------------------------%
        dp      = p;
        for i2 = 1:opt.m
            dp  = dt/i2*dp*Dyn;
            p   = p + dp;
            if norm(dp) < 1e-12
                break
            end
        end
    end
end