function [ tau ] = parab(t,dt,tlast,m_valve,y)
%PARAB ���ø����ķ�����ɢ����ֵʵ�ֲ�ֵ����
%����interp1�е�method�����õ���ͬ�Ĳ�ֵ

%����ֵ��1��ÿ�ε���ʱ�̵ķ��ſ���ֵ 2��ʱ��

%[p_num_def, pipe,valve,valve_val,t_def,q_def,h_def] = getInputFluid();

%if����ж��ǵڼ�������

%if ()
x=0:1:m_valve-1;
xi=0:dt:tlast;
yi=interp1(x,y,xi,'spline',0);%spineƽ��Ч���ã����ڳ����߽������Ϊ0
n=t/dt;%ȡ��ÿ�ε���ʱ�̷��ŵ�����ֵ
tau=yi(n);

end

%end