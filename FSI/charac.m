function charac( nr_of_tsteps,time,cnt,h,q,u,f,hs,ar )
%CHARAC 此处显示有关此函数的摘要
%   在此函数中调用结构，选择结构
% 输入变量
% nr_of_tsteps - the number of time steps the iteration will run
% time - used as input parameter in the boundary conditions tank and valve
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp up fp BC%用来存储得到的数据
for i = 1:nr_of_tsteps    %迭代次数

%%%%%%%%%%%%%%%%%%%%%%% 内部节点处压力头、流量、应力和管道轴向速度的计算 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pipe_inner(cnt,h,q,u,f,ar);

%%利用子程序计算边界条件
    for j = 1:size(BC,1)  %size(BC,1)表示BC的行数(j=1:3)
        BCtype = BC{j,1};%BC的第一行表示的是边界的名称
        switch BCtype
           case 'Tank'
               tank(j,time,cnt,h,q,u,f,ar);
           case 'Valve'
               valve2(j,time,cnt,q,h,hs,u,f,ar);
%             case'Valve_Junc'
%                 valve5(j,time,cnt,q,h,hs);
           %两个管路之间的连接
            case 'Junction'
                pipe_junc(j,cnt,h,q,u,f,ar);
           %终端
            case 'Deadend'
               deadend(j,time,cnt,h,q);
            case 'Hydraulic'
                hydraulic1(j,time,cnt,h,q);
%            case 'Valvedwn';
%                valvedwn(j);
%             case 'Orifice';
%                valvedwn(j);
        end
    end
%     for row=1:size(pipes,1)
%         pipes{row,1}(2,:) = pipes{row,1}(1,:);%将pipes第一列元素的第一行赋给第二行
%         pipes{row,2}(2,:) = pipes{row,2}(1,:);%将pipes第二列元素的第一行赋给第二行
%     end
end
end

