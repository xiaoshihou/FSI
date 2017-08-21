function hydraulic( BCIndex,time,cnt,h,q )
%hydraulic ���ڼ���Һѹ�׵ı߽�����
%   �˴���ʾ��ϸ˵��
% BCIndex - BC������ĳЩ�߽������ı��

global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp BC f_R 
 pipe1 = BC{BCIndex,2}; %Һѹ��ǰ�Ĺ�·���
 %pipe2 = BC{BCIndex,3}; %Һѹ�׺�Ĺ�·���
 dt=t_def{1,3};%ʱ����
 D=BC{BCIndex,4};%Һѹ�׻���ֱ��
 A=pi*D^2/4;%Һѹ�׻������
 E=BC{BCIndex,5};%Һѹ����Һ�������ģ��
 m=BC{BCIndex,6};%�˶���������
 k=BC{BCIndex,7};%Һѹ�׵���ϵ��
 y=[];%�洢������λ��
 y(1)=0;
 num=cnt+1;
 y(num)=h(pipe1,nn(pipe1))*A/k;%�洢������λ��
pressure{1,6}=0;%��ʼλ��
pressure{cnt+1,6}=y(cnt+1);%��Ż�����λ������

if cnt==1
    qp(pipe1,nn(pipe1))=A*(pressure{num,6}-pressure{cnt,6})/dt+A*pressure{cnt,6}/E*pressure{cnt,3}(pipe1,nn(pipe1))/dt;%�����һ�μ�
    nmb=nn(pipe1)-1;%pipe1�ֶ���
    cp_hyd=q(pipe1,nmb)+ca(pipe1)*h(pipe1,nmb)-cf(pipe1)*q(pipe1,nmb)*abs(q(pipe1,nmb));%����Ͳǰ�ܵ�pipe1��cp_hyd
    hp(pipe1,nn(pipe1))=(cp_hyd-qp(pipe1,nn(pipe1)))/ca(pipe1);
else
    qp(pipe1,nn(pipe1))=A*(pressure{num,6}-pressure{cnt,6})/dt+A*pressure{cnt,6}/E*(pressure{num,3}(pipe1,nn(pipe1))-pressure{cnt,3}(pipe1,nn(pipe1)))/dt;
    nmb=nn(pipe1)-1;%pipe1�ֶ���
    cp_hyd=q(pipe1,nmb)+ca(pipe1)*h(pipe1,nmb)-cf(pipe1)*q(pipe1,nmb)*abs(q(pipe1,nmb));%����Ͳǰ�ܵ�pipe1��cp_hyd
    hp(pipe1,nn(pipe1))=(cp_hyd-qp(pipe1,nn(pipe1)))/ca(pipe1);
end



%%%%%%%%%%%%%���¾���%%%%%%%%%%%%%
        
        pressure{cnt+1,3}(pipe1,nn(pipe1))=hp(pipe1,nn(pipe1));%pipe1���һ���ڵ��ѹ��
        discharge{cnt+1,3}(pipe1,nn(pipe1))=qp(pipe1,nn(pipe1));%pipe1���һ���ڵ������
 








end

