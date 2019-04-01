
function [probe_calibrated, gallery_calibrated] = F_getCalibration(probe, gallery)
    %对 probe 和 gallery
    % (actually , just find translation along x and y)
    % this parameter can rotate img_2, crop img_2 and crop template
    
    %input : 
    %probe : prob image 
    %gallery:     gallery image

    
    %output:
    %temp_calibrated: calibrated prob image 
    %img_calibrated:  calibrated gallery image 


    [temp_h, temp_w] = size(probe);  
    

    corrMap_selected = abs(normxcorr2(probe, gallery));
    if nargin<2
        error('not enough input argument');
    end


                                        
     %find the max similarity's position in correlation map
    [row, col] = find(corrMap_selected ==max(corrMap_selected(:)));%矩阵最大值对应的坐标即为平移量
    if length(row)>=1%防止矩阵中有多个相等的最大值
        row = row(1);
        col = col(1);
    end
    
    
     img_optimal = gallery;%imrotate(img_2, param.rotation);
     [img_optimal_h, img_optimal_w] = size(img_optimal);
    
    %template的上半区域,没有进入 img_optimal
    if row<= temp_h 
        if col<=temp_w %template的左边没完全进入
            probe_calibrated = probe(temp_h-row+1:temp_h, temp_w-col+1:end);
            gallery_calibrated = img_optimal(1:row, 1:col);

            
        elseif  temp_w<col && col<= img_optimal_w %template的左右完全进入
            probe_calibrated = probe(temp_h-row+1:temp_h, :);
            gallery_calibrated = img_optimal(1: row, col-temp_w+1:col);

        elseif col > img_optimal_w %template的右侧出去了
            probe_calibrated = probe(temp_h-row+1:temp_h, 1:temp_w-(col-img_optimal_w)) ;
            gallery_calibrated = img_optimal(1: row, col-temp_w+1:img_optimal_w);
        end     
        

    %template, 上下边完全在 img_optimal内部       
    elseif temp_h <row && row<= img_optimal_h 
        if col<=temp_w %template的左边界在外
            probe_calibrated = probe(1:end, temp_w-col+1:temp_w);
            gallery_calibrated = img_optimal(row-temp_h+1:row, 1:col);

        elseif   temp_w<col && col<= img_optimal_w%template左右边界完全进入
            probe_calibrated = probe;
            gallery_calibrated = img_optimal(row-temp_h+1:row,col-temp_w+1:col);

        elseif col>img_optimal_w %template的右边界在外
            probe_calibrated = probe(1:end, 1:temp_w-(col-img_optimal_w));
            gallery_calibrated = img_optimal(row-temp_h+1:row,col-temp_w+1:img_optimal_w);

        end
                

        
    %template的下边界 出了内部
    elseif row>img_optimal_h
        if col < temp_w %template的左边界在外
             probe_calibrated = probe(1:temp_h-(row-img_optimal_h),temp_w-col+1:temp_w);
             gallery_calibrated = img_optimal(row-temp_h+1:img_optimal_h, 1:col);

        elseif temp_w<=col && col<=img_optimal_w
             probe_calibrated = probe(1:temp_h-(row-img_optimal_h),1:end);
             gallery_calibrated = img_optimal(row-temp_h+1:img_optimal_h, col-temp_w+1:col);

             
        elseif  col>img_optimal_w
            probe_calibrated = probe(1:temp_h-(row-img_optimal_h),1:temp_w-(col-img_optimal_w));
            gallery_calibrated = img_optimal(row-temp_h+1:img_optimal_h, col-temp_w+1:img_optimal_w);

         end

        
    end

end
