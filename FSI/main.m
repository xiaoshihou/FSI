%%%%%ͨ�������߷��������ڵ��ѹͷ������%%%%%
%------------����˼�룺����------------%
%------------���ࣺˮ�⡢�ܵ������ŵ�------------%
%------------����------------%
%1������ʱ�����͹ܵ�����
%2��ȷ��ϵͳ�ĺ㶨״̬������ʼ������ѹͷ
%3������ �����ڲ����� �����ڵ� �����α߽� ������ֵ ѭ��
%4��ÿ�ε�����Ӧ�ý�hn qn��ֵ����h q�Ա���һ�ε���ʹ��
%------------��Ҫ����------------%
%ÿ�ε��������ڵ�����ڻ�׼��ѹͷ�����ٷ���hn qn��δ���
%hmax hminδ���
%ÿ�ε��������нڵ��ѹͷ����h q
%Q1:k;ԭ���е�������ȡһ��ֵ
%Q2:���ڲ�ͬ�ı߽������ɽ��������Ϊ��ͬ�ĺ���
%Q3:ע��ȫ�ֱ����;ֲ�������������һ��ѭ���е�i,j,k����������
%Q4:pressure
%discharge�ֿ����ã�������result��Ҳͬʱ���������е����ݣ�ֻ�����ߵĴ洢��ʽ��һ����result����ѭ��һ�κ�hp,qp��ֵ�洢��h,p�У������ظ�result��pressure
%discharge����ÿ�����ڴ��������ڵ��ֵ���ڶ�Ӧ�Ľڵ㴦
%Q5:������������
%Q6:��Ҫ�ڱ����ж������������ֱ�Ӷ�ȡ
%Q7:�ܹ��Զ�����ϵͳ��ͨ��ʲô�����أ���Ҫ���ǵ�������͸׺ͷ��ŵ�λ����ô���뵽�ܵ�ϵͳ��
%Q8:hp qp Ϊÿ�μ���ʱѹ������������ʱ������ͨ������Ϊȫ�ֱ�������ÿ�ε����Ĺ������ܽ����ε���������ֵ�ı䣬�Ҳ�Ӱ����һ�ε���
%!!!!!!!!!����ڳ����п��Խ���ʱ�����Ͳ����������Ϊȫ�ֱ���
%Q9�������ڷ��ź�����Ȼ���ڹܵ��ͷ��ŵ����
%Q10��ʹ��xlswriteʱ��װoffice,com��ȫ��ȡ��
%Q11:����һЩ�������Ϊ����˳��Ĳ�ͬ��  ����ƫ���ԭ��
clear all
clc
close all

global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp up fp BC f_R%�����洢�õ�������
g=9.81;%�������ٶ�

%%%%%%%%%%%%%%%%%%%%%% ��ȡ�������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %��·�ͱ߽�����
[p_num_def, pipe,Valve,t_def,q_def,h_def,BC] = getInputFluid();

%�ܵ�����������ֵ
[size1,size2]=size(pipe);
for i=1:1:size1 %��ʵsize1���ǹܵ��ĸ���
    l(i)=pipe{i,3};%�ܵ�����
    a(i)=pipe{i,4};%aΪѹ������
    f(i)=pipe{i,5};%Ħ��ϵ��
    d(i)=pipe{i,6};%�ܵ�ֱ��
end


%������ֵ
h=[];%ѹͷ�����ڵ���
q=[];%���������ڵ���
u=[];%�ܵ��ٶȣ����ڵ���
f=[];%�ܵ�����Ӧ�������ڵ���
hmax=[];%ѹͷ���ֵ
hmin=[];%ѹͷ��Сֵ
hp=[];%ʱ����ĩ��ѹͷ
qp=[];%ʱ����ĩ������
up=[];%ʱ����ĩ�Ĺܵ������ٶ�
fp=[];%ʱ����ĩ�Ĺܵ�����Ӧ��
nn=[];%ÿ�ι��ӵĽڵ���
dt=t_def{1,3};%ʱ����
tlast=t_def{1,2};%��ʱ��
hres=h_def{1,2};%ˮ����Ի�׼���ѹͷ
q0=q_def{1,2};%��̬����

% qs=1;%���ŵ�����


%�洢ÿ������Ĺܵ�����Ŀnp
size4=size(p_num_def,2);
yy1=[];%��ʱ�洢�ܵ���Ŀ
for j=2:1:size4
    yy2=p_num_def{1,j};
    yy1=[yy1,yy2];
end
np=yy1(1);%�ܵ���Ŀ
np1=np-1;%�ܵ�������һ

%����FSI����
[ xi_f_p,xi_s_p,xi_f_V,xi_s_V,xi_f_theta,xi_s_theta,xi_f_U,xi_s_U ] = FSI_Const();







