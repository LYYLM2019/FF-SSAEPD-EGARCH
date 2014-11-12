%function f = funssaepdegarch(para,y, x)
%rt-rft=bt1+bt2(rmt-rft)+bt3SMBt+bt4HMLt+ut
% % para0=[bt1_0;bt2_0;bt3_0;bt4_0;alpha_0;p1_0;p2_0;a_0;b_0;c_0;d_0];
para=para0;
y=Y;
x=X;
    n=length(y);
    bt1=para(1,1);
    bt2=para(2,1);
    bt3=para(3,1);
    bt4=para(4,1);
    alpha=para(5,1);
    p1=para(6,1);
    p2=para(7,1);
    a=para(8,1);
    b=para(9,1);
    c=para(10,1);
    d=para(11,1);
%%%%%%%%%%%%%% get ut
    ut=y-x*[bt1;bt2;bt3;bt4];
%%%%%%%%%%%%% get zt (zt=ut/sigmat)
%%%%%%%%%% for E|zt|
%generate standard AEPD random number, 'zzt_2'
    xxt=randaepd(p1,p2,alpha,n);
    B=alpha*kep(p1)+(1-alpha)*kep(p2);
    xt=xxt/B;
%get zt, SSAEPD
    e_aepd=E_aepd(alpha,p1,p2);
    var_aepd=Var_aepd(alpha,p1,p2);
    std_aepd=sqrt(var_aepd);
    zt=(xt-e_aepd)/std_aepd;
    %get E/zt/
    Ezt = sum(abs(zt))/n;
    [sigmat,zt] = funegarch_e(ut,Ezt,n,a,b,c,d);
    alphass=alpha*kep(p1)/(alpha*kep(p1)+(1-alpha)*kep(p2));
%%%%%%%%% mle %%%%%%%%%%%%
    A1=0;A2=0;

    for i=1:n
        if(zt(i,1)<=-e_aepd/std_aepd)
            A1=A1-log(std_aepd/sigmat(i,1))-log(alpha/alphass)-log(kep(p1))+((abs((e_aepd+zt(i,1)*std_aepd)/(2*alphass)))^p1)/p1;
        else
            A2=A2-log(std_aepd/sigmat(i,1))-log((1-alpha)/(1-alphass))-log(kep(p2))+((abs((e_aepd+zt(i,1)*std_aepd)/(2*(1-alphass))))^p2)/p2;
        end
    end
    f=(A1+A2);
%end