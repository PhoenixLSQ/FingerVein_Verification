function  [score,pos,corrmaxvalue,overlapDegree,elasticScore]= Q_measureSimilarity(probe, gallery)
%% 
%������ͼ���������ͼ����֮������ƶ�

%input
%probe�� ����ͼ��Ѫ��, ��ֵͼ
%gallery�� ��ͼ��Ѫ�ܣ� ��ֵͼ
    

%output
%score��                     reElastic score�����յ����ƶ�
%overlapDegree��       backbone���غ϶�
%elasticScore:             network֮������ƶ�

%note�� score = sqrt(overlapDegree*elasticScore)
    
    %��probe��gallery����ƽ����׼��
    %�õ���׼��Ľ��probe_calib �� gallery_calib
     [probe_calib, gallery_calib,row,col,corrmaxvalue] = Q_getCalibration_limit(probe, gallery);
                
        
     %��probe_calib �� gallery_calib����ϸ���������õ�vein network
     probe_calib_skel = bwmorph(probe_calib, 'skel', inf);
     gallery_calib_skel = bwmorph(gallery_calib, 'skel', inf);


    %% ����probe��gallery֮������ƶ�
   
    % overlap degree--
    %����probe_calib��gallery_calib�������backbone���غ϶�
    overlapDegree = 2*sum(sum(probe_calib&gallery_calib)) / (sum(probe(:))+sum(gallery(:)));
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 1.18 ����
%Ĭ�ϲ������£�
% corrThresh = 0.27;       unf_factor = 0.1;    incremt_factor = 0.4;

corrThresh = 0.27;
unf_factor = 0.1;               % uniform factor
incremt_factor = 0.4;           % increment factor

if corrmaxvalue > corrThresh + unf_factor
    corrv = corrThresh + unf_factor;   % corrvalue ��д corrv
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
    %����probe_calib_skel��gallery_calib_skel���������network֮������ƶ�
    neighborSize = 5;%5;
    elasticScore_probe = F_getElasticScore(probe_calib_skel,  gallery_calib_skel, ...
                                                    neighborSize,   length(find(probe_calib_skel==1)));
                                                
    elasticScore_gallery = F_getElasticScore(gallery_calib_skel, probe_calib_skel, ...
                                                    neighborSize,   length(find(gallery_calib_skel==1)));   
                                                
    elasticScore = max(elasticScore_probe, elasticScore_gallery);

    %�ۺ� overlap degree ��elastic score�õ����յ�score
    score = sqrt(overlapDegree*elasticScore);
    pos = [row,col];
end