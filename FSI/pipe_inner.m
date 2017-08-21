function pipe_inner(cnt,h,q,u,f,ar)

%%%%%%%%计算每根管道内部节点的压力和流量
%------------重要参数------------%
% nr_of_tsteps - the number of time steps the iteration will run
% time - used as input parameter in the boundary conditions tank and valve
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%问题
%Q1:k;原文中迭代两次取一回值，因此可将nr_of_steps的值赋为2
%Q2:增加轴向速度U和轴向应力f
%Q3:
%Q4:
%Q5:
%Q6:
%Q7:

global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp up fp%用来存储得到的数据

    %每个管道内部节点的压头和流量hp qp up fp
    np=size(pipe,1);%管道总数
    for i=1:1:np
        for j=2:1:n(i)
            jp1=j+1;%下一个节点号
            jm1=j-1;%上一个节点号
            %cn(i)=q(i,jp1)-ca(i)*h(i,jp1)-cf(i)*q(i,jp1)*abs(q(i,jp1));%cn和cp在每个时间步长内为常数，并随时间间隔变化而变化
            %cp(i)=q(i,jm1)+ca(i)*h(i,jm1)-cf(i)*q(i,jm1)*abs(q(i,jm1));
            
            cpf(i)=-(xi_f_p*h(i,jm1))-xi_f_V*q(i,jm1)/ar(i)+xi_f_theta*f(i,jm1)-xi_f_U*u(i,jm1);
            cnf(i)=xi_f_p*h(i,jp1)-xi_f_V*q(i,jp1)/ar(i)-xi_f_theta*f(i,jp1)-xi_f_U*u(i,jp1);
            cps(i)=xi_s_p*h(i,jm1-2)+xi_s_V*q(i,jm1-2)/ar(i)+xi_s_theta*f(i,jm1-2)-xi_s_U*u(i,jm1-2);
            cns(i)=-(xi_s_p*h(i,jp1+2))+xi_s_V*q(i,jp1+2)/ar(i)-xi_s_theta*f(i,jp1+2)-xi_s_U*u(i,jp1+2);
            
            %qp(i,j)=0.5*(cp(i)+cn(i));
            %hp(i,j)=(cp(i)-qp(i,j))/ca(i);
            
            hp(i,j)=-(((cpf(i)-cnf(i))/xi_f_theta)-((cps(i)-cns(i))/xi_s_theta))/(2*(xi_f_p/xi_f_theta+xi_s_p/xi_s_theta));
            qp(i,j)=ar(i)*(-(((cpf(i)+cnf(i))/xi_f_U)-((cps(i)-cns(i))/xi_s_U))/(2*(xi_f_V/xi_f_U+xi_s_V/xi_s_U)));
            fp(i,j)=(((cpf(i)-cnf(i))/xi_f_p)+((cps(i)-cns(i))/xi_s_p))/(2*(xi_f_theta/xi_f_p+xi_s_theta/xi_s_p));
            up(i,j)=-(((cpf(i)+cnf(i))/xi_f_V)+((cps(i)+cns(i))/xi_s_V))/(2*(xi_f_U/xi_f_V+xi_s_U/xi_s_V));
            
            %防止压头出现负值，此时形成真空现象，但是应该很少，不应持续
%             if hp(i,j)<0
%                 hp(i,j)=0;
%             end
%             
            %%%%%%%%%%更新存储值
            pressure{cnt+1,3}(i,j)=hp(i,j);
            discharge{cnt+1,3}(i,j)=qp(i,j);
        end
    end

end   







