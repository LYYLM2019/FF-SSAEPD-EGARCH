%kernel density estimation
function [xx,den]=kden(v)
[nn,c]=size(v);
h=1.06*std(v)/nn^0.2;
g=0;

j=1;
for j=1:nn
    g=[g; mean(normpdf((v-v(j))/h))/h];
    j=j+1;
end
a=[v,g(2:nn+1)];
res=sortrows(a,1);
xx=res(:,1);
den=res(:,2);

