function valve2(BCIndex,t,cnt,q,h,hs,u,f,ar )
%VALVE2 计算阀门前后两个节点的压力和流量，假如经过阀门的流量和压力不变，等同于valve的方法
%   计算两个管道之间的阀门的情况
%这种情况可以视为管道面积的突然变化
% 输入变量
% BCIndex - BC矩阵中某些边界条件的编号
% time - used as input parameter in the boundary conditions tank and valve

 global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp up fp BC f_R  
 g=9.81;
 dt=t_def{1,3};%时间间隔
 tlast=t_def{1,2};%总时间
 np=size(pipe,1);%管道总数
 tv=BC{BCIndex,7};%阀门开闭时刻
 tau0=BC{BCIndex,3};%阀门初始开度
 tauf=BC{BCIndex,4};%阀门最后开度
 qs=BC{BCIndex,6};%阀门的流量
 q0=q_def{1,2};%稳态流量
 np=size(pipe,1);%管道总数
 pipe1 = BC{BCIndex,9}; %阀门前的管路编号
 pipe2 = BC{BCIndex,10}; %阀门后的管路编号
 nm1=n(pipe1);%最后一根管道的分段数
 nodes1 = nn(pipe1); %pipe1的节点数
 %如果开口不是常数，则内插，得到的是实时的开度值
 if length(BC{BCIndex,12}) > 1
     disc=load (BC{BCIndex,11});%load离散开度值
     time = disc(:,1); %时间向量
     tau = disc(:,2); %向量: 阀门的开口量
     tau1 = interp1(time,tau,t,'spline',tauf); %spine平滑效果好，对于超出边界的设置为tauf,最后的开度值
 %如果tau为常数
 else
     tau1 = BC{BCIndex,12};
 end

M=6;%阀门的质量
v=0.33;%泊松比
A_f;%流体横截面积
A_s;%管道横截面积
p0=h(pipe1,nodes1+1);%p0为稳态时阀门的压头值 
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
%      cp_val=q(pipe1,nm1)+ca(pipe1)*h(pipe1,nm1)-cf(pipe1)*q(pipe1,nm1)*abs(q(pipe1,nm1));%阀门前管道pipe1的cp_val
%      cn_val=q(pipe2,2)-ca(pipe2)*h(pipe2,2)-cf(pipe2)*q(pipe2,2)*abs(q(pipe2,2));%阀门后管道pipe2的cn_val
% 	 
% 	    cv=(qs*tau1)^2/hs/ca(pipe1);
% 		%假如经过阀门的流量和压力不变
%         qp(pipe1,nn(pipe1))=0.5*(-cv+sqrt(cv*cv+4*cp_val*cv));%阀门前节点流量
%         hp(pipe1,nn(pipe1))=(cp_val-qp(pipe1,nn(pipe1)))/ca(pipe1);%阀门前节点压力
% 		qp(pipe2,1)=qp(pipe1,nn(pipe1));
% 		hp(pipe2,1)=hp(pipe1,nn(pipe1));

    
        %%%%%%%%%%%%%更新矩阵%%%%%%%%%%%%%
        
        pressure{cnt+1,3}(pipe1,nn(pipe1))=hp(pipe1,nn(pipe1));%last pipe第一个节点的压头，相连的管道压头相等
        discharge{cnt+1,3}(pipe1,nn(pipe1))=qp(pipe1,nn(pipe1));%first pipe最后一个节点的流量
        pressure{cnt+1,3}(pipe2,1)=hp(pipe2,1);%last pipe第一个节点的压头，相连的管道压头相等
        discharge{cnt+1,3}(pipe2,1)=qp(pipe2,1);%first pipe最后一个节点的流量
        
   

end

