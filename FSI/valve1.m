function valve1(BCIndex,t,cnt,q,h,hs )
%VALVE1 计算阀门前后两个节点的压力和流量,论文中的方法
%   计算两个管道之间的阀门的情况
%这种情况可以视为管道面积的突然变化
% 输入变量
% BCIndex - BC矩阵中某些边界条件的编号
% time - used as input parameter in the boundary conditions tank and valve

 global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp BC f_R  
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
 
 
 

     cp_val=q(pipe1,nm1)+ca(pipe1)*h(pipe1,nm1)-cf(pipe1)*q(pipe1,nm1)*abs(q(pipe1,nm1));%阀门前管道pipe1的cp_val
     cn_val=q(pipe2,2)-ca(pipe2)*h(pipe2,2)-cf(pipe2)*q(pipe2,2)*abs(q(pipe2,2));%阀门后管道pipe2的cn_val
     
    Di=pipe{pipe2,6};%pipe2的内径
    
    A_lv=(pi()*Di^2/4)*tau1;%求出pipe2的相对截面积
    
    
        a=ca(pipe1)*ca(pipe2)/2/g/A_lv^2;
        b=ca(pipe1)+ca(pipe2);
        c=-(ca(pipe1)*cn_val+ca(pipe2)*cp_val);
 
    
    
    if tau1<=0||a==Inf
        qp(pipe1,nn(pipe1))=0;
        qp(pipe2,1)=0;
    else
        qp(pipe1,nn(pipe1))=-b/(2*a)+sqrt((b/(2*a))^2-c/a);
        qp(pipe2,1)=qp(pipe1,nn(pipe1));
    end
    
    hp(pipe1,nn(pipe1))=(cp_val-qp(pipe1,nn(pipe1)))/ca(pipe1);
    hp(pipe2,1)=(qp(pipe1,nn(pipe1))-cn_val)/ca(pipe2);
    
    
        %%%%%%%%%%%%%更新矩阵%%%%%%%%%%%%%
        
        pressure{cnt+1,3}(pipe1,nn(pipe1))=hp(pipe1,nn(pipe1));%last pipe第一个节点的压头，相连的管道压头相等
        discharge{cnt+1,3}(pipe1,nn(pipe1))=qp(pipe1,nn(pipe1));%first pipe最后一个节点的流量
        pressure{cnt+1,3}(pipe2,1)=hp(pipe2,1);%last pipe第一个节点的压头，相连的管道压头相等
        discharge{cnt+1,3}(pipe2,1)=qp(pipe2,1);%first pipe最后一个节点的流量
        
   

end

