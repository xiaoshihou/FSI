%%%%%通过特征线法求解各个节点的压头和流量%%%%%
%------------核心思想：迭代------------%
%------------分类：水库、管道、阀门等------------%
%------------步骤------------%
%1、计算时间间隔和管道常数
%2、确定系统的恒定状态参数初始流量和压头
%3、迭代 计算内部断面 串联节点 上下游边界 保存数值 循环
%4、每次迭代后应该将hn qn的值赋给h q以便下一次迭代使用
%------------重要参数------------%
%每次迭代后最后节点相对于基准的压头流量百分数hn qn，未存放
%hmax hmin未存放
%每次迭代后所有节点的压头流量h q
%Q1:k;原文中迭代两次取一回值
%Q2:对于不同的边界条件可将程序分离为不同的函数
%Q3:注意全局变量和局部变量的区别，在一个循环中的i,j,k和整个函数
%Q4:pressure
%discharge分开放置，并在在result中也同时汇总了所有的数据，只是两者的存储方式不一样，result是在循环一次后将hp,qp的值存储在h,p中，并返回给result，pressure
%discharge是在每个环节处将各个节点的值放在对应的节点处
%Q5:参数冗余问题
%Q6:需要在表格中定义各个参数，直接读取
%Q7:能够自动生成系统，通过什么方法呢？主要考虑到后面的油缸和阀门的位置怎么插入到管道系统中
%Q8:hp qp 为每次计算时压力和流量的临时变量，通过定义为全局变量，在每次迭代的过程中能将本次迭代的所有值改变，且不影响下一次迭代
%!!!!!!!!!因此在程序中可以将临时变量和不变的量定义为全局变量
%Q9：考虑在阀门后面仍然存在管道和阀门的情况
%Q10：使用xlswrite时安装office,com项全部取消
%Q11:出现一些误差是因为计算顺序的不同吗  分析偏差的原因
clear all
clc
close all

global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp up fp BC f_R%用来存储得到的数据
g=9.81;%重力加速度

%%%%%%%%%%%%%%%%%%%%%% 读取表格数据 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %管路和边界条件
[p_num_def, pipe,Valve,t_def,q_def,h_def,BC] = getInputFluid();

%管道基本参数赋值
[size1,size2]=size(pipe);
for i=1:1:size1 %其实size1就是管道的个数
    l(i)=pipe{i,3};%管道长度
    a(i)=pipe{i,4};%a为压力波速
    f(i)=pipe{i,5};%摩阻系数
    d(i)=pipe{i,6};%管道直径
end


%变量赋值
h=[];%压头，用于迭代
q=[];%流量，用于迭代
u=[];%管道速度，用于迭代
f=[];%管道轴向应力，用于迭代
hmax=[];%压头最大值
hmin=[];%压头最小值
hp=[];%时间间隔末的压头
qp=[];%时间间隔末的流量
up=[];%时间间隔末的管道轴向速度
fp=[];%时间间隔末的管道轴向应力
nn=[];%每段管子的节点数
dt=t_def{1,3};%时间间隔
tlast=t_def{1,2};%总时间
hres=h_def{1,2};%水库相对基准面的压头
q0=q_def{1,2};%稳态流量

% qs=1;%阀门的流量


%存储每个区域的管道的数目np
size4=size(p_num_def,2);
yy1=[];%临时存储管道数目
for j=2:1:size4
    yy2=p_num_def{1,j};
    yy1=[yy1,yy2];
end
np=yy1(1);%管道数目
np1=np-1;%管道个数减一

%计算FSI常数
[ xi_f_p,xi_s_p,xi_f_V,xi_s_V,xi_f_theta,xi_s_theta,xi_f_U,xi_s_U ] = FSI_Const();







%%%%%%%%%%%%%%%%%%%%%%% 计算管道常数 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:1:np
    ar(i)=pi*d(i)^2/4;%截面积
    n(i)=ceil(l(i)/dt/a(i));%管道分段数
    ca(i)=g*ar(i)/a(i);%Ca常数
    cf(i)=f(i)*dt/(2*d(i)*ar(i));%R*dt
    f_R(i)=f(i)*l(i)/(2*g*d(i)*n(i)*ar(i)^2);%摩阻系数长串，用于计算dH
end

