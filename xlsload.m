function [data1,data2]=xlsload(i)
    switch i
    % Overall Sheet1 B2:E1027       Sheet2 B3:Z1028
        %Sample 1(1926.07-1965.10)=Workbook1(2-473)&Workbook(3-474)
        case {1} 
            data1=xlsread('FF-25-portfolio',1,'B2:E437');
            data2=xlsread('FF-25-portfolio',2,'B3:Z438');
        %Sample 2(1965.11-2011.12)=Workbook1(474-1027)&Workbook(475-1028)
        case {2}
            data1=xlsread('FF-25-portfolio',1,'B474:E1027');
            data2=xlsread('FF-25-portfolio',2,'B475:Z1028');
        %Sample 3(1926.07-1970.10)=Workbook1(2-533)&Workbook(3-534)
        case {3}
            data1=xlsread('FF-25-portfolio',1,'B2:E533');
            data2=xlsread('FF-25-portfolio',2,'B3:Z534');
        %Sample 4(1970.11-2011.12)=Workbook1(534-1027)&Workbook(535-1028)
        case {4}
            data1=xlsread('FF-25-portfolio',1,'B534:E1027');
            data2=xlsread('FF-25-portfolio',2,'B535:Z1028');
        %Sample 5(1926.07-1985.10)=Workbook1(2-713)&Workbook(3-714)
        case {5}
            data1=xlsread('FF-25-portfolio',1,'B2:E713');
            data2=xlsread('FF-25-portfolio',2,'B3:Z714');
        %Sample 6(1985.11-2011.12)=Workbook1(714-1027)&Workbook(715-1028)
        case {6}
            data1=xlsread('FF-25-portfolio',1,'B714:E1027');
            data2=xlsread('FF-25-portfolio',2,'B715:Z1028');           
    end;        
end