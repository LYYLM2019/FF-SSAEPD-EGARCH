function [Ezt] = funEzt(zt,n)
%get Ezt
%use in G(zt-1)=czt-1+d[/zt-1/-E/zt-1/]

 allzt=0;
for j=1:n
    
 if zt(j,1)<0
    allzt=allzt-zt(j,1);
 else
    allzt=allzt+zt(j,1);
 end
 
end
Ezt=allzt/n;