%%%%%%%%%%%%%%%%%%%%%%% 计算稳定状态 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%计算稳定状态,管道每个节点的压头和流量值，其中流量不变，压头递减
% h(1,1)=hres;%第一个数值等于前方水库的压头
% for i=1:1:np
%     nn(i)=n(i)+1;%nn管道节点数=分段数+1
%     for j=1:1:nn(i)
%         h(i,j)=h(i,1)-(j-1)*f_R(i)*q0^2;      %修改2017-1-11
%         q(i,j)=q0;%管道流量为常数
%     end
%     h(i+1,1)=h(i,nn(i));%前一根管道的最后一个节点的压头等于后一根管道的第一个节点的压头
% end
%%%%%阀门关闭的情况
% h(1,1)=hres;%第一个数值等于前方水库的压头

%前面管道1的初始化
for i=1:1:n(1)+1
    h(1,i)=hres;
    q(1,i)=0;
    u(1,i)=0;
    f(1,i)=0;
end
%管道2的初始化
for i=1:1:n(2)+1
    h(2,i)=0;
    q(2,i)=0;
    u(2,i)=0;
    f(2,i)=0;
end
for i=1:1:np
    nn(i)=n(i)+1;%nn管道节点数=分段数+1
%     for j=1:1:nn(i)
%         h(i,j)=h(i,1)-(j-1)*f_R(i)*q0^2;      %修改2017-1-11
%         q(i,j)=q0;%管道流量为常数
%     end
%     h(i+1,1)=h(i,nn(i));%前一根管道的最后一个节点的压头等于后一根管道的第一个节点的压头
end


%!!!!!!!!!!!!!!!!!!!!!!!重要%!!!!!!!!!!!!!!!!!!!!!!!
%如果初始流量不为0，那么阀的基准压力等于最后一个管道最后节点的压力
% if(q0~=0)
%     hs=h(np,nn(np));
% end

%因为初始流量为零,，那么阀的基准压力等于最后一个管道最后节点的压力
hs=1874.7;


%把所有初始的压头存放在hmax和hmin中
for i=1:1:np
    for j=1:1:nn(i)
        hmax(i,j)=h(i,j);
        hmin(i,j)=h(i,j);
    end
end


%迭代参数
result=cell(tlast/dt,5);%用来存放每次迭代的结果的矩阵
cnt=0;%记录迭代次数
t=0;%初始时刻赋值

%先存初值h p
result{1,1}=t;%result的第一列存放时间递增间隔
result{1,2}=q;%result的第二列各个管道流量值
result{1,3}=h;%result的第三列各个管道压头
result{1,4}=u;%result的第四列各个管道轴向速度
result{1,5}=f;%result的第五列各个管道轴向应力
%%%%%%%%%%%%%%%%%%%%%%%%%% 定义压力和流量存储矩阵的大小 %%%%%%%%%%%%%%%%%%%%%%%

pressure{1,3}=h;%初始压力存储
discharge{1,3}=q;%初始流量存储
pressure{1,1}=0;%表示初始
discharge{1,1}=0;%表示初始
pressure{1,2}=0;%表示时间增量
discharge{1,2}=0;%表示时间增量
%%%%%%%%%%%%%%%%%%%%%%% 循环开始 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%循环开始%%%%%%%%%%%
while t<tlast
    t=t+dt;%时间增加dt
    cnt=cnt+1;%迭代次数递增
    
    pressure{cnt+1,1}=cnt;%表示迭代的次数
    pressure{cnt+1,2}=t;%表示时间增量
    discharge{cnt+1,1}=cnt;%表示迭代的次数
    discharge{cnt+1,2}=t;%表示时间增量
         
%%%%%%%%%%%%%%%%%%%%%%% 计算系统部件的压力和流量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %上游水库----计算第一个节点的压头和流量hp qp
    %tank(cnt,h,q);
    %计算每个管道内部节点的压力和流量值 
    %pipe_inner(cnt,h,q);
    %两个管道连接处junction,前一个管道最后节点和接着管道第一个节点
    %pipe_junc(cnt,h,q);
    %下游阀门，最后一段管道的最后一个节点的流量和压头
    %valve(t,cnt,q,h,hs );
%%%%%%%%%%%%%%%%%%%%%%% 流体算子：计算各个节点的流量和压力 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    charac( 1,t,cnt,h,q,u,f,hs,ar );
    %计算每次迭代后最后节点相对于阀门基准的压头和流量百分数hn qn,存放在pressure和discharge第四列中
