function [f gradf] = funssaepdegarch_simulate(para,y,x)
% para0=[bt1_0;bt2_0;bt3_0;bt4_0;alpha_0;p1_0;p2_0;a_0;b_0;c_0;d_0];
    n=length(y);
    bt1=para(1);
    bt2=para(2);
    bt3=para(3);
    bt4=para(4);
    alpha=para(5);
    p1=para(6);
    p2=para(7);
    a=para(8);
    b=para(9);
    c=para(10);
    d=para(11);
    ut=y-x*[bt1;bt2;bt3;bt4];
%% get zt (zt=ut/sigmat) 
% for E|zt|
% generate standard AEPD random number, 'zt_2'
    xxt=randaepd(p1,p2,alpha,n);
    B=alpha*kep(p1)+(1-alpha)*kep(p2);
    xt=xxt/B;
    
% get zt, SSAEPD
    e_aepd=E_aepd(alpha,p1,p2);%    E_aepd checked
    var_aepd=Var_aepd(alpha,p1,p2);%    Var_aepd checked
    std_aepd=sqrt(var_aepd);
    zt_0=(xt-e_aepd)/std_aepd;
    %get E/zt/
    Ezt=sum(abs(zt_0))/n;
    [sigmat,zt] = funegarch_e(ut,Ezt,n,a,b,c,d); %  
    alphass=alpha*kep(p1)/(alpha*kep(p1)+(1-alpha)*kep(p2));%   checked
% mle 
    A1=0;A2=0;
%Checked
    for i=1:n
        if(zt(i)<=-e_aepd/std_aepd)
            A1=A1-log(std_aepd/sigmat(i))-log(alpha/alphass)-log(kep(p1))+((abs((e_aepd+zt(i)*std_aepd)/(2*alphass)))^p1)/p1;
        else
            A2=A2-log(std_aepd/sigmat(i))-log((1-alpha)/(1-alphass))-log(kep(p2))+((abs((e_aepd+zt(i)*std_aepd)/(2*(1-alphass))))^p2)/p2;
        end
    end
    f=(A1+A2);
end