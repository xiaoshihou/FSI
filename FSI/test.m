% %第一种方法
% x=0:1:6;
% xi=0:0.25:30;
% y=[1 0.9 0.7 0.5 0.3 0.1 0];
% yi=interp1(x,y,xi,'spline',0);%spine平滑效果好，对于超出边界的设置为0
% n=1;%取出每次迭代时刻阀门的流量值
% tau=yi(n);


%第二种方法
global BC
BCIndex=2;
 if length(BC{BCIndex,12}) > 1
     disc=load (BC{BCIndex,11});%load离散开度值
     time = disc(:,1); %时间向量
     tau = disc(:,2); %向量: 阀门的开口量
     tau1 = interp1(time,tau,0.5,'spline',0); %spine平滑效果好，对于超出边界的设置为0
 %如果tau为常数
 else
     tau1 = BC{BCIndex,12};
 end