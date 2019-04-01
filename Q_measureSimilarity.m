function  [score,pos,corrmaxvalue,overlapDegree,elasticScore]= Q_measureSimilarity(probe, gallery)
%% 
%衡量库图特征与测试图特征之间的相似度

%input
%probe： 测试图的血管, 二值图
%gallery： 库图的血管， 二值图
    

%output
%score：                     reElastic score。最终的相似度
%overlapDegree：       backbone的重合度
%elasticScore:             network之间的相似度

%note： score = sqrt(overlapDegree*elasticScore)
    
    %对probe和gallery进行平移配准，
    %得到配准后的结果probe_calib 和 gallery_calib
     [probe_calib, gallery_calib,row,col,corrmaxvalue] = Q_getCalibration_limit(probe, gallery);
                
        
     %将probe_calib 和 gallery_calib进行细化操作，得到vein network
     probe_calib_skel = bwmorph(probe_calib, 'skel', inf);
     gallery_calib_skel = bwmorph(gallery_calib, 'skel', inf);


    %% 衡量probe和gallery之间的相似度
   
    % overlap degree--
    %利用probe_calib和gallery_calib计算基于backbone的重合度
    overlapDegree = 2*sum(sum(probe_calib&gallery_calib)) / (sum(probe(:))+sum(gallery(:)));
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 1.18 增加
%默认参数如下：
% corrThresh = 0.27;       unf_factor = 0.1;    incremt_factor = 0.4;

corrThresh = 0.27;
unf_factor = 0.1;               % uniform factor
incremt_factor = 0.4;           % increment factor

if corrmaxvalue > corrThresh + unf_factor
    corrv = corrThresh + unf_factor;   % corrvalue 缩写 corrv
elseif corrmaxvalue < corrThresh - unf_factor
    corrv = corrThresh - unf_factor;
else
    corrv = corrmaxvalue;
end

alpha = (corrv - 0.27) / unf_factor * incremt_factor + 1;
overlapDegree = overlapDegree * alpha;

if overlapDegree > 1
    overlapDegree = 1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %---- elastic score  
    %利用probe_calib_skel和gallery_calib_skel，计算基于network之间的相似度
    neighborSize = 5;%5;
    elasticScore_probe = F_getElasticScore(probe_calib_skel,  gallery_calib_skel, ...
                                                    neighborSize,   length(find(probe_calib_skel==1)));
                                                
    elasticScore_gallery = F_getElasticScore(gallery_calib_skel, probe_calib_skel, ...
                                                    neighborSize,   length(find(gallery_calib_skel==1)));   
                                                
    elasticScore = max(elasticScore_probe, elasticScore_gallery);

    %综合 overlap degree 和elastic score得到最终的score
    score = sqrt(overlapDegree*elasticScore);
    pos = [row,col];
end