function im_ROI = F_extractingROI(im)
    %% Description
    % ��Ϊ��ȷ����ȡͼ���ROI
    
    %input:     
    %im:    ԭʼͼ��
    
    %output: 
    %ROI:  ͼ��ĸ���Ȥ����
    
    %%  
    [im_h, im_w] = size(im);
       
    % ��ȡԭʼͼƬ�ı�Եͼ, �������±�Ե�ľ�������
    [im_edge, upperEdge, lowerEdge] = F_edgeDetection(im);

    % ���±�Ե���м���, ���ϱ�Ե��������+�±�Ե�������꣩/ 2
    middleCurve = [upperEdge(:, 1), floor((upperEdge(:, 2) + lowerEdge(:, 2))/2)];

    %��middle curve ����ֱ�����,�õ�middle line
    param = polyfit(middleCurve(:, 1), middleCurve(:, 2), 1);
    fitted_x = 1:im_w;
    fitted_y =  param(1)*fitted_x + param(2);

    %����ϵ�middle lineȷ����ת�Ƕ�, ����ԭͼ�Լ���Եͼ������ת
    thetaDegree = atand((fitted_y(im_w)-fitted_y(1))/im_w);%��ȡ��б�Ƕ�
    edge_rotated = imrotate(im_edge, thetaDegree);%������б�ǶȽ�����ת������Ե
    im_rotated = imrotate(im, thetaDegree);%����ԭͼ

    %�õ���ת��ı�Ե�У��ϱ�Ե����͵㣬 �±�Ե����ߵ�
    upperEdge = edge_rotated;
    upperEdge(ceil(im_h/2):end, :) = 0 ;
    [upperEdgeRow, ~]  = find(upperEdge==1);
    maxRow = max(upperEdgeRow);%�ϱ�Ե����͵㣨����У�

    lowerEdge = edge_rotated;
    lowerEdge(1:floor(im_h/2), :) = 0;
    [lowerEdgeRow, ~] = find(lowerEdge==1);
    minRow = min(lowerEdgeRow)  ;  %�±�Ե����ߵ㣨��С�У�

    im_ROI = im_rotated(maxRow:minRow, :);
    im_ROI = imresize(im_ROI, [120, 260]);
    
end



