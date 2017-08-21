function valve(BCIndex,t,cnt,q,h,hs )
%VALVE 返回的应该是阀门前后相连的两个管道节点的流量和压力
%   但是此函数用于计算下游阀门直接与外界相连，后面无其他管道的情况，最后一段管道的最后一个节点的流量和压头
% 输入变量
% BCIndex - BC矩阵中某些边界条件的编号
% time - used as input parameter in the boundary conditions tank and valve
 %下游阀门，最后一段管道的最后一个节点的流量和压头
 global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp BC  
 pipe1 = BC{BCIndex,9}; %阀门前的管路编号
 pipe2 = BC{BCIndex,10}; %阀门后的管路编号
 nodes1 = nn(pipe1); %pipe1的节点数
 %如果开口不是常数，则内插，得到的是实时的开度值
 if length(BC{BCIndex,12}) > 1
     disc=load (BC{BCIndex,11});%load离散开度值
     time = disc(:,1); %时间向量
     tau = disc(:,2); %向量: 阀门的开口量
     tau1 = interp1(time,tau,t,'spline',0); %spine平滑效果好，对于超出边界的设置为0
 %如果tau为常数
 else
     tau1 = BC{BCIndex,12};
 end
 
 
 
     dt=t_def{1,3};%时间间隔
     tlast=t_def{1,2};%总时间
     np=size(pipe,1);%管道总数
     nm1=n(pipe1);%最后一根管道的分段数
     tv=BC{BCIndex,7};%阀门开闭时刻
     tau0=BC{BCIndex,3};%阀门初始开度
     tauf=BC{BCIndex,4};%阀门最后开度
     qs=BC{BCIndex,6};%阀门的流量
     q0=q_def{1,2};%稳态流量
     cp_val=q(pipe1,nm1)+ca(pipe1)*h(pipe1,nm1)-cf(pipe1)*q(pipe1,nm1)*abs(q(pipe1,nm1));%最后一段管道的cp_val
     

    
    
    
    if (t>=tv)  %tv为阀门关闭时刻
        tau=tauf;%将最后的阀门开度赋给tau
        if (tau<=0)
            qp(pipe1,nn(pipe1))=0;%如果阀门开度小于等于0，则最后节点的流量为0
            hp(pipe1,nn(pipe1))=cp_val/ca(pipe1);%如果阀门开度小于等于0，流量为0，带入
        else
            cv=(qs*tau1)^2/hs/ca(pipe1);
            qp(pipe1,nn(pipe1))=0.5*(-cv+sqrt(cv*cv+4*cp_val*cv));%阀门前节点流量
            hp(pipe1,nn(pipe1))=(cp_val-qp(pipe1,nn(pipe1)))/ca(pipe1);%阀门前节点压力
        end
        
    else
       
        cv=(qs*tau1)^2/hs/ca(pipe1);
        qp(pipe1,nn(pipe1))=0.5*(-cv+sqrt(cv*cv+4*cp_val*cv));%阀门前节点流量
        hp(pipe1,nn(pipe1))=(cp_val-qp(pipe1,nn(pipe1)))/ca(pipe1);%阀门前节点压力

    end
        %%%%%%%%%%%%%更新矩阵%%%%%%%%%%%%%
        
        pressure{cnt+1,3}(pipe1,nn(pipe1))=hp(pipe1,nn(pipe1));%last pipe最后一个节点的压头
        discharge{cnt+1,3}(pipe1,nn(pipe1))=qp(pipe1,nn(pipe1));%last pipe最后一个节点的流量
        
        
       qs=Valve{1,6};%阀门的流量
       hres=h_def{1,2};
           %计算每次迭代后最后节点相对于阀门基准的压头和流量百分数hn qn,存放在pressure和discharge第四列中
    if np~=1
        hn=h(np,nn(np))/hres;%压头比值相对于水库基准
        qn=q(np,nn(np))/qs;%流量比值相对于阀门初始基准
        pressure{cnt,4}=hn;
        discharge{cnt,4}=qn;
    end
end

