function gr  = fun_grad_quaternion_exact(u,y,p,opt)
N               = opt.N;
M               = size(opt.par(:,1),1);
y               = reshape(y,size(opt.par(:,1),1),4,N+1);
p2              = zeros(size(opt.x0));
p2(:,1)         = 1;
gr              = zeros(1,length(u));
grtmp           = zeros(3*M,1);
Z               = zeros(size(opt.par,1),1);
dt              = opt.dt;
for i1 = 1:N
    m            = sqrt(u(N-i1+1).^2+u(2*N-i1+1).^2);
    mm           = sqrt(opt.par(:,2).^2.*m.^2+opt.par(:,1).^2);
    chi          = mm * opt.dt;
    %----
    ct          = opt.par(:,1)./mm;
    st          = opt.par(:,2)*m./mm;
    cp          = u(N-i1+1)./m;
    sp          = u(2*N-i1+1)./m;
    cc          = cos(chi);
    sc          = sin(chi);
    %---- 1 : Grad theta 2 : Grad phi 3 : Grad Chi ([cc sc.*st.*[cp sp] sc.*ct]])
    tmp         = fun_quaternion_product([Z sc.*ct*[cp sp] -sc.*st],y(:,:,N-i1+1));
    tmp2        = fun_quaternion_product(p2,tmp);
    grtmp(1:M)  = sum(reshape(p,M,4).*reshape(tmp2,M,4),2);
    %
    tmp         = fun_quaternion_product([Z sc.*st*[-sp cp] Z],y(:,:,N-i1+1));
    tmp2        = fun_quaternion_product(p2,tmp);
    grtmp((1:M)+M)      = sum(reshape(p,M,4).*reshape(tmp2,M,4),2);
    %
    tmp         = fun_quaternion_product([-sc cc.*st*[cp sp] cc.*ct],y(:,:,N-i1+1));
    tmp2        = fun_quaternion_product(p2,tmp);
    grtmp((1:M)+2*M)    = sum(reshape(p,M,4).*reshape(tmp2,M,4),2);
    %---- Conversion spherical grad to control grad
gr(N-i1+1) = sum(u(N-i1+1).*opt.par(:,2).*opt.par(:,1) ./(mm.^2.*m ) .* grtmp((1:M)) ...
                        -u(2*N-i1+1) / m^2 .* grtmp((1:M)+M) ...
                     + opt.dt ./mm .* u(N-i1+1) .* opt.par(:,2).^2 .* grtmp(2*M+(1:M)));
    %
    gr(2*N-i1+1) = sum(u(2*N-i1+1).*opt.par(:,2).*opt.par(:,1) ./(mm.^2.*m) .* grtmp((1:M)) ...
                           +  u(N-i1+1) / m^2 .* grtmp((1:M)+M) ...
                     + opt.dt ./mm .* u(2*N-i1+1) .* opt.par(:,2).^2 .* grtmp(2*M+(1:M)));
    %---- back propagation quaternion adjoint state
    p2          = fun_quaternion_product(p2,[cc sc.*st*[cp sp] sc.*ct]);
end