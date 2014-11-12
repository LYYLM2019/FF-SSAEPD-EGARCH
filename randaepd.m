%generate standard asymetric exponential power distribution random number
%Dongming Zhu and Zinde-Walsh(2009), Journal of Econometrics
%page 91, section 6: performance of MLE in simulation

%(AEPD) with location mu=0, scale sigma=1
%input: 
%   p1>0 : the left tail parameters
%   p2>0: the right tail parameters
%   0<alpha<1
%output:
%   y: the random varialbe of standard asymmetric exponential power distribution
%if p1=p2, skewed EPD
%if p1=p2=1: skewed Laplace
%if p1=p2=2: skewed Normal
%if alpha=1/2: EPD

function y=randaepd(p1, p2, alpha,n)
% p1=.5;
% p2=.6;
% alpha=.5;

if p1<=0 
    disp('p1 should be greater than 0.');
elseif p2<=0 
    disp('p2 should be greater than 0.');
elseif ((alpha<=0) || (alpha>1)) 
    disp('alpha should be greater than 0 and less than 1.');
else
    U=rand(n,1);
    W1=randg(1/p1,[n,1]);
    W2=randg(1/p2,[n,1]);
    y=alpha*((W1).^(1/p1)).*((sign(U-alpha)-1)/(2*gamma(1+1/p1)))+(1-alpha)*(W2.^(1/p2)).*((sign(U-alpha)+1)/(2*gamma(1+1/p2)));

end





