function hydraulic1( BCIndex,time,cnt,h,q )
%hydraulic1 ���ڼ���Һѹ�׵ı߽����������·�������ȥy
%   �˴���ʾ��ϸ˵��
% BCIndex - BC������ĳЩ�߽������ı��

global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp BC f_R 
 pipe1 = BC{BCIndex,2}; %Һѹ��ǰ�Ĺ�·���
 %pipe2 = BC{BCIndex,3}; %Һѹ�׺�Ĺ�·���
 dt=t_def{1,3};%ʱ����
 %D=BC{BCIndex,4};%Һѹ�׻���ֱ��
 %A=pi*D^2/4;%Һѹ�׻������
 A=0.0038877;%Һѹ�׻������
 den=870;
 g=9.81;
 %E=BC{BCIndex,5};%Һѹ����Һ�������ģ��
 %m=BC{BCIndex,6};%�˶���������
%  k=[];
 k=BC{BCIndex,7};%Һѹ�׵���ϵ��
 y=[];%�洢������λ��
 y(1)=0;
 num=cnt+1;
%  k(num)=10e6*(3.649*y(cnt)^2-3.448*y(cnt)+2.441);%Һѹ�׵���ϵ��
 y(cnt)=h(pipe1,nn(pipe1))*A/k;%�洢������λ��
 pressure{1,6}=0;%��ʼλ��
 pressure{cnt+1,6}=y(cnt);%��Ż�����λ������


    nmb=nn(pipe1)-1;%pipe1�ֶ���
    cp_hyd=q(pipe1,nmb)+ca(pipe1)*h(pipe1,nmb)-cf(pipe1)*q(pipe1,nmb)*abs(q(pipe1,nmb));%����Ͳǰ�ܵ�pipe1��cp_hyd
    hp(pipe1,nn(pipe1))=(k*dt/A^2/den/g*cp_hyd+h(pipe1,nn(pipe1)))/(1+k*dt*ca(pipe1)/A^2/den/g);%����������ȥy�õ�������ѹ���Ĺ�ϵ
	
%   %2017-1-11�����ж�ѹ��ֵ������
%     if hp(pipe1,nn(pipe1))<0
%         hp(pipe1,nn(pipe1))=0;
%     end
%     %2017-1-11�����ж�ѹ��ֵ������
    
    
    
    qp(pipe1,nn(pipe1))=cp_hyd-ca(pipe1)*hp(pipe1,nn(pipe1));%����Ͳǰ�ܵ�pipe1������
    
   
 




%%%%%%%%%%%%%���¾���%%%%%%%%%%%%%
        
        pressure{cnt+1,3}(pipe1,nn(pipe1))=hp(pipe1,nn(pipe1));%pipe1���һ���ڵ��ѹ��
        discharge{cnt+1,3}(pipe1,nn(pipe1))=qp(pipe1,nn(pipe1));%pipe1���һ���ڵ������
 








end

