%mle to ff3f-ssaepd-egarch based on FF database
%%% FF-3F-SSAEPD-EGARCH
% rt-rft=bt1+bt2(rmt-rft)+bt3SMBt+bt4HMLt+ut
% ut=sigamt.zt, zt~SSAEPD(alpha,p1,p2)
% ln(sigmat^2)=a0+G(zt)+b1ln(sigamt-1^2)
% G(zt-1)=czt-1+d[/zt-1/-E/zt-1/]
%created on 2012-9-14 by yanjia yang

clc;
clear;
data1=xlsread('FFData-3F-SSAEPD-EGARCH',1,'B570:E770');
data2=xlsread('FFData-3F-SSAEPD-EGARCH',2,'B571:Z771');
para_est=zeros(25,11);
Logl_est=zeros(25,1);
aic_est=zeros(25,1);
sc_est=zeros(25,1);
hq_est=zeros(25,1);

hh=zeros(25,1);
pp=zeros(25,1);
ksstat_est=zeros(25,1);

for i=1:25

rf=data1(:,4);
ri=data2(:,i); % 将括号中数字替换为1-25，依次取得FF database中的25个分类
riminusrf=ri-rf;
Y=riminusrf;
n=length(Y);
x1=ones([n,1]);
x2=data1(:,1); % 表示rmminurf
x3=data1(:,2); % 表示SMBt
x4=data1(:,3); % 表示HMLt
X=[x1 x2 x3 x4];

%set initial value
%%%%% 全自动 set initial value automatically %%%%%%%%%%

% SSAEPD
% p1_0=0.5;              
% p2_0=0.5;            
% alpha_0=1; 

%EGARCH
%Spec=garchset('VarianceModel','EGARCH','P',1,'Q',1,'C',0,'Regress',[],'K',0.00015, 'Display','Off');
% Spec=egarch.estimate(1,1);
% [coeff,errors]=garchfit(Spec,Y, [ x2 x3 x4]);
% %garchdisp(coeff,errors);
% % disp(coeff);
% %bt1_0=garchget(coeff,'C');
% %bt=garchget(coeff,'Regress');
% %bt1_0= bt(1,1);
% %bt2_0= bt(1,1);
% %bt3_0= bt(1,2);
% %bt4_0= bt(1,3);
% %a_0=garchget(coeff,'K');s
% %b_0=garchget(coeff,'GARCH');
% %c_0=garchget(coeff,'Leverage');
% %d_0=garchget(coeff,'ARCH');

%%%%%%%%%% DONE %%%%%%%%%%%%%

%%%%% 半自动半手动set initial value automatically %%%%%%%%%%

% %SSAEPD
% p1_0=1;              
% p2_0=0.8;            
% alpha_0=0.6; 
% 
% %FF-3F
% bt1_0=0;
% bt2_0=1;
% bt3_0=0.5;
% bt4_0=0.5;
% 
% Y0=Y-bt1_0*x1-bt2_0*x2-bt3_0*x3-bt4_0*x4;
% 
% %EGARCH
% Spec=garchset('VarianceModel','EGARCH','P',1,'Q',1,'C',NaN,'K',0.00015, 'Display','Off');
% [coeff,errors]=garchfit(Spec,Y0);
% garchdisp(coeff,errors);
% % disp(coeff);
% a_0=garchget(coeff,'K');
% b_0=garchget(coeff,'GARCH');
% c_0=garchget(coeff,'Leverage');
% d_0=garchget(coeff,'ARCH');

%%%%%%%%%% DONE %%%%%%%%%%%%%


%%%%%%%% 全手动set initial value manually %%%%%%%%%%

% %SSAEPD
 p1_0=2;              
 p2_0=2;            
 alpha_0=0.5; 
% 
% %E 
 c_0=0.5;
 d_0=0.5;
% 
% %GARCH
 a_0=0.6;                         
 b_0=0.4;            
% 
% %FF-3F 
 bt1_0=0.3;            
 bt2_0=0.5;              
 bt3_0=0.5;
 bt4_0=0.5;
