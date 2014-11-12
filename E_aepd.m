function e_aepd=E_aepd(alpha,p1,p2)
w=alpha*kep(p1)+(1-alpha)*kep(p2);
e_aepd=((((1-alpha)^2)*p2*(gamma(2/p2))/(gamma(1/p2))^2)-((alpha)^2)...
    *p1*gamma(2/p1)/(gamma(1/p1))^2)/w;
end


