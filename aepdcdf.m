% staepdcdf= cdf of standard AEPD
% see equation (10) on page 89 of Zhu and Zinde-Walsh(2009), J. of
% Econometrics 148, 86-99

%input:
% x random variable of AEPD
% p1 left tail parameter
% p2 right tail parameter
% alpha skewness parameter
%output
% y: sorted AEPD random variable
% y_cdf: the cdf values for AEPD random variable

function y_cdf=aepdcdf(y, p1, p2, alpha,mu,sigma)
alphastar=alpha*kep(p1)/(alpha*kep(p1)+(1-alpha)*kep(p2));
% y_sorted=sort(y); 
% y=y_sorted;
[n,m]=size(y);

for j=1:m
    for i=1:n
        if y(i,j)<=mu
            z1=(1/p1).*((abs((y(i,j))-mu)/(2*alphastar*sigma)).^p1);
            zz1=gammainc(z1, 1/p1);
            y_cdf(i,j)=(alpha.*(1.-zz1))';
        end
        if y(i,j)>mu
            z2=(1/p2)*((abs((y(i,j)-mu)/(2*(1-alphastar)*sigma))).^p2);
            y_cdf(i,j)=(alpha+(1-alpha).*gammainc(z2, 1/p2))';
        end
    end 
end