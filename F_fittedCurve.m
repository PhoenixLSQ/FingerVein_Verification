function fittedCoord = F_fittedCurve(im_edge)
    %%Description
    % 针对输入的边缘图，进行曲线拟合。
    %    注意的是每次仅拟合一条曲线，也就是上边缘和下边缘要分别进行拟合
    
    %input:     
    %im_edge：  图像边缘图的一半（上半边缘图或者下半边缘图）
    
    %output： 
    %fittedCoord：  拟合得到的曲线的坐标，n×2 的矩阵。
    %                       第一列是横坐标，第二列是纵坐标

%%
    [im_h, im_w] = size(im_edge);
    
    %找到边缘点的横纵坐标
    [lowerEdge_y, lowerEdge_x] = find( im_edge== 1);
    
    %输入边缘点的横纵坐标进行3阶曲线拟合，并得到4个曲线参数
    %param是一个4 ×1的数组，存放的曲线的4个参数。
    param = polyfit(lowerEdge_x, lowerEdge_y, 3);
    fitted_x = 1:im_w;
    fitted_y =  param(1)*fitted_x.^3 +...
                     param(2)*fitted_x.^2 + ...
                     param(3)*fitted_x +...
                     param(4) ;
                 
   %对拟合后的y值做限制,以防超出图像大小。
   fitted_y = floor(fitted_y);              
   fitted_y(fitted_y<=1) = 1;  
   fitted_y(fitted_y>=im_h) = im_h;
   
   fittedCoord =floor([fitted_x', fitted_y']);
end