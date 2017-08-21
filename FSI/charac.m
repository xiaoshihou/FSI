function charac( nr_of_tsteps,time,cnt,h,q,u,f,hs,ar )
%CHARAC �˴���ʾ�йش˺�����ժҪ
%   �ڴ˺����е��ýṹ��ѡ��ṹ
% �������
% nr_of_tsteps - the number of time steps the iteration will run
% time - used as input parameter in the boundary conditions tank and valve
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp up fp BC%�����洢�õ�������
for i = 1:nr_of_tsteps    %��������

%%%%%%%%%%%%%%%%%%%%%%% �ڲ��ڵ㴦ѹ��ͷ��������Ӧ���͹ܵ������ٶȵļ��� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pipe_inner(cnt,h,q,u,f,ar);

%%�����ӳ������߽�����
    for j = 1:size(BC,1)  %size(BC,1)��ʾBC������(j=1:3)
        BCtype = BC{j,1};%BC�ĵ�һ�б�ʾ���Ǳ߽������
        switch BCtype
           case 'Tank'
               tank(j,time,cnt,h,q,u,f,ar);
           case 'Valve'
               valve2(j,time,cnt,q,h,hs,u,f,ar);
%             case'Valve_Junc'
%                 valve5(j,time,cnt,q,h,hs);
           %������·֮�������
            case 'Junction'
                pipe_junc(j,cnt,h,q,u,f,ar);
           %�ն�
            case 'Deadend'
               deadend(j,time,cnt,h,q);
            case 'Hydraulic'
                hydraulic1(j,time,cnt,h,q);
%            case 'Valvedwn';
%                valvedwn(j);
%             case 'Orifice';
%                valvedwn(j);
        end
    end
%     for row=1:size(pipes,1)
%         pipes{row,1}(2,:) = pipes{row,1}(1,:);%��pipes��һ��Ԫ�صĵ�һ�и����ڶ���
%         pipes{row,2}(2,:) = pipes{row,2}(1,:);%��pipes�ڶ���Ԫ�صĵ�һ�и����ڶ���
%     end
end
end

