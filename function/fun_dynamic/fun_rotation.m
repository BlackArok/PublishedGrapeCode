function  yout  = fun_rotation(u,opt)%yin,m,phi,par,dt)
N               = opt.N;
yout            = zeros(size(opt.x0,1),N+1);
yout(:,1)       = opt.x0;
M               = size(opt.par(:,1),1);
for i1 = 1:N
    m           = sqrt(u(i1).^2+u(i1+N).^2);
    mm          = sqrt(opt.par(:,2).^2.*m.^2+opt.par(:,1).^2);
    chi         = mm * opt.dt;
    %----
    ct          = opt.par(:,1)./mm;
    st          = opt.par(:,2)*m./mm;
    cp          = u(i1)./m;
    sp          = u(i1+N)./m;
    cc          = cos(chi);
    sc          = sin(chi);
    %----
    ytmp                = reshape(yout(:,i1),3,M).';
    %----
    yout(1:3:end,i1+1)  = (-st.^2 .* (cc - 1) .* cp .^ 2 + cc) .* ytmp(:,1) + ...
                          (-sp .* (cc - 1) .* st .^ 2 .* cp - ct .* sc) .* ytmp(:,2) +...
                          st .*( (-cc + 1) .* cp .* ct + sc .* sp) .* ytmp(:,3);
                      
    yout(2:3:end,i1+1)  = ((-cc + 1) .* sp .* cp .* st .^ 2 + ct .* sc) .* ytmp(:,1) +...
                          (  (cc - 1) .* (-sp.^2 .* st .^ 2 + 1) + 1 ) .* ytmp(:,2) + ...
                          st .*(-sc .* cp + sp .* (- cc + 1) .* ct) .* ytmp(:,3);
                      
    yout(3:3:end,i1+1)  = -st .*( (cc - 1) .* cp .* ct + sc .* sp) .* ytmp(:,1) + ...
                          ((-cc + 1) .* ct .^ 2 + cc) .* ytmp(:,3) + ...
                          st .* ((-cc + 1) .* sp .* ct +  sc .* cp) .* ytmp(:,2);
end