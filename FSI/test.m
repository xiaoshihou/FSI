% %��һ�ַ���
% x=0:1:6;
% xi=0:0.25:30;
% y=[1 0.9 0.7 0.5 0.3 0.1 0];
% yi=interp1(x,y,xi,'spline',0);%spineƽ��Ч���ã����ڳ����߽������Ϊ0
% n=1;%ȡ��ÿ�ε���ʱ�̷��ŵ�����ֵ
% tau=yi(n);


%�ڶ��ַ���
global BC
BCIndex=2;
 if length(BC{BCIndex,12}) > 1
     disc=load (BC{BCIndex,11});%load��ɢ����ֵ
     time = disc(:,1); %ʱ������
     tau = disc(:,2); %����: ���ŵĿ�����
     tau1 = interp1(time,tau,0.5,'spline',0); %spineƽ��Ч���ã����ڳ����߽������Ϊ0
 %���tauΪ����
 else
     tau1 = BC{BCIndex,12};
 end