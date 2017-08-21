function [p_num_def, pipe,Valve,t_def,q_def,h_def,BC]=getInputFluid()
%getInputFluid - 从流体表中得到管道特性和边界信息
  %问题
      %Q1：使用xlsread读取Excel文件的数据，用raw作为数据源
      %Q2：
      %Q3:
      %Q4:
	  %Q5:
% 输入变量
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%返回数据表的路径和文件名
[loadDefFile, loadDefPath] = uigetfile({'*.xlsx','excel-files (*.xlsx)';'*.mat','mat-files (*.mat)';'*.txt','Text files (*.txt)';'*.*','All files (*.*)'},'读取管道参数数据...');
if loadDefFile == 0, return; 
end

[num,txt,raw]=xlsread([loadDefPath,loadDefFile]); %直接生成路径，对于字符串矩阵直接连接
[m,n]=size(raw);
%raw中存放着所有的数据
temp=raw;
%用temp1存放表中pipe数据（不包括表头）
temp1=[];
for i=1:1:m
    if strcmp(raw(i,1),'pipe')%||strcmp(raw(i,1),'#PIPE')
       temp2=temp(i,:);
      temp1=[temp1;temp2];
       end
end
pipe=temp1;

%用temp3存放表中p_num_def数据（不包括表头）
temp3=[];
for i=1:1:m
    if strcmp(raw(i,1),'p_num_def')%||strcmp(raw(i,1),'#P_MUN')
       temp4=temp(i,:);
      temp3=[temp3;temp4];
       end
end
p_num_def=temp3;

%用temp5存放表中Valve数据（不包括表头）
temp5=[];
for i=1:1:m
    if strcmp(raw(i,1),'Valve')%||strcmp(raw(i,1),'#VALVE')
       temp6=temp(i,:);
      temp5=[temp5;temp6];
       end
end
Valve=temp5;


%用temp9存放表中t_def数据（不包括表头）
temp9=[];
for i=1:1:m
    if strcmp(raw(i,1),'t_def')%||strcmp(raw(i,1),'#T')
       temp10=temp(i,:);
      temp9=[temp9;temp10];
       end
end
t_def=temp9;

%用temp11存放表中q_def数据（不包括表头）
temp11=[];
for i=1:1:m
    if strcmp(raw(i,1),'q_def')%||strcmp(raw(i,1),'#Q')

       temp12=temp(i,:);
      temp11=[temp11;temp12];
       end
end
q_def=temp11;

%用temp13存放表中h_def数据（不包括表头）
temp13=[];
for i=1:1:m
    if strcmp(raw(i,1),'h_def')%||strcmp(raw(i,1),'#H')
       temp14=temp(i,:);
      temp13=[temp13;temp14];
       end
end
h_def=temp13;

%temp15中储存得到的BC
temp15=[];
  for  i=1:1:m
     if strcmp(raw(i,1),'Tank')||strcmp(raw(i,1),'Junction')||strcmp(raw(i,1),'Deadend')||strcmp(raw(i,1),'Valve')||strcmp(raw(i,1),'Valve_Junc')||strcmp(raw(i,1),'Hydraulic')
         temp4=temp(i,:);
         temp15=[temp15;temp4];
    end
  end  
 BC=temp15;
end