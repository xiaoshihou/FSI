function hydraulic( BCIndex,time,cnt,h,q )
%hydraulic 用于计算液压缸的边界条件
%   此处显示详细说明
% BCIndex - BC矩阵中某些边界条件的编号

global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp BC f_R 
 pipe1 = BC{BCIndex,2}; %液压缸前的管路编号
 %pipe2 = BC{BCIndex,3}; %液压缸后的管路编号
 dt=t_def{1,3};%时间间隔
 D=BC{BCIndex,4};%液压缸活塞直径
 A=pi*D^2/4;%液压缸活塞面积
 E=BC{BCIndex,5};%液压缸油液体积弹性模量
 m=BC{BCIndex,6};%运动部分质量
 k=BC{BCIndex,7};%液压缸弹簧系数
 y=[];%存储活塞的位移
 y(1)=0;
 num=cnt+1;
 y(num)=h(pipe1,nn(pipe1))*A/k;%存储活塞的位移
pressure{1,6}=0;%初始位移
pressure{cnt+1,6}=y(cnt+1);%存放活塞的位移数据

if cnt==1
    qp(pipe1,nn(pipe1))=A*(pressure{num,6}-pressure{cnt,6})/dt+A*pressure{cnt,6}/E*pressure{cnt,3}(pipe1,nn(pipe1))/dt;%如果第一次简化
    nmb=nn(pipe1)-1;%pipe1分段数
    cp_hyd=q(pipe1,nmb)+ca(pipe1)*h(pipe1,nmb)-cf(pipe1)*q(pipe1,nmb)*abs(q(pipe1,nmb));%作动筒前管道pipe1的cp_hyd
    hp(pipe1,nn(pipe1))=(cp_hyd-qp(pipe1,nn(pipe1)))/ca(pipe1);
else
    qp(pipe1,nn(pipe1))=A*(pressure{num,6}-pressure{cnt,6})/dt+A*pressure{cnt,6}/E*(pressure{num,3}(pipe1,nn(pipe1))-pressure{cnt,3}(pipe1,nn(pipe1)))/dt;
    nmb=nn(pipe1)-1;%pipe1分段数
    cp_hyd=q(pipe1,nmb)+ca(pipe1)*h(pipe1,nmb)-cf(pipe1)*q(pipe1,nmb)*abs(q(pipe1,nmb));%作动筒前管道pipe1的cp_hyd
    hp(pipe1,nn(pipe1))=(cp_hyd-qp(pipe1,nn(pipe1)))/ca(pipe1);
end



%%%%%%%%%%%%%更新矩阵%%%%%%%%%%%%%
        
        pressure{cnt+1,3}(pipe1,nn(pipe1))=hp(pipe1,nn(pipe1));%pipe1最后一个节点的压力
        discharge{cnt+1,3}(pipe1,nn(pipe1))=qp(pipe1,nn(pipe1));%pipe1最后一个节点的流量
 








end

