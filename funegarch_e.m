function [ sigmat,zt ] = funegarch_e( ut, Ezt, n, a, b, c, d)
% zt=ut/sigamt, zt~SSAEPD(alpha,p1,p2)
% ln(sigmat^2)=a0+a1G(zt)+b1ln(sigamt-1^2)
% G(zt-1)=czt-1+d[/zt-1/-E/zt-1/]
zt0=0;
sigmat0=1;
zt=zeros(n,1);
sigmat=zeros(n,1);

gzt0=(c+d)*zt0-d*Ezt;
sigmat(1)=sqrt(exp(a+gzt0+b*log((sigmat0^2))));
zt(1)=ut(1)/sigmat(1);


for i=1:n-1
    if zt(i,1)<0;
        gzt=(c-d)*zt(i)-d*Ezt;
    else
        gzt=(c+d)*zt(i)-d*Ezt;
    end
    sigmat(i+1)=sqrt(exp(a+gzt+b*log((sigmat(i)^2))));
    zt(i+1)=ut(i+1)/sigmat(i+1);   
end
