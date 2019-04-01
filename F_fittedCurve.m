function fittedCoord = F_fittedCurve(im_edge)
    %%Description
    % �������ı�Եͼ������������ϡ�
    %    ע�����ÿ�ν����һ�����ߣ�Ҳ�����ϱ�Ե���±�ԵҪ�ֱ�������
    
    %input:     
    %im_edge��  ͼ���Եͼ��һ�루�ϰ��Եͼ�����°��Եͼ��
    
    %output�� 
    %fittedCoord��  ��ϵõ������ߵ����꣬n��2 �ľ���
    %                       ��һ���Ǻ����꣬�ڶ�����������

%%
    [im_h, im_w] = size(im_edge);
    
    %�ҵ���Ե��ĺ�������
    [lowerEdge_y, lowerEdge_x] = find( im_edge== 1);
    
    %�����Ե��ĺ����������3��������ϣ����õ�4�����߲���
    %param��һ��4 ��1�����飬��ŵ����ߵ�4��������
    param = polyfit(lowerEdge_x, lowerEdge_y, 3);
    fitted_x = 1:im_w;
    fitted_y =  param(1)*fitted_x.^3 +...
                     param(2)*fitted_x.^2 + ...
                     param(3)*fitted_x +...
                     param(4) ;
                 
   %����Ϻ��yֵ������,�Է�����ͼ���С��
   fitted_y = floor(fitted_y);              
   fitted_y(fitted_y<=1) = 1;  
   fitted_y(fitted_y>=im_h) = im_h;
   
   fittedCoord =floor([fitted_x', fitted_y']);
end