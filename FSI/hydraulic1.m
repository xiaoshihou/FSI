function hydraulic1( BCIndex,time,cnt,h,q )
%hydraulic1 用于计算液压缸的边界条件，更新方法，消去y
%   此处显示详细说明
% BCIndex - BC矩阵中某些边界条件的编号

global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp BC f_R 
 pipe1 = BC{BCIndex,2}; %液压缸前的管路编号
 %pipe2 = BC{BCIndex,3}; %液压缸后的管路编号
 dt=t_def{1,3};%时间间隔
 %D=BC{BCIndex,4};%液压缸活塞直径
 %A=pi*D^2/4;%液压缸活塞面积
 A=0.0038877;%液压缸活塞面积
 den=870;
 g=9.81;
 %E=BC{BCIndex,5};%液压缸油液体积弹性模量
 %m=BC{BCIndex,6};%运动部分质量
%  k=[];
 k=BC{BCIndex,7};%液压缸弹簧系数
 y=[];%存储活塞的位移
 y(1)=0;
 num=cnt+1;
%  k(num)=10e6*(3.649*y(cnt)^2-3.448*y(cnt)+2.441);%液压缸弹簧系数
 y(cnt)=h(pipe1,nn(pipe1))*A/k;%存储活塞的位移
 pressure{1,6}=0;%初始位移
 pressure{cnt+1,6}=y(cnt);%存放活塞的位移数据


    nmb=nn(pipe1)-1;%pipe1分段数
    cp_hyd=q(pipe1,nmb)+ca(pipe1)*h(pipe1,nmb)-cf(pipe1)*q(pipe1,nmb)*abs(q(pipe1,nmb));%作动筒前管道pipe1的cp_hyd
    hp(pipe1,nn(pipe1))=(k*dt/A^2/den/g*cp_hyd+h(pipe1,nn(pipe1)))/(1+k*dt*ca(pipe1)/A^2/den/g);%联立方程消去y得到流量与压力的关系
	
%   %2017-1-11增加判断压力值的正负
%     if hp(pipe1,nn(pipe1))<0
%         hp(pipe1,nn(pipe1))=0;
%     end
%     %2017-1-11增加判断压力值的正负
    
    
    
    qp(pipe1,nn(pipe1))=cp_hyd-ca(pipe1)*hp(pipe1,nn(pipe1));%作动筒前管道pipe1的流量
    
   
 




%%%%%%%%%%%%%更新矩阵%%%%%%%%%%%%%
        
        pressure{cnt+1,3}(pipe1,nn(pipe1))=hp(pipe1,nn(pipe1));%pipe1最后一个节点的压力
        discharge{cnt+1,3}(pipe1,nn(pipe1))=qp(pipe1,nn(pipe1));%pipe1最后一个节点的流量
 








end

