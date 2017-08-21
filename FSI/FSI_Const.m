function [ xi_f_p,xi_s_p,xi_f_V,xi_s_V,xi_f_theta,xi_s_theta,xi_f_U,xi_s_U ] = FSI_Const()
%%%%%%%%%%%%%%%%%%%%%%% 计算FSI常数 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A_f;%流体横截面积
a_f;%压力波速
A_s;%管壁横截面积
a_s;%轴向应力波速
D;%管道内径
E;%管壁杨氏模量
e;%管壁厚度
f;%达西表面摩擦系数
f_s;%稳态达西系数
f_u;%不稳定状态达西系数
F;%作用在系统上的力
g;%重力加速度
K;%可压缩体积模量
k_b;%Brunone系数
L;%管道长度
M_v;%阀门质量
M_a;%阀门锚块质量
p;%液体压力
Q;%液体流量
r;%管壁内半径
t;%时间
t_v;%阀门关闭时间
U;%管壁速度
V;%流体平均速度
V_r;%相对速度
x;%管道轴向距离
v;%泊松比
u;%库伦干摩擦系数
u_s;%静态库伦系数
u_k;%动态库伦系数
den_f;%流体密度
den_s;%管道密度
theta;%管道轴向应力
xi_f_p=1/(den_f*a_f)+2*v^2*(r/e)/(a_f*den_s)*(a_f^2/a_s^2)/(1-(a_f^2/a_s^2));
xi_s_p=v*r/(e*den_s*a_s)*(a_f^2/a_s^2)/(1-(a_f^2/a_s^2));
xi_f_V=1;
xi_s_V=v*r*den_f/(e*den_s)*(a_f^2/a_s^2)/(1-(a_f^2/a_s^2));
xi_f_theta=2*v/(den_s*a_f)*(a_f^2/a_s^2)/(1-(a_f^2/a_s^2));
xi_s_theta=1/(den_s*a_s);
xi_f_U=2*v*(a_f^2/a_s^2)/(1-(a_f^2/a_s^2));
xi_s_U=1+2*v^2*(r/e)*(den_f/den_s)*(a_f^2/a_s^2)/(1-(a_f^2/a_s^2));


end

