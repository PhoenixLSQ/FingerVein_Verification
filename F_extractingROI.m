function im_ROI = F_extractingROI(im)
    %% Description
    % 较为精确的提取图像的ROI
    
    %input:     
    %im:    原始图像
    
    %output: 
    %ROI:  图像的感兴趣区域
    
    %%  
    [im_h, im_w] = size(im);
       
    % 获取原始图片的边缘图, 及其上下边缘的具体坐标
    [im_edge, upperEdge, lowerEdge] = F_edgeDetection(im);

    % 上下边缘的中间线, （上边缘的纵坐标+下边缘的纵坐标）/ 2
    middleCurve = [upperEdge(:, 1), floor((upperEdge(:, 2) + lowerEdge(:, 2))/2)];

    %对middle curve 进行直线拟合,得到middle line
    param = polyfit(middleCurve(:, 1), middleCurve(:, 2), 1);
    fitted_x = 1:im_w;
    fitted_y =  param(1)*fitted_x + param(2);

    %由拟合的middle line确定旋转角度, 并对原图以及边缘图进行旋转
    thetaDegree = atand((fitted_y(im_w)-fitted_y(1))/im_w);%求取倾斜角度
    edge_rotated = imrotate(im_edge, thetaDegree);%根据倾斜角度进行旋转矫正边缘
    im_rotated = imrotate(im, thetaDegree);%矫正原图

    %得到旋转后的边缘中，上边缘的最低点， 下边缘的最高点
    upperEdge = edge_rotated;
    upperEdge(ceil(im_h/2):end, :) = 0 ;
    [upperEdgeRow, ~]  = find(upperEdge==1);
    maxRow = max(upperEdgeRow);%上边缘的最低点（最大行）

    lowerEdge = edge_rotated;
    lowerEdge(1:floor(im_h/2), :) = 0;
    [lowerEdgeRow, ~] = find(lowerEdge==1);
    minRow = min(lowerEdgeRow)  ;  %下边缘的最高点（最小行）

    im_ROI = im_rotated(maxRow:minRow, :);
    im_ROI = imresize(im_ROI, [120, 260]);
    
end



