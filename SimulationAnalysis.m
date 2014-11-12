%% FF-3F-SSAEPD-EGARCH
% Simulation Analysis for the 
% # $e^{\pi i} + 1 = 0$
% # $R_t-R_{ft}=\beta_1+\beta_2 (R_{mt}-R_{ft})+\beta_3 SMB_t+\beta_4
% HML_t+u_t$
% # $u_t=\sigma_t z_t, z_t\in SSAEPD(\alpha,p_1,p_2)$
% # $ln(\sigma_t^2)=a_0+G(z_t)+b_0 ln(\sigma_{t-1}^2)$
% # $G(z_{t-1})=c z_{t-1}+d [|z_{t-1}|-E|z_{t-1}|]$
%
% Created on 2012-9-14 by Yanjia Yang
% Edited on 2014-07-15 by Yuxiang Zhang
clc;
clear;
%% Parameter Set
%para[i]=[bt1_0;bt2_0;bt3_0;bt4_0;alpha_0;p1_0;p2_0;a_0;b_0;c_0;d_0]
para_0=paraset(); 
para_est=zeros(9,11);
percent_est=zeros(9,11);
n=1026;        %n=length(Y);
randn('state',123);%set seed for normal
rand('state',123456); %set seed for uniform
for i=1:9
    para0=para_0(:,i);
    b0=para0(1,1);
    b1=para0(2,1);
    b2=para0(3,1);
    b3=para0(4,1);
    alpha=para0(5,1);
    p1=para0(6,1);
    p2=para0(7,1);
    a=para0(8,1);
    b=para0(9,1);
    c=para0(10,1);
    d=para0(11,1);
%% Method of Monte Carlo simulation
%Step 1; Get zt, SSAEPD
    xxt=randaepd(p1,p2,alpha,n);
    e_aepd=E_aepd(alpha,p1,p2);
    var_aepd=Var_aepd(alpha,p1,p2);
    std_aepd=sqrt(var_aepd);
    B=alpha*kep(p1)+(1-alpha)*kep(p2);
    xt=xxt/B;
    zt=(xt-e_aepd)/std_aepd;
    Ezt=sum(abs(zt))/n;
    [sigmat,ut] = funegarch_ut(zt,Ezt,n,a,b,c,d);
    x1=ones(n,1);
    x2=rand(n,1);
    x3=rand(n,1);
    x4=rand(n,1);
    X=[x1 x2 x3 x4];
%Step 2: Get Y
    Y=X*[b0;b1;b2;b3]+ut;
%Step 3: MLE
%   0<alpha<1; p1>0; p2>0
%   para[i]=[bt1_0;bt2_0;bt3_0;bt4_0;alpha_0;p1_0;p2_0;a_0;b_0;c_0;d_0]
    A=[0 0 0 0  1 0 0 0 0 0 0 ;
       0 0 0 0 -1 0 0 0 0 0 0 ;
       0 0 0 0 0 -1 0 0 0 0 0 ;
       0 0 0 0 0 0 -1 0 0 0 0 ];
    b=[0.99999;-0.00001;-0.00001;-0.00001];
    low_w1=[-100;-100;-100;-100;0;0;0;-100;-100;-100;-100]; %low bounds for parameters
    up_w1=[100;100;100;100;1;100;100;100;100;100;100]; %upper bounds for parameters
    options=optimoptions(@fmincon,'Algorithm','interior-point','Hessian','bfgs');
    [para,fval] = fmincon(@(para)funssaepdegarch_simulate(para,Y,X),para0,A,b,[],[],low_w1,up_w1,[],options);
    para_est(i,:)=para(:);
    percent_est(i,:)=((para-para0)./para0) ;
end
    disp('para_0');
    disp(para_0);
    disp('para_est');
    disp(para_est);
    
    disp('percent_est');
    disp(percent_est*100);
    
    load splat
    sound(y,Fs)   