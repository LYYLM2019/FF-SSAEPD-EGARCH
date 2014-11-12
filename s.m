beta1=2;
beta2=3;
sigma=1;
x=rand([1000,1]);
ut=randn([1000,1]);
y=beta1+beta2*x+ut;
[a1,a2,a3,a4]=mvnrmle(y,[ones(size(x)) x]);
a1
a2
a3
a4
