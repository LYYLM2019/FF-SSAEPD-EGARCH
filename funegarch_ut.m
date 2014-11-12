function [sigmat,ut] = funegarch_ut(zt,Ezt,n,a,b,c,d)
zt0=1;
sigmat0=1;
ut=zeros(n,1);
sigmat=zeros(n,1);
gzt0=(c+d)*zt0-d*Ezt;
sigmat(1)=sqrt(exp(a+gzt0+b*log((sigmat0^2))));
ut(1)=zt(1)*sigmat(1);
for i=1:n-1
    if zt(i,1)<0;
        gzt=(c-d)*zt(i)-d*Ezt;
    else
        gzt=(c+d)*zt(i)-d*Ezt;
    end
    sigmat(i+1)=sqrt(exp(a+gzt+b*log((sigmat(i)^2))));
    ut(i+1)=zt(i+1)*sigmat(i+1);   
end
end