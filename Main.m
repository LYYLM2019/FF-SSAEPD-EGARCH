%% FF-3F-SSAEPD-EGARCH 
%%  MLE to FF3F-SSAEPD-EGARCH based on FF database
% # $e^{\pi i} + 1 = 0$
% # $R_t-R_{ft}=\beta_1+\beta_2 (R_{mt}-R_{ft})+\beta_3 SMB_t+\beta_4
% HML_t+u_t$
% # $u_t=\sigma_t z_t,\, z_t\in SSAEPD(\alpha,p_1,p_2)$
% # $ln(\sigma_t^2)=a_0+G(z_t)+b_0 ln(\sigma_{t-1}^2)$
% # $G(z_{t-1})=c z_{t-1}+d [|z_{t-1}|-E|z_{t-1}|]$

% Created on 2012-9-14 by yanjia yang
% Edited on 2014-7-15 by Yuxiang Zhang

clc;
clear;

%% Main
for k=1:1
    %Initialise
    [data1,data2]=xlsload(k);
    para_est=zeros(25,11);
    para_check=zeros(25,11);
    Logl_est=zeros(25,1);
    h1=zeros(25,11);
    p1=zeros(25,11);
    h2=zeros(25,1);
    p2=zeros(25,1);
    ksstat_est=zeros(25,1);
    
    para_lr=zeros(11,11);
    logl=zeros(11,25);
    pval=zeros(25,11);
    
% French 25 portfolios
    for i=1:25
        Y=data2(:,i)-data1(:,4);
        n=length(Y);
        x1=ones([n,1]);
        x2=data1(:,1); % RmMinuRf factor
        x3=data1(:,2); % SMBt factor
        x4=data1(:,3); % HMLt factor
        X=[x1 x2 x3 x4];
%% Automatic Set Initial Value
% Prefixing the SSAEPD Parameters as to be Normal distribution
        alpha_0=0.5;
        p1_0=2;              
        p2_0=2;
%MultiVariate Regression for coefficients of Fama-French 3 Factors
        bt=regress(Y,X);
        bt1_0= bt(1);
        bt2_0= bt(2);
        bt3_0= bt(3);
        bt4_0= bt(4);
%EGARCH
        Spec=egarch('Constant',0.6,'GARCH',0.4,'ARCH',0.8,'Leverage',0.5);
        % Spec=egarch(1,1);
        % Egarch Manual-Set regarding to the simulation analysis on the parameters of
        % EGARCH-SSAEPD model
        [EstMdl,EstParam,logL,info]=estimate(Spec,Y-X*bt);
% a: Constant
        a_0=info.X(1);
% b: GARCH
        b_0=info.X(2);
% c: ARCH
        c_0=info.X(4);
% d: Leverage        
        d_0=info.X(3);
% INITIAL Done, generate under FF-3factor-EGARCH(0.6,0.4,0.8,0.5)-Normal  
        para0=[bt1_0;bt2_0;bt3_0;bt4_0;alpha_0;p1_0;p2_0;a_0;b_0;c_0;d_0];
%% MLE
% 0<alpha<1; p1>0; p2>0
        A=[0 0 0 0 1 0 0 0 0 0 0 ;
           0 0 0 0 -1 0 0 0 0 0 0 ;
           0 0 0 0 0 -1 0 0 0 0 0 ;
           0 0 0 0 0 0 -1 0 0 0 0 ;
           0 0 0 0 0 0 0 0 -1 0 0];
        b=[0.99999;-0.00001;-0.00001;-0.00001;-0.99999];
% Low bounds for parameters        
        low_w1=[-100;-100;-100;-100;0;0;0;-100;-100;-100;-100]; 
% Upper bounds for parameters
        up_w1=[100;100;100;100;1;100;100;100;100;100;100]; 
        options=optimset('Algorithm','interior-point','Hessian','bfgs');
        [para,fval] = fmincon(@(para)funssaepdegarch(para, Y, X),para0,A,b,[],[],low_w1,up_w1,[],options);
        para_est(i,:)=para';
        para_check(i,:)=abs((para'-para0'))./para0';
% Logl: value of the log-likelihood function
        Logl_est(i)=-fval;
%% Likelihood Ration Test for 11 parameters
        for j=1:11
            para_lr(:,j)=para;
            para_lr(j,j)=para0(j,1);
            logl(j,i)=-funssaepdegarch(para_lr(:,j),Y,X);
            [h,pval,~,~]=lratiotest(Logl_est(i), logl(j,i),1); 
            h1(i,j)=h;
            p1(i,j)=pval;
        end
%%   Kolmogorov-Smirnov Test  
% generate 'xt',AEPD random number
        xxt=randaepd(para(6,1),para(7,1),para(5,1),n);
        alphas=para(5,1)*kep(para(6,1))/(para(5,1)*kep(para(7,1))+(1-para(5,1))*kep(para(7,1)));
        ww=para(5,1)*kep(para(6,1))+(1-para(5,1))*kep(para(7,1));
        xt=xxt/ww;
%get 'zt_0',theoretical SSAEPD
        e_aepd=E_aepd(para(5,1),para(6,1),para(7,1));
        var_aepd=Var_aepd(para(5,1),para(6,1),para(7,1));
        zt_0=(xt-e_aepd)/sqrt(var_aepd);
%get E|zt|
        Ezt=sum(abs(zt_0))/n;
% for zt
        ut=Y-X*[para(1,1);para(2,1);para(3,1);para(4,1)];
        [sigmat,zt] = funegarch_e(ut,Ezt,n,para(8,1),para(9,1),para(10,1),para(11,1));
% get theoretical AEPD & CDF
        E=zt*sqrt(var_aepd)+e_aepd; 
% make sure c include E's elements    
        c=(min(E)-1:.01: max(E)+1)';
        v_cdf=aepdcdf(c,para(6,1),para(7,1),para(5,1),0,1); 
        [h,pval, ksstat,cv]=kstest(E,[c,v_cdf],0.05); 
        h2(i)=h;
        p2(i)=pval;
        ksstat_est(i)=ksstat;
    end
%% Display
    % xlswrite('estimate',para_est,'Sample6');
    % xlswrite('estimate',pval,'pval_6');
    disp('ksstat_est');
    disp(ksstat_est);
end
%% Finish Sound
load splat
sound(y,Fs)