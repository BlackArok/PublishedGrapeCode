function yout  = fun_quaternion(u,opt)
N               = opt.N;
yout            = zeros(size(opt.x0,1),size(opt.x0,2),N+1);
yout(:,:,1)     = opt.x0;
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
    %---- Quaternion :(cos(chi/2),sin(chi/2)*(sin(theta)cos(phi),sin(theta)sin(phi),cos(theta)))
    yout(:,:,i1+1)  = fun_quaternion_product([cc sc.*st*[cp sp] sc.*ct],yout(:,:,i1));
end
yout    = reshape(yout,numel(opt.x0),N+1);