%     if np~=1
%         hn=h(np,nn(np))/hres;%压头比值相对于水库基准
%         qn=q(np,nn(np))/qs;%流量比值相对于阀门初始基准
%         pressure{cnt,4}=hn;
%         discharge{cnt,4}=qn;
%     end

    %更新并储存变量值为下一步迭代准备
    for i=1:1:np
        for j=1:1:nn(i)
            q(i,j)=qp(i,j);%将每一步计算的所有节点的流量进行更新
            h(i,j)=hp(i,j);%将每一步计算的所有节点的压头进行更新
            f(i,j)=fp(i,j);
            u(i,j)=up(i,j);
            if h(i,j)>hmax(i,j)
                hmax(i,j)=h(i,j);%找出每一个节点的压头最大值
            end
            if h(i,j)<hmin(i,j)
                hmin(i,j)=h(i,j);%找出每一个节点的压头最小值
            end
        end
    end
    
    
    %更新结果矩阵
    result{cnt+1,1}=t;%第一列存放时间变量
    result{cnt+1,2}=q;%第二列存放节点的流量
    result{cnt+1,3}=h;%第三列存放节点的压头
    result{cnt+1,4}=u;%第四列存放节点的速度
    result{cnt+1,5}=f;%第五列存放节点的应力
    discharge{cnt+1,3}=q;%第二列存放节点的流量
    pressure{cnt+1,3}=h;%第三列存放节点的压头
    
    
end  %结束while循环
%%%%%%%存放节点压力的最大最小值
pressure{1,5}=hmin;
pressure{2,5}=hmax;

%%%%%%%%%%%%%%%%%%%%%% 画结果曲线 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
step=tlast/dt;%总共迭代次数
pipes=[];%第一根管路最后一个节点的流量
pipes1=[];%存放最后一个管道最后一个节点的流量
pipes2=[];%最后管道最后节点的压头
pipes3=[];%第一根管道最后节点的压头
step_time=[];%存放公共迭代时间间隔
for k=1:1:step
    temp1=result{k,1};
    step_time=[step_time temp1];
    
%     temp=result{k,2}(1,2);%阀门前一个节点的流量
%     pipes=[pipes temp];
    
%     temp2=result{k,2}(np,3);%存放最后一个管道最后一个节点的流量
%     pipes1=[pipes1 temp2];
    
    temp3=result{k,3}(1,nn(1));%阀门前节点的压头
    pipes2=[pipes2 temp3];
    
%     temp4=result{k,3}(np,3);%最后管道最后节点的压头
%     pipes3=[pipes3 temp4];
%     
end


%%%%%%%%%%%%%%%%%%%%%% 画结果曲线 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(1) %第一根管路最后一个节点的流量
% plot(step_time,pipes,'g','Color',[0,0.7,0.9]);
% title('第一根管路最后一个节点的流量')%图头名称
% xlabel('t')%横坐标说明
% ylabel('discharge')%纵坐标说明
% legend('流量值')

% figure(2)%最后一个管路最后一个节点的流量
% plot(step_time,pipes1,'b');
% title('最后一个管路最后一个节点的流量')%图头名称
% xlabel('t')%横坐标说明
% ylabel('discharge')%纵坐标说明
% legend('流量值')

figure(1)%阀门前节点的压头
plot(step_time,pipes2,'b');
% title('阀门前节点的压头变化图')%图头名称
xlabel('时间/s')%横坐标说明
ylabel('压头值/m')%纵坐标说明
legend('压头值')

% figure(4) %最后管道最后节点的压头
% plot(step_time,pipes3);
% title('最后管道最后节点的压头')%图头名称
% xlabel('t')%横坐标说明
% ylabel('pressure head')%纵坐标说明
% legend('压力值')

%%%%%%%%%%%%%%%%%%%%%% 画管路结构 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%figure(3)
%plotPipeSystem(pipeGeo,supportGeo)

%%%%%%%%%%%%%%%%%%%%%% 储存数据 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename = 'data19.xlsx';
% E=cell2mat(pressure(:,1));
% C=cell2mat(pressure(:,2));
% D=cell2mat(pressure(:,3));
% % xlswrite(filename,E,1,'A1')
% % xlswrite(filename,C,1,'B1')
% xlswrite(filename,D,1)
% 
% E1=cell2mat(discharge(:,1));
% C1=cell2mat(discharge(:,2));
% D1=cell2mat(discharge(:,3));
% % xlswrite(filename,E1,2,'A1')
% % xlswrite(filename,C1,2,'B1')
% xlswrite(filename,D1,2)





