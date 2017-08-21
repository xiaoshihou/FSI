function  pipe_junc(BCIndex,cnt,h,q,u,f,ar )
%pipe_junc -计算两根相连管路的压力头和流量
%   此处显示详细说明
% 输入变量
% BCIndex - the index of the certain boundary condition in the BC-matrix

global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp up fp BC
np=size(pipe,1);%管道总数
if(np~=1)
    %两个管道连接处junction,前一个管道最后节点和接着管道第一个节点
    pipe1 = BC{BCIndex,2}; %管路接头前的管路编号
    pipe2 = BC{BCIndex,3}; %管路接头后的管路编号
    %cn(pipe2)=q(pipe2,2)-ca(pipe2)*h(pipe2,2)-cf(pipe2)*q(pipe2,2)*abs(q(pipe2,2));
    %cp(pipe1)=q(pipe1,n(pipe1))+ca(pipe1)*h(pipe1,n(pipe1))-cf(pipe1)*q(pipe1,n(pipe1))*abs(q(pipe1,n(pipe1)));
    %hp(pipe1,nn(pipe1))=(cp(pipe1)-cn(pipe2))/(ca(pipe1)+ca(pipe2));%first pipe最后一个节点的压头
    
%     %2017-1-11增加判断压力值的正负
%     if hp(pipe1,nn(pipe1))<0
%         hp(pipe1,nn(pipe1))=0;
%     end
%     %2017-1-11增加判断压力值的正负
    
    
    
    
    %hp(pipe2,1)=hp(pipe1,nn(pipe1));%last pipe第一个节点的压头，相连的管道压头相等
    
    
    
    
    
    %qp(pipe1,nn(pipe1))=cp(pipe1)-ca(pipe1)*hp(pipe1,nn(pipe1));%first pipe最后一个节点的流量
    %qp(pipe2,1)=cn(pipe2)+ca(pipe2)*hp(pipe2,1);%last pipe第一个节点的流量
    cpf(pipe1)=-(xi_f_p*h(pipe1,nn(pipe1)))-xi_f_V*q(i,jm1)/ar(i)+xi_f_theta*f(i,jm1)-xi_f_U*u(i,jm1);
    %cnf(pipe1)=xi_f_p*h(i,jp1)-xi_f_V*q(i,jp1)/ar(i)-xi_f_theta*f(i,jp1)-xi_f_U*u(i,jp1);
    cps(pipe1)=xi_s_p*h(i,jm1-2)+xi_s_V*q(i,jm1-2)/ar(i)+xi_s_theta*f(i,jm1-2)-xi_s_U*u(i,jm1-2);
    %cns(pipe1)=-(xi_s_p*h(i,jp1+2))+xi_s_V*q(i,jp1+2)/ar(i)-xi_s_theta*f(i,jp1+2)-xi_s_U*u(i,jp1+2);
    
    %%%%%%%%%%%%不考虑损失，四个变量的值全部相等%%%%%%%%%%%%
    hp(pipe1,nn(pipe1))=hp(pipe2,1);
    qp(pipe1,nn(pipe1))=qp(pipe2,1);
    fp(pipe1,nn(pipe1))=fp(pipe2,1);
    up(pipe1,nn(pipe1))=up(pipe2,1);
    %%%%%%%%%%%%不考虑损失，四个变量的值全部相等%%%%%%%%%%%%
   
    
    %%%%%%%%%%%%%更新矩阵%%%%%%%%%%%%%
    
   
                    
                    
    pressure{cnt+1,3}(pipe1,nn(pipe1))=hp(pipe1,nn(pipe1));%first pipe最后一个节点的压头
    pressure{cnt+1,3}(pipe2,1)=hp(pipe2,1);%last pipe第一个节点的压头，相连的管道压头相等
    discharge{cnt+1,3}(pipe1,nn(pipe1))=qp(pipe1,nn(pipe1));%first pipe最后一个节点的流量
    discharge{cnt+1,3}(pipe2,1)=qp(pipe2,1);%last pipe第一个节点的流量
end

end