%%%%%%%%%%%%%%%%%%%%%%% ����ܵ����� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:1:np
    ar(i)=pi*d(i)^2/4;%�����
    n(i)=ceil(l(i)/dt/a(i));%�ܵ��ֶ���
    ca(i)=g*ar(i)/a(i);%Ca����
    cf(i)=f(i)*dt/(2*d(i)*ar(i));%R*dt
    f_R(i)=f(i)*l(i)/(2*g*d(i)*n(i)*ar(i)^2);%Ħ��ϵ�����������ڼ���dH
end

%%%%%%%%%%%%%%%%%%%%%%% �����ȶ�״̬ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�����ȶ�״̬,�ܵ�ÿ���ڵ��ѹͷ������ֵ�������������䣬ѹͷ�ݼ�
% h(1,1)=hres;%��һ����ֵ����ǰ��ˮ���ѹͷ
% for i=1:1:np
%     nn(i)=n(i)+1;%nn�ܵ��ڵ���=�ֶ���+1
%     for j=1:1:nn(i)
%         h(i,j)=h(i,1)-(j-1)*f_R(i)*q0^2;      %�޸�2017-1-11
%         q(i,j)=q0;%�ܵ�����Ϊ����
%     end
%     h(i+1,1)=h(i,nn(i));%ǰһ���ܵ������һ���ڵ��ѹͷ���ں�һ���ܵ��ĵ�һ���ڵ��ѹͷ
% end
%%%%%���Źرյ����
% h(1,1)=hres;%��һ����ֵ����ǰ��ˮ���ѹͷ

%ǰ��ܵ�1�ĳ�ʼ��
for i=1:1:n(1)+1
    h(1,i)=hres;
    q(1,i)=0;
    u(1,i)=0;
    f(1,i)=0;
end
%�ܵ�2�ĳ�ʼ��
for i=1:1:n(2)+1
    h(2,i)=0;
    q(2,i)=0;
    u(2,i)=0;
    f(2,i)=0;
end
for i=1:1:np
    nn(i)=n(i)+1;%nn�ܵ��ڵ���=�ֶ���+1
%     for j=1:1:nn(i)
%         h(i,j)=h(i,1)-(j-1)*f_R(i)*q0^2;      %�޸�2017-1-11
%         q(i,j)=q0;%�ܵ�����Ϊ����
%     end
%     h(i+1,1)=h(i,nn(i));%ǰһ���ܵ������һ���ڵ��ѹͷ���ں�һ���ܵ��ĵ�һ���ڵ��ѹͷ
end


%!!!!!!!!!!!!!!!!!!!!!!!��Ҫ%!!!!!!!!!!!!!!!!!!!!!!!
%�����ʼ������Ϊ0����ô���Ļ�׼ѹ���������һ���ܵ����ڵ��ѹ��
% if(q0~=0)
%     hs=h(np,nn(np));
% end

%��Ϊ��ʼ����Ϊ��,����ô���Ļ�׼ѹ���������һ���ܵ����ڵ��ѹ��
hs=1874.7;


%�����г�ʼ��ѹͷ�����hmax��hmin��
for i=1:1:np
    for j=1:1:nn(i)
        hmax(i,j)=h(i,j);
        hmin(i,j)=h(i,j);
    end
end


%��������
result=cell(tlast/dt,5);%�������ÿ�ε����Ľ���ľ���
cnt=0;%��¼��������
t=0;%��ʼʱ�̸�ֵ

%�ȴ��ֵh p
result{1,1}=t;%result�ĵ�һ�д��ʱ��������
result{1,2}=q;%result�ĵڶ��и����ܵ�����ֵ
result{1,3}=h;%result�ĵ����и����ܵ�ѹͷ
result{1,4}=u;%result�ĵ����и����ܵ������ٶ�
result{1,5}=f;%result�ĵ����и����ܵ�����Ӧ��
%%%%%%%%%%%%%%%%%%%%%%%%%% ����ѹ���������洢����Ĵ�С %%%%%%%%%%%%%%%%%%%%%%%

pressure{1,3}=h;%��ʼѹ���洢
discharge{1,3}=q;%��ʼ�����洢
pressure{1,1}=0;%��ʾ��ʼ
discharge{1,1}=0;%��ʾ��ʼ
pressure{1,2}=0;%��ʾʱ������
discharge{1,2}=0;%��ʾʱ������
%%%%%%%%%%%%%%%%%%%%%%% ѭ����ʼ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%ѭ����ʼ%%%%%%%%%%%
while t<tlast
    t=t+dt;%ʱ������dt
    cnt=cnt+1;%������������
    
    pressure{cnt+1,1}=cnt;%��ʾ�����Ĵ���
    pressure{cnt+1,2}=t;%��ʾʱ������
    discharge{cnt+1,1}=cnt;%��ʾ�����Ĵ���
    discharge{cnt+1,2}=t;%��ʾʱ������
         
