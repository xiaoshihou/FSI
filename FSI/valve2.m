function valve2(BCIndex,t,cnt,q,h,hs,u,f,ar )
%VALVE2 ���㷧��ǰ�������ڵ��ѹ�������������羭�����ŵ�������ѹ�����䣬��ͬ��valve�ķ���
%   ���������ܵ�֮��ķ��ŵ����
%�������������Ϊ�ܵ������ͻȻ�仯
% �������
% BCIndex - BC������ĳЩ�߽������ı��
% time - used as input parameter in the boundary conditions tank and valve

 global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp up fp BC f_R  
 g=9.81;
 dt=t_def{1,3};%ʱ����
 tlast=t_def{1,2};%��ʱ��
 np=size(pipe,1);%�ܵ�����
 tv=BC{BCIndex,7};%���ſ���ʱ��
 tau0=BC{BCIndex,3};%���ų�ʼ����
 tauf=BC{BCIndex,4};%������󿪶�
 qs=BC{BCIndex,6};%���ŵ�����
 q0=q_def{1,2};%��̬����
 np=size(pipe,1);%�ܵ�����
 pipe1 = BC{BCIndex,9}; %����ǰ�Ĺ�·���
 pipe2 = BC{BCIndex,10}; %���ź�Ĺ�·���
 nm1=n(pipe1);%���һ���ܵ��ķֶ���
 nodes1 = nn(pipe1); %pipe1�Ľڵ���
 %������ڲ��ǳ��������ڲ壬�õ�����ʵʱ�Ŀ���ֵ
 if length(BC{BCIndex,12}) > 1
     disc=load (BC{BCIndex,11});%load��ɢ����ֵ
     time = disc(:,1); %ʱ������
     tau = disc(:,2); %����: ���ŵĿ�����
     tau1 = interp1(time,tau,t,'spline',tauf); %spineƽ��Ч���ã����ڳ����߽������Ϊtauf,���Ŀ���ֵ
 %���tauΪ����
 else
     tau1 = BC{BCIndex,12};
 end

M=6;%���ŵ�����
v=0.33;%���ɱ�
A_f;%���������
A_s;%�ܵ�������
p0=h(pipe1,nodes1+1);%p0Ϊ��̬ʱ���ŵ�ѹͷֵ 
cpf(pipe1)=-(xi_f_p*h(pipe1,nodes1-1))-xi_f_V*q(pipe1,nodes1-1)/ar(pipe1)+xi_f_theta*f(pipe1,nodes1-1)-xi_f_U*u(pipe1,nodes1-1);
cps(pipe1)=xi_s_p*h(pipe1,nodes1-3)+xi_s_V*q(pipe1,nodes1-3)/ar(pipe1)+xi_s_theta*f(pipe1,nodes1-3)-xi_s_U*u(pipe1,nodes1-3);
a=(-A_f/A_s*p0*xi_f_theta+M*v/A_s/dt*u(pipe1,nn(pipe1)-1)*xi_f_theta-cpf(pipe1))/(xi_f_V+M*v*xi_f_theta/A_s/dt+xi_f_U);
b=(-A_f/A_s*p0*xi_s_theta+M*v/A_s/dt*u(pipe1,nn(pipe1)-1)*xi_s_theta-cps(pipe1))/(-xi_s_V+M*v*xi_s_theta/A_s/dt+xi_s_U);
c=(xi_f_p-A_f*xi_f_theta/A_s)/(xi_f_V+M*v*xi_f_theta/A_s/dt+xi_f_U);
d=(-xi_s_p-A_f*xi_s_theta/A_s)/(-xi_s_V+M*v*xi_s_theta/A_s/dt+xi_s_U);

hp(pipe1,nn(pipe1))=(a-b)/(c-d);
hp(pipe2,1)=hp(pipe1,nn(pipe1));

a1=(-A_f/A_s*p0*xi_f_theta+M*v/A_s/dt*u(pipe1,nn(pipe1)-1)*xi_f_theta-cpf(pipe1))/(xi_f_p-A_f*xi_f_theta/A_s);
b1=(-A_f/A_s*p0*xi_s_theta+M*v/A_s/dt*u(pipe1,nn(pipe1)-1)*xi_s_theta-cps(pipe1))/(-xi_s_p-A_f*xi_s_theta/A_s);
c1=1/c;
d1=1/d;

up(pipe1,nn(pipe1))=(a1-b1)/(c1-d1);
up(pipe2,1)=up(pipe1,nn(pipe1));

qp(pipe1,nn(pipe1))=up(pipe1,nn(pipe1))*ar(pipe1);
qp(pipe2,1)=qp(pipe1,nn(pipe1));

fp(pipe1,nn(pipe1))=A_f*(1-tau1)*(hp(pipe1,nn(pipe1))-p0)-M*v*(up(pipe1,nn(pipe1))-u(pipe1,nn(pipe1)))/dt;
%      cp_val=q(pipe1,nm1)+ca(pipe1)*h(pipe1,nm1)-cf(pipe1)*q(pipe1,nm1)*abs(q(pipe1,nm1));%����ǰ�ܵ�pipe1��cp_val
%      cn_val=q(pipe2,2)-ca(pipe2)*h(pipe2,2)-cf(pipe2)*q(pipe2,2)*abs(q(pipe2,2));%���ź�ܵ�pipe2��cn_val
% 	 
% 	    cv=(qs*tau1)^2/hs/ca(pipe1);
% 		%���羭�����ŵ�������ѹ������
%         qp(pipe1,nn(pipe1))=0.5*(-cv+sqrt(cv*cv+4*cp_val*cv));%����ǰ�ڵ�����
%         hp(pipe1,nn(pipe1))=(cp_val-qp(pipe1,nn(pipe1)))/ca(pipe1);%����ǰ�ڵ�ѹ��
% 		qp(pipe2,1)=qp(pipe1,nn(pipe1));
% 		hp(pipe2,1)=hp(pipe1,nn(pipe1));

    
        %%%%%%%%%%%%%���¾���%%%%%%%%%%%%%
        
        pressure{cnt+1,3}(pipe1,nn(pipe1))=hp(pipe1,nn(pipe1));%last pipe��һ���ڵ��ѹͷ�������Ĺܵ�ѹͷ���
        discharge{cnt+1,3}(pipe1,nn(pipe1))=qp(pipe1,nn(pipe1));%first pipe���һ���ڵ������
        pressure{cnt+1,3}(pipe2,1)=hp(pipe2,1);%last pipe��һ���ڵ��ѹͷ�������Ĺܵ�ѹͷ���
        discharge{cnt+1,3}(pipe2,1)=qp(pipe2,1);%first pipe���һ���ڵ������
        
   

end

