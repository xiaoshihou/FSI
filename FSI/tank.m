function tank(BCIndex,time,cnt,h,q,u,f,ar )
%TANK 此处显示有关此函数的摘要
%   此处显示详细说明
% 输入变量
% BCIndex - BC矩阵中某些边界条件的编号
% time - used as input parameter in the boundary conditions tank and valve
global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp up fp BC
    tank_value=h_def{BCIndex,2};
    pipe1 = BC{BCIndex,3}; %油箱前的管路编号
    pipe2 = BC{BCIndex,4}; %油箱后的管路编号
    %如果油箱中的压力不是常数，进行内插
    if length(BC{BCIndex,5}) > 1
        disc=load(BC{BCIndex,2});%load离散压力值
        tVector = disc(:,1); %时间向量
        PVector = disc(:,2); %压力向量
        H_tank = interp1(tVector,PVector,time,'spline',tank_value); %如果油箱中的压力不是常数，进行内插
    else
        H_tank = BC{BCIndex,5};
    end
    %%油箱位于管路的左手侧
if pipe1 == 0
    hres=H_tank;%水库相对基准面的压头
    hp(pipe2,1)=hres;%假定水库的压头不变
    up(pipe2,1)=0;%水库节点的速度为0
    
    
    cnf(pipe2)=xi_f_p*h(pipe2,2)-xi_f_V*q(pipe2,2)/ar(pipe2)-xi_f_theta*f(pipe2,2)-xi_f_U*u(pipe2,2);
    cns(pipe2)=-(xi_s_p*h(pipe2,4))+xi_s_V*q(pipe2,4)/ar(pipe2)-xi_s_theta*f(pipe2,4)-xi_s_U*u(pipe2,4);
    
    %cn_res=q(pipe2,2)-h(pipe2,2)*ca(pipe2)-cf(pipe2)*q(pipe2,2)*abs(q(pipe2,2));
    qp(pipe2,1)=ar(pipe2)*((xi_f_p/xi_f_theta+xi_s_p/xi_s_theta)*hres-cnf/xi_f_theta+cns/xi_s_theta)/(xi_f_V/xi_f_theta+xi_s_V/xi_s_theta);
    fp(pipe2,1)=((xi_f_p/xi_f_V-xi_s_p/xi_s_V)*hres-cnf(pipe2)/xi_f_V-cns(pipe2)/xi_s_V)/(xi_f_theta/xi_f_V+xi_s_theta/xi_s_V);
    %qp(pipe2,1)=cn_res+ca(pipe2)*hp(pipe2,1);
    %%%%%%%%%%%%%更新矩阵%%%%%%%%%%%%%
    pressure{cnt+1,3}(pipe2,1)=hp(pipe2,1);%计算第一个节点的压头
    discharge{cnt+1,3}(pipe2,1)=qp(pipe2,1);%计算第一个节点的流量

    %%油箱位于管路的右手侧
elseif pipe2 == 0
    nodes = nn(pipe1); %管路的节点数
    hp(pipe1,nodes)=H_tank;
    up(pipe1,nodes)=0;
    cps(pipe1)=xi_s_p*h(pipe1,nodes-3)+xi_s_V*q(pipe1,nodes-3)/ar(pipe1)+xi_s_theta*f(pipe1,nodes-3)-xi_s_U*u(pipe1,nodes-3);
    cpf(pipe1)=-(xi_f_p*h(pipe1,nodes-1))-xi_f_V*q(pipe1,nodes-1)/ar(pipe1)+xi_f_theta*f(pipe1,nodes-1)-xi_f_U*u(pipe1,nodes-1);
    qp(pipe1,nodes)=ar(pipe1)*((cps(pipe1)/xi_s_theta-cpf(pipe1)/xi_f_theta-(xi_f_p/xi_f_theta+xi_s_p/xi_s_theta)*hp(pipe1,nodes))/(xi_f_V/xi_f_theta+xi_s_V+xi_s_theta));
    fp(pipe1,nodes)=((xi_f_p/xi_f_V-xi_s_p/xi_s_V)*hp(pipe1,nodes)+cpf(pipe1)/xi_f_V+cps(pipe1)/xi_s_V)/(xi_f_theta/xi_f_V+xi_s_theta/xi_s_V);
    %cp_res=q(pipe1,nodes-1)+h(pipe1,nodes-1)*ca(pipe1)-cf(pipe1)*q(pipe1,nodes-1)*abs(q(pipe1,nodes-1));
    %qp(pipe1,nodes)=cp_res-ca(pipe1)*hp(pipe1,nodes);
    
%%%%%%%%%%%%%%%%%%%%%%  更新管路矩阵 %%%%%%%%%%%%%%%%%%%%%%%%%%
    pressure{cnt+1,3}(pipe1,nodes)=hp(pipe1,nodes);%计算第一个节点的压头
    discharge{cnt+1,3}(pipe1,nodes)=qp(pipe1,nodes);%计算第一个节点的流量
end
    
  
    
end

