function valve(BCIndex,t,cnt,q,h,hs )
%VALVE ���ص�Ӧ���Ƿ���ǰ�������������ܵ��ڵ��������ѹ��
%   ���Ǵ˺������ڼ������η���ֱ������������������������ܵ�����������һ�ιܵ������һ���ڵ��������ѹͷ
% �������
% BCIndex - BC������ĳЩ�߽������ı��
% time - used as input parameter in the boundary conditions tank and valve
 %���η��ţ����һ�ιܵ������һ���ڵ��������ѹͷ
 global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp BC  
 pipe1 = BC{BCIndex,9}; %����ǰ�Ĺ�·���
 pipe2 = BC{BCIndex,10}; %���ź�Ĺ�·���
 nodes1 = nn(pipe1); %pipe1�Ľڵ���
 %������ڲ��ǳ��������ڲ壬�õ�����ʵʱ�Ŀ���ֵ
 if length(BC{BCIndex,12}) > 1
     disc=load (BC{BCIndex,11});%load��ɢ����ֵ
     time = disc(:,1); %ʱ������
     tau = disc(:,2); %����: ���ŵĿ�����
     tau1 = interp1(time,tau,t,'spline',0); %spineƽ��Ч���ã����ڳ����߽������Ϊ0
 %���tauΪ����
 else
     tau1 = BC{BCIndex,12};
 end
 
 
 
     dt=t_def{1,3};%ʱ����
     tlast=t_def{1,2};%��ʱ��
     np=size(pipe,1);%�ܵ�����
     nm1=n(pipe1);%���һ���ܵ��ķֶ���
     tv=BC{BCIndex,7};%���ſ���ʱ��
     tau0=BC{BCIndex,3};%���ų�ʼ����
     tauf=BC{BCIndex,4};%������󿪶�
     qs=BC{BCIndex,6};%���ŵ�����
     q0=q_def{1,2};%��̬����
     cp_val=q(pipe1,nm1)+ca(pipe1)*h(pipe1,nm1)-cf(pipe1)*q(pipe1,nm1)*abs(q(pipe1,nm1));%���һ�ιܵ���cp_val
     

    
    
    
    if (t>=tv)  %tvΪ���Źر�ʱ��
        tau=tauf;%�����ķ��ſ��ȸ���tau
        if (tau<=0)
            qp(pipe1,nn(pipe1))=0;%������ſ���С�ڵ���0�������ڵ������Ϊ0
            hp(pipe1,nn(pipe1))=cp_val/ca(pipe1);%������ſ���С�ڵ���0������Ϊ0������
        else
            cv=(qs*tau1)^2/hs/ca(pipe1);
            qp(pipe1,nn(pipe1))=0.5*(-cv+sqrt(cv*cv+4*cp_val*cv));%����ǰ�ڵ�����
            hp(pipe1,nn(pipe1))=(cp_val-qp(pipe1,nn(pipe1)))/ca(pipe1);%����ǰ�ڵ�ѹ��
        end
        
    else
       
        cv=(qs*tau1)^2/hs/ca(pipe1);
        qp(pipe1,nn(pipe1))=0.5*(-cv+sqrt(cv*cv+4*cp_val*cv));%����ǰ�ڵ�����
        hp(pipe1,nn(pipe1))=(cp_val-qp(pipe1,nn(pipe1)))/ca(pipe1);%����ǰ�ڵ�ѹ��

    end
        %%%%%%%%%%%%%���¾���%%%%%%%%%%%%%
        
        pressure{cnt+1,3}(pipe1,nn(pipe1))=hp(pipe1,nn(pipe1));%last pipe���һ���ڵ��ѹͷ
        discharge{cnt+1,3}(pipe1,nn(pipe1))=qp(pipe1,nn(pipe1));%last pipe���һ���ڵ������
        
        
       qs=Valve{1,6};%���ŵ�����
       hres=h_def{1,2};
           %����ÿ�ε��������ڵ�����ڷ��Ż�׼��ѹͷ�������ٷ���hn qn,�����pressure��discharge��������
    if np~=1
        hn=h(np,nn(np))/hres;%ѹͷ��ֵ�����ˮ���׼
        qn=q(np,nn(np))/qs;%������ֵ����ڷ��ų�ʼ��׼
        pressure{cnt,4}=hn;
        discharge{cnt,4}=qn;
    end
end

