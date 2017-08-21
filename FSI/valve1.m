function valve1(BCIndex,t,cnt,q,h,hs )
%VALVE1 ���㷧��ǰ�������ڵ��ѹ��������,�����еķ���
%   ���������ܵ�֮��ķ��ŵ����
%�������������Ϊ�ܵ������ͻȻ�仯
% �������
% BCIndex - BC������ĳЩ�߽������ı��
% time - used as input parameter in the boundary conditions tank and valve

 global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp BC f_R  
 g=9.81;
 dt=t_def{1,3};%ʱ����
 tlast=t_def{1,2};%��ʱ��
 np=size(pipe,1);%�ܵ�����
 tv=BC{BCIndex,7};%���ſ���ʱ��
 tau0=BC{BCIndex,3};%���ų�ʼ����
 tauf=BC{BCIndex,4};%������󿪶�
 qs=BC{BCIndex,6};%���ŵ�����
 q0=q_def{1,2};%��̬����
 np=size(pipe,1);%�ܵ�����
 pipe1 = BC{BCIndex,9}; %����ǰ�Ĺ�·���
 pipe2 = BC{BCIndex,10}; %���ź�Ĺ�·���
 nm1=n(pipe1);%���һ���ܵ��ķֶ���
 nodes1 = nn(pipe1); %pipe1�Ľڵ���
 %������ڲ��ǳ��������ڲ壬�õ�����ʵʱ�Ŀ���ֵ
 if length(BC{BCIndex,12}) > 1
     disc=load (BC{BCIndex,11});%load��ɢ����ֵ
     time = disc(:,1); %ʱ������
     tau = disc(:,2); %����: ���ŵĿ�����
     tau1 = interp1(time,tau,t,'spline',tauf); %spineƽ��Ч���ã����ڳ����߽������Ϊtauf,���Ŀ���ֵ
 %���tauΪ����
 else
     tau1 = BC{BCIndex,12};
 end
 
 
 

     cp_val=q(pipe1,nm1)+ca(pipe1)*h(pipe1,nm1)-cf(pipe1)*q(pipe1,nm1)*abs(q(pipe1,nm1));%����ǰ�ܵ�pipe1��cp_val
     cn_val=q(pipe2,2)-ca(pipe2)*h(pipe2,2)-cf(pipe2)*q(pipe2,2)*abs(q(pipe2,2));%���ź�ܵ�pipe2��cn_val
     
    Di=pipe{pipe2,6};%pipe2���ھ�
    
    A_lv=(pi()*Di^2/4)*tau1;%���pipe2����Խ����
    
    
        a=ca(pipe1)*ca(pipe2)/2/g/A_lv^2;
        b=ca(pipe1)+ca(pipe2);
        c=-(ca(pipe1)*cn_val+ca(pipe2)*cp_val);
 
    
    
    if tau1<=0||a==Inf
        qp(pipe1,nn(pipe1))=0;
        qp(pipe2,1)=0;
    else
        qp(pipe1,nn(pipe1))=-b/(2*a)+sqrt((b/(2*a))^2-c/a);
        qp(pipe2,1)=qp(pipe1,nn(pipe1));
    end
    
    hp(pipe1,nn(pipe1))=(cp_val-qp(pipe1,nn(pipe1)))/ca(pipe1);
    hp(pipe2,1)=(qp(pipe1,nn(pipe1))-cn_val)/ca(pipe2);
    
    
        %%%%%%%%%%%%%���¾���%%%%%%%%%%%%%
        
        pressure{cnt+1,3}(pipe1,nn(pipe1))=hp(pipe1,nn(pipe1));%last pipe��һ���ڵ��ѹͷ�������Ĺܵ�ѹͷ���
        discharge{cnt+1,3}(pipe1,nn(pipe1))=qp(pipe1,nn(pipe1));%first pipe���һ���ڵ������
        pressure{cnt+1,3}(pipe2,1)=hp(pipe2,1);%last pipe��һ���ڵ��ѹͷ�������Ĺܵ�ѹͷ���
        discharge{cnt+1,3}(pipe2,1)=qp(pipe2,1);%first pipe���һ���ڵ������
        
   

end

