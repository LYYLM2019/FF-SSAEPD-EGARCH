clc;
clear;
% Load
s1b1=load('s1b1.mat');
s1b2=load('s1b2.mat');
s1b3=load('s1b3.mat');
s2b1=load('s2b1.mat');
s2b2=load('s2b2.mat');
s2b3=load('s2b3.mat');
s3b1=load('s3b1.mat');
s3b2=load('s3b2.mat');
s3b3=load('s3b3.mat');
s4b1=load('s4b1.mat');
s4b2=load('s4b2.mat');
s4b3=load('s4b3.mat');
s5b1=load('s5b1.mat');
s5b2=load('s5b2.mat');
s5b3=load('s5b3.mat');
s6b1=load('s6b1.mat');
s6b2=load('s6b2.mat');
s6b3=load('s6b3.mat');
%% Plot beta1
    figure;
ah=axes;
plot(ah,1:25,s1b1.b1,'b.-',1:25,s2b1.b1,'rs-','LineWidth',2,'MarkerSize',8);
grid;
xlabel('Famer-French 25 Portfolios')
ylabel('Value of \beta_1');
legend('Sample 1','Sample 2');
print -depsc2 b1a.eps
% export_fig(gcf,'b1a.eps');
    figure;
bh=axes;
plot(bh,1:25,s3b1.b1,'b.-',1:25,s4b1.b1,'rs-','LineWidth',2,'MarkerSize',8);
grid;
xlabel('Famer-French 25 Portfolios')
ylabel('Value of \beta_1');
legend('Sample 3','Sample 4');
print -depsc2 b1b.eps;
    figure;
ch=axes;
plot(ch,1:25,s5b1.b1,'b.-',1:25,s6b1.b1,'rs-','LineWidth',2,'MarkerSize',8);
grid;
xlabel('Famer-French 25 Portfolios')
ylabel('Value of \beta_1');
legend('Sample 5','Sample 6');
print -depsc2 b1c.eps;

% Plot beta 2
    figure;
dh=axes;
plot(dh,1:25,s1b2.b2,'b.-',1:25,s2b2.b2,'rs-','LineWidth',2,'MarkerSize',8);
grid;
xlabel('Famer-French 25 Portfolios')
ylabel('Value of \beta_2');
legend('Sample 1','Sample 2');
print -depsc2 b2a.eps;
    figure;
eh=axes;
plot(eh,1:25,s3b2.b2,'b.-',1:25,s4b2.b2,'rs-','LineWidth',2,'MarkerSize',8);
grid;
xlabel('Famer-French 25 Portfolios')
ylabel('Value of \beta_2');
legend('Sample 3','Sample 4');
print -depsc2 b2b.eps;
figure;
gh=axes;
plot(gh,1:25,s5b2.b2,'b.-',1:25,s6b2.b2,'rs-','LineWidth',2,'MarkerSize',8);
grid;
xlabel('Famer-French 25 Portfolios')
ylabel('Value of \beta_2');
legend('Sample 5','Sample 6');
print -depsc2 b2c.eps;
%% Plot beta3
figure;
gh=axes;
plot(gh,1:25,s1b3.b3,'b.-',1:25,s2b3.b3,'rs-','LineWidth',2,'MarkerSize',8);
grid;
xlabel('Famer-French 25 Portfolios')
ylabel('Value of \beta_3');
legend('Sample 1','Sample 2');
print -depsc2 b3a.eps;
figure;
ih=axes;
plot(ih,1:25,s3b3.b3,'b.-',1:25,s4b3.b3,'rs-','LineWidth',2,'MarkerSize',8);
grid;
xlabel('Famer-French 25 Portfolios')
ylabel('Value of \beta_3');
legend('Sample 3','Sample 4');
print -depsc2 b3b.eps;
figure;
jh=axes;
plot(jh,1:25,s5b3.b3,'b.-',1:25,s6b3.b3,'rs-','LineWidth',2,'MarkerSize',8);
grid;
xlabel('Famer-French 25 Portfolios')
ylabel('Value of \beta_3');
legend('Sample 5','Sample 6');
print -depsc2 b3c.eps