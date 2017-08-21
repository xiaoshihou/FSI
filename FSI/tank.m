function tank(BCIndex,time,cnt,h,q,u,f,ar )
%TANK �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% �������
% BCIndex - BC������ĳЩ�߽������ı��
% time - used as input parameter in the boundary conditions tank and valve
global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp up fp BC
    tank_value=h_def{BCIndex,2};
    pipe1 = BC{BCIndex,3}; %����ǰ�Ĺ�·���
    pipe2 = BC{BCIndex,4}; %�����Ĺ�·���
    %��������е�ѹ�����ǳ����������ڲ�
    if length(BC{BCIndex,5}) > 1
        disc=load(BC{BCIndex,2});%load��ɢѹ��ֵ
        tVector = disc(:,1); %ʱ������
        PVector = disc(:,2); %ѹ������
        H_tank = interp1(tVector,PVector,time,'spline',tank_value); %��������е�ѹ�����ǳ����������ڲ�
    else
        H_tank = BC{BCIndex,5};
    end
    %%����λ�ڹ�·�����ֲ�
if pipe1 == 0
    hres=H_tank;%ˮ����Ի�׼���ѹͷ
    hp(pipe2,1)=hres;%�ٶ�ˮ���ѹͷ����
    up(pipe2,1)=0;%ˮ��ڵ���ٶ�Ϊ0
    
    
    cnf(pipe2)=xi_f_p*h(pipe2,2)-xi_f_V*q(pipe2,2)/ar(pipe2)-xi_f_theta*f(pipe2,2)-xi_f_U*u(pipe2,2);
    cns(pipe2)=-(xi_s_p*h(pipe2,4))+xi_s_V*q(pipe2,4)/ar(pipe2)-xi_s_theta*f(pipe2,4)-xi_s_U*u(pipe2,4);
    
    %cn_res=q(pipe2,2)-h(pipe2,2)*ca(pipe2)-cf(pipe2)*q(pipe2,2)*abs(q(pipe2,2));
    qp(pipe2,1)=ar(pipe2)*((xi_f_p/xi_f_theta+xi_s_p/xi_s_theta)*hres-cnf/xi_f_theta+cns/xi_s_theta)/(xi_f_V/xi_f_theta+xi_s_V/xi_s_theta);
    fp(pipe2,1)=((xi_f_p/xi_f_V-xi_s_p/xi_s_V)*hres-cnf(pipe2)/xi_f_V-cns(pipe2)/xi_s_V)/(xi_f_theta/xi_f_V+xi_s_theta/xi_s_V);
    %qp(pipe2,1)=cn_res+ca(pipe2)*hp(pipe2,1);
    %%%%%%%%%%%%%���¾���%%%%%%%%%%%%%
    pressure{cnt+1,3}(pipe2,1)=hp(pipe2,1);%�����һ���ڵ��ѹͷ
    discharge{cnt+1,3}(pipe2,1)=qp(pipe2,1);%�����һ���ڵ������

    %%����λ�ڹ�·�����ֲ�
elseif pipe2 == 0
    nodes = nn(pipe1); %��·�Ľڵ���
    hp(pipe1,nodes)=H_tank;
    up(pipe1,nodes)=0;
    cps(pipe1)=xi_s_p*h(pipe1,nodes-3)+xi_s_V*q(pipe1,nodes-3)/ar(pipe1)+xi_s_theta*f(pipe1,nodes-3)-xi_s_U*u(pipe1,nodes-3);
    cpf(pipe1)=-(xi_f_p*h(pipe1,nodes-1))-xi_f_V*q(pipe1,nodes-1)/ar(pipe1)+xi_f_theta*f(pipe1,nodes-1)-xi_f_U*u(pipe1,nodes-1);
    qp(pipe1,nodes)=ar(pipe1)*((cps(pipe1)/xi_s_theta-cpf(pipe1)/xi_f_theta-(xi_f_p/xi_f_theta+xi_s_p/xi_s_theta)*hp(pipe1,nodes))/(xi_f_V/xi_f_theta+xi_s_V+xi_s_theta));
    fp(pipe1,nodes)=((xi_f_p/xi_f_V-xi_s_p/xi_s_V)*hp(pipe1,nodes)+cpf(pipe1)/xi_f_V+cps(pipe1)/xi_s_V)/(xi_f_theta/xi_f_V+xi_s_theta/xi_s_V);
    %cp_res=q(pipe1,nodes-1)+h(pipe1,nodes-1)*ca(pipe1)-cf(pipe1)*q(pipe1,nodes-1)*abs(q(pipe1,nodes-1));
    %qp(pipe1,nodes)=cp_res-ca(pipe1)*hp(pipe1,nodes);
    
%%%%%%%%%%%%%%%%%%%%%%  ���¹�·���� %%%%%%%%%%%%%%%%%%%%%%%%%%
    pressure{cnt+1,3}(pipe1,nodes)=hp(pipe1,nodes);%�����һ���ڵ��ѹͷ
    discharge{cnt+1,3}(pipe1,nodes)=qp(pipe1,nodes);%�����һ���ڵ������
end
    
  
    
end

