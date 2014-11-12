% Y is the returns of Fama-French Assets.
clear;
clc;

Y=xlsread('sp500',1,'B2:B757');
n=756;      %n=length(Y)
randn('state',123); 
randn('state',123456);

%% M1: AR(1)-GARCH(1,1)-AEPD
% Set parameters
b0    = 0.00014;
b1    = -0.1041;
a0    = 0.00001;
a1    = 0.1465;
beta  = 0.8246;
alpha = 0.5205;
p1    = 1.0923;
p2    = 1.3334;

% Get ipsilont~AEPD
ipsilont=randaepd(p1,p2,alpha,n);

% Get ut, sigmat
sigmat=ones(n,1);
ut=ones(n,1);
ut(1,1)=sigmat(1,1)*ipsilont(1,1);
for i=2:n
    sigmat(i,1)=sqrt(   a0+a1*(ut(i-1,1)^2) + beta*(sigmat(i-1,1)^2)  );
    ut(i,1)=sigmat(i,1)*ipsilont(i,1);
end
quantile_stand=quantile(ut,0.05);
disp('Standard 5% Quantile');
disp(quantile_stand);

% Get Returns
R=zeros(n,1);
for i=2:n
    R(i,1)=b0+b1*R(i-1,1)+ut(i,1);
end
quantile_r=quantile(R,0.05);
disp('5% Quantile for r,');
disp(quantile_r);

%% M2: AR(1)-GARCH(1,1)-Normal
% Set parameters
b0    = 0.00029;
b1    = -0.1353;
a0    = 0.00001;
a1    = 0.131;
beta  = 0.8316;
alpha = 0.5;
p1    = 2;
p2    = 2;

% Get ipsilont~Normal
ipsilont=randaepd(p1,p2,alpha,n);

% Get ut, sigmat
sigmat=ones(n,1);
ut=ones(n,1);
ut(1,1)=sigmat(1,1)*ipsilont(1,1);
for i=2:n
    sigmat(i,1)=sqrt(   a0+a1*(ut(i-1,1)^2) + beta*(sigmat(i-1,1)^2)  );
    ut(i,1)=sigmat(i,1)*ipsilont(i,1);
end
quantile_stand=quantile(ut,0.05);
disp('Standard 5% Quantile')
disp(quantile_stand);

% Get Returns
R=zeros(n,1);
for i=2:n
    R(i,1)=b0+b1*R(i-1)+ut(i,1);
end
quantile_r=quantile(R,0.05);
disp('5% Quantile for r');
disp(quantile_r);

%% M3: AR(0)-IGARCH-AEPD b0=0
%% M4: AR(0)-IGARCH-AEPD b0!=0
%% M5: AR(0)-IGARCH-Normal