% %%% OR %%%
% % bt_0=X\Y;

%%%%%%%%% DONE %%%%%%%%%%%%%%%


para0=[bt1_0;bt2_0;bt3_0;bt4_0;alpha_0;p1_0;p2_0;a_0;b_0;c_0;d_0];
% para0=[bt_0;alpha_0;p1_0;p2_0;a0_0;a1_0;b1_0;c_0;d_0];


%%0<alpha<1; p1>0; p2>0
A=[0 0 0 0 1 0 0 0 0 0 0 ;
   0 0 0 0 -1 0 0 0 0 0 0 ;
   0 0 0 0 0 -1 0 0 0 0 0 ;
   0 0 0 0 0 0 -1 0 0 0 0 ];
b=[0.99999;-0.00001;-0.00001;-0.00001];
low_w1=[-100;-100;-100;-100;0;0;0;-100;-100;-100;-100]; %low bounds for parameters
up_w1=[100;100;100;100;1;100;100;100;100;100;100]; %upper bounds for parameters

options=optimset('Algorithm','interior-point','Hessian','bfgs');
[para,fval] = fmincon(@(para)funssaepdegarch(para, Y, X),para0,A,b,[],[],low_w1,up_w1,[],options);
%%% -fval=ln(极大似然函数)


para_est(i,:)=para';
    
    
Logl=-fval;
% disp('Logl');
% disp(Logl);
Logl_est(i)=Logl;

%AIC
k=size(para,1);
aic=2*fval/n+2*k/n;
% disp('AIC=');
% disp(aic);
aic_est(i)=aic;

%SC(SIC)
sc=2*fval/n+k*log(n)/n;
% disp('SC=');
% disp(sc);
sc_est(i)=sc;

%HQ
hq=2*fval/n+2*k*log(log(n))/n;
% disp('HQ=');
% disp(hq);
hq_est(i)=hq;

%%%%%%%%   KS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% for E/zt/
%generate standard AEPD random number, 'zzt_2'
xt_1=randaepd(para(6,1),para(7,1),para(5,1),n);
alphas=para(5,1)*kep(para(6,1))/(para(5,1)*kep(para(7,1))+(1-para(5,1))*kep(para(7,1)));
ww=para(5,1)*kep(para(6,1))+(1-para(5,1))*kep(para(7,1));
xt_2=xt_1/ww;
%get zzt, SSAEPD
e_aepd=E_aepd(para(5,1),para(6,1),para(7,1));
var_aepd=Var_aepd(para(5,1),para(6,1),para(7,1));
zt=(xt_2-e_aepd)/sqrt(var_aepd);
%get E/zt/
[Ezt] = funEzt(zt,n);

%%%%%%%% for zt
ut=Y-X*[para(1,1);para(2,1);para(3,1);para(4,1)];
[ sigmat,zt ] = funegarch_e( ut, Ezt, n, para(8,1), para(9,1), para(10,1), para(11,1));
%%%%%%%%%%%

e_aepd=E_aepd(para(5,1),para(6,1),para(7,1));
var_aepd=Var_aepd(para(5,1),para(6,1),para(7,1));
E=zt*sqrt(var_aepd)+e_aepd;  %aepd  %获得理论的AEPD随机数（Ｘ坐标）、及其累积概率CDF
c=(min(E)-1:.01: max(E)+1)';%make sure c include E's elements
v_cdf=aepdcdf(c,para(6,1),para(7,1),para(5,1),0,1); %获得AEPD随机数的累积概率

[h,p, ksstat,cv]=kstest(E,[c,v_cdf],0.05);
hh(i)=h;
pp(i)=p;
ksstat_est(i)=ksstat;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

disp(para_est);

disp(aic_est);
disp(sc_est);
disp(hq_est);

disp([hh]);
disp(pp);

disp(ksstat_est);

disp(Logl_est); %无限制时极大似然函数

A=[para_est Logl_est hh pp ksstat_est aic_est ];
disp(A)

%啪哒声
load splat
sound(y,Fs)
