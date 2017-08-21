function [ tau ] = parab(t,dt,tlast,m_valve,y)
%PARAB 利用给定的阀门离散开度值实现插值运算
%根据interp1中的method方法得到不同的插值

%返回值：1、每次迭代时刻的阀门开度值 2、时刻

%[p_num_def, pipe,valve,valve_val,t_def,q_def,h_def] = getInputFluid();

%if语句判断是第几个阀门

%if ()
x=0:1:m_valve-1;
xi=0:dt:tlast;
yi=interp1(x,y,xi,'spline',0);%spine平滑效果好，对于超出边界的设置为0
n=t/dt;%取出每次迭代时刻阀门的流量值
tau=yi(n);

end

%end