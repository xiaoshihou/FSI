function [p_num_def, pipe,Valve,t_def,q_def,h_def,BC]=getInputFluid()
%getInputFluid - ��������еõ��ܵ����Ժͱ߽���Ϣ
  %����
      %Q1��ʹ��xlsread��ȡExcel�ļ������ݣ���raw��Ϊ����Դ
      %Q2��
      %Q3:
      %Q4:
	  %Q5:
% �������
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�������ݱ��·�����ļ���
[loadDefFile, loadDefPath] = uigetfile({'*.xlsx','excel-files (*.xlsx)';'*.mat','mat-files (*.mat)';'*.txt','Text files (*.txt)';'*.*','All files (*.*)'},'��ȡ�ܵ���������...');
if loadDefFile == 0, return; 
end

[num,txt,raw]=xlsread([loadDefPath,loadDefFile]); %ֱ������·���������ַ�������ֱ������
[m,n]=size(raw);
%raw�д�������е�����
temp=raw;
%��temp1��ű���pipe���ݣ���������ͷ��
temp1=[];
for i=1:1:m
    if strcmp(raw(i,1),'pipe')%||strcmp(raw(i,1),'#PIPE')
       temp2=temp(i,:);
      temp1=[temp1;temp2];
       end
end
pipe=temp1;

%��temp3��ű���p_num_def���ݣ���������ͷ��
temp3=[];
for i=1:1:m
    if strcmp(raw(i,1),'p_num_def')%||strcmp(raw(i,1),'#P_MUN')
       temp4=temp(i,:);
      temp3=[temp3;temp4];
       end
end
p_num_def=temp3;

%��temp5��ű���Valve���ݣ���������ͷ��
temp5=[];
for i=1:1:m
    if strcmp(raw(i,1),'Valve')%||strcmp(raw(i,1),'#VALVE')
       temp6=temp(i,:);
      temp5=[temp5;temp6];
       end
end
Valve=temp5;


%��temp9��ű���t_def���ݣ���������ͷ��
temp9=[];
for i=1:1:m
    if strcmp(raw(i,1),'t_def')%||strcmp(raw(i,1),'#T')
       temp10=temp(i,:);
      temp9=[temp9;temp10];
       end
end
t_def=temp9;

%��temp11��ű���q_def���ݣ���������ͷ��
temp11=[];
for i=1:1:m
    if strcmp(raw(i,1),'q_def')%||strcmp(raw(i,1),'#Q')

       temp12=temp(i,:);
      temp11=[temp11;temp12];
       end
end
q_def=temp11;

%��temp13��ű���h_def���ݣ���������ͷ��
temp13=[];
for i=1:1:m
    if strcmp(raw(i,1),'h_def')%||strcmp(raw(i,1),'#H')
       temp14=temp(i,:);
      temp13=[temp13;temp14];
       end
end
h_def=temp13;

%temp15�д���õ���BC
temp15=[];
  for  i=1:1:m
     if strcmp(raw(i,1),'Tank')||strcmp(raw(i,1),'Junction')||strcmp(raw(i,1),'Deadend')||strcmp(raw(i,1),'Valve')||strcmp(raw(i,1),'Valve_Junc')||strcmp(raw(i,1),'Hydraulic')
         temp4=temp(i,:);
         temp15=[temp15;temp4];
    end
  end  
 BC=temp15;
end