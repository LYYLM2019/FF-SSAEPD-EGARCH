%MLE to estimate parameters to Model:FF3F-SSAEPD-EGARCH based on FF database
%%% FF-3F-SSAEPD-EGARCH
% rt-rft=bt1+bt2(rmt-rft)+bt3SMBt+bt4HMLt+ut
% ut=sigamt.zt, zt~SSAEPD(alpha,p1,p2)
% ln(sigmat^2)=a0+G(zt)+b1ln(sigamt-1^2)
% G(zt-1)=czt-1+d[/zt-1/-E/zt-1/]
%Created on 2012-9-14 by yanjia yang

clc;
clear;
data1=xlsread('FF-25-portfolio',1,'B2:E1027');
data2=xlsread('FF-25-portfolio',2,'B3:Z1028');
t=[1965 1970 1985];
n=length(data2(:,1));


 for i=3:3
    disp('t=');disp(t(i));
    Mean=zeros(5,5);
    Median=zeros(5,5);
    Maximum=zeros(5,5);
    Minimum=zeros(5,5);
    Std=zeros(5,5);
    Skewness=zeros(5,5);
    Kurtosis=zeros(5,5);
    PVJB=zeros(5,5);
    mid=6+(t(i)-1927)*12;
    data=zeros(n);
    s=[1 mid+1];
    e=[mid n];
     for j=1:1
        for k=1:5
            for l=1:5
                col=(k-1)*5+l;
                data=data2(s(j):e(j),col);
                Mean(k,l)=mean(data);
                Median(k,l)=median(data);
                Maximum(k,l)=max(data);
                Minimum(k,l)=min(data);
                Std(k,l)=std(data);
                Skewness(k,l)=skewness(data);
                Kurtosis(k,l)=kurtosis(data);
                [h,p]=jbtest(data);
                PVJB(k,l)=p;     
            end
        end
        disp(Mean);
        disp(Median);
        disp(Maximum);
        disp(Minimum);
        disp(Std);
        disp(Skewness);
        disp(Kurtosis);
        disp(PVJB);
     end 
 end
load splat
sound(y,Fs)