%%%%%%%%%%%%%%%%%%%%%%% ����ϵͳ������ѹ�������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %����ˮ��----�����һ���ڵ��ѹͷ������hp qp
    %tank(cnt,h,q);
    %����ÿ���ܵ��ڲ��ڵ��ѹ��������ֵ 
    %pipe_inner(cnt,h,q);
    %�����ܵ����Ӵ�junction,ǰһ���ܵ����ڵ�ͽ��Źܵ���һ���ڵ�
    %pipe_junc(cnt,h,q);
    %���η��ţ����һ�ιܵ������һ���ڵ��������ѹͷ
    %valve(t,cnt,q,h,hs );
%%%%%%%%%%%%%%%%%%%%%%% �������ӣ���������ڵ��������ѹ�� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    charac( 1,t,cnt,h,q,u,f,hs,ar );
    %����ÿ�ε��������ڵ�����ڷ��Ż�׼��ѹͷ�������ٷ���hn qn,�����pressure��discharge��������
%     if np~=1
%         hn=h(np,nn(np))/hres;%ѹͷ��ֵ�����ˮ���׼
%         qn=q(np,nn(np))/qs;%������ֵ����ڷ��ų�ʼ��׼
%         pressure{cnt,4}=hn;
%         discharge{cnt,4}=qn;
%     end

    %���²��������ֵΪ��һ������׼��
    for i=1:1:np
        for j=1:1:nn(i)
            q(i,j)=qp(i,j);%��ÿһ����������нڵ���������и���
            h(i,j)=hp(i,j);%��ÿһ����������нڵ��ѹͷ���и���
            f(i,j)=fp(i,j);
            u(i,j)=up(i,j);
            if h(i,j)>hmax(i,j)
                hmax(i,j)=h(i,j);%�ҳ�ÿһ���ڵ��ѹͷ���ֵ
            end
            if h(i,j)<hmin(i,j)
                hmin(i,j)=h(i,j);%�ҳ�ÿһ���ڵ��ѹͷ��Сֵ
            end
        end
    end
    
    
    %���½������
    result{cnt+1,1}=t;%��һ�д��ʱ�����
    result{cnt+1,2}=q;%�ڶ��д�Žڵ������
    result{cnt+1,3}=h;%�����д�Žڵ��ѹͷ
    result{cnt+1,4}=u;%�����д�Žڵ���ٶ�
    result{cnt+1,5}=f;%�����д�Žڵ��Ӧ��
    discharge{cnt+1,3}=q;%�ڶ��д�Žڵ������
    pressure{cnt+1,3}=h;%�����д�Žڵ��ѹͷ
    
    
end  %����whileѭ��
%%%%%%%��Žڵ�ѹ���������Сֵ
pressure{1,5}=hmin;
pressure{2,5}=hmax;

%%%%%%%%%%%%%%%%%%%%%% ��������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
step=tlast/dt;%�ܹ���������
pipes=[];%��һ����·���һ���ڵ������
pipes1=[];%������һ���ܵ����һ���ڵ������
pipes2=[];%���ܵ����ڵ��ѹͷ
pipes3=[];%��һ���ܵ����ڵ��ѹͷ
step_time=[];%��Ź�������ʱ����
for k=1:1:step
    temp1=result{k,1};
    step_time=[step_time temp1];
    
%     temp=result{k,2}(1,2);%����ǰһ���ڵ������
%     pipes=[pipes temp];
    
%     temp2=result{k,2}(np,3);%������һ���ܵ����һ���ڵ������
%     pipes1=[pipes1 temp2];
    
    temp3=result{k,3}(1,nn(1));%����ǰ�ڵ��ѹͷ
    pipes2=[pipes2 temp3];
    
%     temp4=result{k,3}(np,3);%���ܵ����ڵ��ѹͷ
%     pipes3=[pipes3 temp4];
%     
end


%%%%%%%%%%%%%%%%%%%%%% ��������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(1) %��һ����·���һ���ڵ������
% plot(step_time,pipes,'g','Color',[0,0.7,0.9]);
% title('��һ����·���һ���ڵ������')%ͼͷ����
% xlabel('t')%������˵��
% ylabel('discharge')%������˵��
% legend('����ֵ')

% figure(2)%���һ����·���һ���ڵ������
% plot(step_time,pipes1,'b');
% title('���һ����·���һ���ڵ������')%ͼͷ����
% xlabel('t')%������˵��
% ylabel('discharge')%������˵��
% legend('����ֵ')

figure(1)%����ǰ�ڵ��ѹͷ
plot(step_time,pipes2,'b');
% title('����ǰ�ڵ��ѹͷ�仯ͼ')%ͼͷ����
xlabel('ʱ��/s')%������˵��
ylabel('ѹͷֵ/m')%������˵��
legend('ѹͷֵ')

% figure(4) %���ܵ����ڵ��ѹͷ
% plot(step_time,pipes3);
% title('���ܵ����ڵ��ѹͷ')%ͼͷ����
% xlabel('t')%������˵��
% ylabel('pressure head')%������˵��
% legend('ѹ��ֵ')

%%%%%%%%%%%%%%%%%%%%%% ����·�ṹ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%figure(3)
%plotPipeSystem(pipeGeo,supportGeo)

%%%%%%%%%%%%%%%%%%%%%% �������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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




