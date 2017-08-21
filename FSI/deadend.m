function deadend( BCIndex,time,cnt,h,q  )
%deadend �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% BCIndex - BC������ĳЩ�߽������ı��
% time - used as input parameter in the boundary conditions tank and valve
global pressure  discharge p_num_def pipe Valve t_def q_def h_def ca cf n nn qp hp BC
    pipe1 = BC{BCIndex,3}; %�ն�ǰ�Ĺ�·���
    pipe2 = BC{BCIndex,4}; %�ն˺�Ĺ�·���
    if pipe1==0 %�ն�λ�����β�
        cn_end=q(pipe2,2)-ca(pipe2)*h(pipe2,2)-cf(pipe2)*q(pipe2,2)*abs(q(pipe2,2));
        qp(pipe2,1)=0;
        hp(pipe2,1)=-(cn_end/ca(pipe2));
            %%%%%%%%%%%%%���¾���%%%%%%%%%%%%%
    pressure{cnt+1,3}(pipe2,1)=hp(pipe2,1);%�����һ���ڵ��ѹͷ
    discharge{cnt+1,3}(pipe2,1)=qp(pipe2,1);%�����һ���ڵ������
    elseif pipe2==0 %�ն�λ�����β�
        cp_end=q(pipe1,n(pipe1))+ca(pipe1)*h(pipe1,n(pipe1))-cf(pipe1)*q(pipe1,n(pipe1))*abs(q(pipe1,n(pipe1)));
        qp(pipe1,nn(pipe1))=0;
        hp(pipe1,nn(pipe1))=cp_end/ca(pipe1);
        %%%%%%%%%%%%%%%%%%%%%%  ���¹�·���� %%%%%%%%%%%%%%%%%%%%%%%%%%
    pressure{cnt+1,3}(pipe1,nn(pipe1))=hp(pipe1,nn(pipe1));%�����һ���ڵ��ѹͷ
    discharge{cnt+1,3}(pipe1,nn(pipe1))=qp(pipe1,nn(pipe1));%�����һ���ڵ������
    end
        
end

