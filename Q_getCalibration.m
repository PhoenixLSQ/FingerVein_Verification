
function [probe_calibrated, gallery_calibrated, row, col,corrmaxvalue] = Q_getCalibration(probe, gallery)
    % �� probe �� gallery
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
    
% ͼ���СΪ 72 x 156,���Խ���Χ���Ƶ� row_min - row_max ,col_min - col_max
row_min = 1;
row_max = 143;
col_min = 1;
col_max = 311;
corrMap_lim = corrMap_selected(row_min:row_max,col_min:col_max);
                                        
     %find the max similarity's position in correlation map
    [row, col] = find(corrMap_selected == max(corrMap_lim(:)));%�������ֵ��Ӧ�����꼴Ϊƽ����
    if length(row)>=1%��ֹ�������ж����ȵ����ֵ
        row =  row(row >= row_min & row <= row_max);
        row = row(1);
        col =  col(col >= col_min & col <= col_max);
        col = col(1);
    end
    
    corrmaxvalue = corrMap_selected(row,col);
%     row = 72;
%     col = 147;
    
     img_optimal = gallery;%imrotate(img_2, param.rotation);
     [img_optimal_h, img_optimal_w] = size(img_optimal);
    
    %template���ϰ�����,û�н��� img_optimal
    if row<= temp_h 
        if col<=temp_w %template�����û��ȫ����
            probe_calibrated = probe(temp_h-row+1:temp_h, temp_w-col+1:end);
            gallery_calibrated = img_optimal(1:row, 1:col);

            
        elseif  temp_w<col && col<= img_optimal_w %template��������ȫ����
            probe_calibrated = probe(temp_h-row+1:temp_h, :);
            gallery_calibrated = img_optimal(1: row, col-temp_w+1:col);

        elseif col > img_optimal_w %template���Ҳ��ȥ��
            probe_calibrated = probe(temp_h-row+1:temp_h, 1:temp_w-(col-img_optimal_w)) ;
            gallery_calibrated = img_optimal(1: row, col-temp_w+1:img_optimal_w);
        end     
        

    %template, ���±���ȫ�� img_optimal�ڲ�       
    elseif temp_h <row && row<= img_optimal_h 
        if col<=temp_w %template����߽�����
            probe_calibrated = probe(1:end, temp_w-col+1:temp_w);
            gallery_calibrated = img_optimal(row-temp_h+1:row, 1:col);

        elseif   temp_w<col && col<= img_optimal_w%template���ұ߽���ȫ����
            probe_calibrated = probe;
            gallery_calibrated = img_optimal(row-temp_h+1:row,col-temp_w+1:col);

        elseif col>img_optimal_w %template���ұ߽�����
            probe_calibrated = probe(1:end, 1:temp_w-(col-img_optimal_w));
            gallery_calibrated = img_optimal(row-temp_h+1:row,col-temp_w+1:img_optimal_w);

        end
                

        
    %template���±߽� �����ڲ�
    elseif row>img_optimal_h
        if col < temp_w %template����߽�����
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
