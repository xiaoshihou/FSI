function deadend( BCIndex,time,cnt,h,q  )
%deadend 此处显示有关此函数的摘要
%   此处显示详细说明
% BCIndex - BC矩阵中某些边界条件的编号
% time - used as input parameter in the boundary conditions tank and valve
global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp BC
    pipe1 = BC{BCIndex,3}; %终端前的管路编号
    pipe2 = BC{BCIndex,4}; %终端后的管路编号
    if pipe1==0 %终端位于上游侧
        cn_end=q(pipe2,2)-ca(pipe2)*h(pipe2,2)-cf(pipe2)*q(pipe2,2)*abs(q(pipe2,2));
        qp(pipe2,1)=0;
        hp(pipe2,1)=-(cn_end/ca(pipe2));
            %%%%%%%%%%%%%更新矩阵%%%%%%%%%%%%%
    pressure{cnt+1,3}(pipe2,1)=hp(pipe2,1);%计算第一个节点的压头
    discharge{cnt+1,3}(pipe2,1)=qp(pipe2,1);%计算第一个节点的流量
    elseif pipe2==0 %终端位于下游侧
        cp_end=q(pipe1,n(pipe1))+ca(pipe1)*h(pipe1,n(pipe1))-cf(pipe1)*q(pipe1,n(pipe1))*abs(q(pipe1,n(pipe1)));
        qp(pipe1,nn(pipe1))=0;
        hp(pipe1,nn(pipe1))=cp_end/ca(pipe1);
        %%%%%%%%%%%%%%%%%%%%%%  更新管路矩阵 %%%%%%%%%%%%%%%%%%%%%%%%%%
    pressure{cnt+1,3}(pipe1,nn(pipe1))=hp(pipe1,nn(pipe1));%计算第一个节点的压头
    discharge{cnt+1,3}(pipe1,nn(pipe1))=qp(pipe1,nn(pipe1));%计算第一个节点的流量
    end
        
end

