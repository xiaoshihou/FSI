function  pipe_junc(BCIndex,cnt,h,q,u,f,ar )
%pipe_junc -��������������·��ѹ��ͷ������
%   �˴���ʾ��ϸ˵��
% �������
% BCIndex - the index of the certain boundary condition in the BC-matrix

global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp up fp BC
np=size(pipe,1);%�ܵ�����
if(np~=1)
    %�����ܵ����Ӵ�junction,ǰһ���ܵ����ڵ�ͽ��Źܵ���һ���ڵ�
    pipe1 = BC{BCIndex,2}; %��·��ͷǰ�Ĺ�·���
    pipe2 = BC{BCIndex,3}; %��·��ͷ��Ĺ�·���
    %cn(pipe2)=q(pipe2,2)-ca(pipe2)*h(pipe2,2)-cf(pipe2)*q(pipe2,2)*abs(q(pipe2,2));
    %cp(pipe1)=q(pipe1,n(pipe1))+ca(pipe1)*h(pipe1,n(pipe1))-cf(pipe1)*q(pipe1,n(pipe1))*abs(q(pipe1,n(pipe1)));
    %hp(pipe1,nn(pipe1))=(cp(pipe1)-cn(pipe2))/(ca(pipe1)+ca(pipe2));%first pipe���һ���ڵ��ѹͷ
    
%     %2017-1-11�����ж�ѹ��ֵ������
%     if hp(pipe1,nn(pipe1))<0
%         hp(pipe1,nn(pipe1))=0;
%     end
%     %2017-1-11�����ж�ѹ��ֵ������
    
    
    
    
    %hp(pipe2,1)=hp(pipe1,nn(pipe1));%last pipe��һ���ڵ��ѹͷ�������Ĺܵ�ѹͷ���
    
    
    
    
    
    %qp(pipe1,nn(pipe1))=cp(pipe1)-ca(pipe1)*hp(pipe1,nn(pipe1));%first pipe���һ���ڵ������
    %qp(pipe2,1)=cn(pipe2)+ca(pipe2)*hp(pipe2,1);%last pipe��һ���ڵ������
    cpf(pipe1)=-(xi_f_p*h(pipe1,nn(pipe1)))-xi_f_V*q(i,jm1)/ar(i)+xi_f_theta*f(i,jm1)-xi_f_U*u(i,jm1);
    %cnf(pipe1)=xi_f_p*h(i,jp1)-xi_f_V*q(i,jp1)/ar(i)-xi_f_theta*f(i,jp1)-xi_f_U*u(i,jp1);
    cps(pipe1)=xi_s_p*h(i,jm1-2)+xi_s_V*q(i,jm1-2)/ar(i)+xi_s_theta*f(i,jm1-2)-xi_s_U*u(i,jm1-2);
    %cns(pipe1)=-(xi_s_p*h(i,jp1+2))+xi_s_V*q(i,jp1+2)/ar(i)-xi_s_theta*f(i,jp1+2)-xi_s_U*u(i,jp1+2);
    
    %%%%%%%%%%%%��������ʧ���ĸ�������ֵȫ�����%%%%%%%%%%%%
    hp(pipe1,nn(pipe1))=hp(pipe2,1);
    qp(pipe1,nn(pipe1))=qp(pipe2,1);
    fp(pipe1,nn(pipe1))=fp(pipe2,1);
    up(pipe1,nn(pipe1))=up(pipe2,1);
    %%%%%%%%%%%%��������ʧ���ĸ�������ֵȫ�����%%%%%%%%%%%%
   
    
    %%%%%%%%%%%%%���¾���%%%%%%%%%%%%%
    
   
                    
                    
    pressure{cnt+1,3}(pipe1,nn(pipe1))=hp(pipe1,nn(pipe1));%first pipe���һ���ڵ��ѹͷ
    pressure{cnt+1,3}(pipe2,1)=hp(pipe2,1);%last pipe��һ���ڵ��ѹͷ�������Ĺܵ�ѹͷ���
    discharge{cnt+1,3}(pipe1,nn(pipe1))=qp(pipe1,nn(pipe1));%first pipe���һ���ڵ������
    discharge{cnt+1,3}(pipe2,1)=qp(pipe2,1);%last pipe��һ���ڵ������
end

end

