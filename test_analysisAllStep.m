% test_analysisAllStep
% close all;

imgname1 = '028-6\2018-09-29-13_56_16.bmp';
imgname2 = '015-2\2018-11-01-14_12_05.bmp';
% imgname1 = '001-1\001-1-1.bmp';
% imgname2 = '001-2\001-2-1.bmp';


ftpath = 'F:\·m-retrieve\指静脉\指静脉\pics-original\FvrQuryPicsEllbp\';
imgpath = 'F:\·m-retrieve\指静脉\指静脉\pics-original\FvrQuryPics\';
im1 = imread([ftpath,imgname1]);
im2 = imread([ftpath,imgname2]);
im1 = imresize(im1,0.6);
im2 = imresize(im2,0.6);

figure;
subplot(2,1,1),imshow(imread([imgpath,imgname1])),title(imgname1);
subplot(2,1,2),imshow(imread([imgpath,imgname2])),title(imgname2);
[probe_calib, gallery_calib, row, col,corrmaxvalue] = Q_getCalibration_limit(im1, im2);
figure;
subplot(2,1,1),imshow(im1),title([num2str([row,col]),'  ',num2str(corrmaxvalue)])
subplot(2,1,2),imshow(im2);
figure;
subplot(2,1,2),imshow(probe_calib);
subplot(2,1,1),imshow(gallery_calib);
%将probe_calib 和 gallery_calib进行细化操作，得到vein network
probe_calib_skel = bwmorph(probe_calib, 'skel', inf);
gallery_calib_skel = bwmorph(gallery_calib, 'skel', inf);

%% 衡量probe和gallery之间的相似度

% overlap degree--
%利用probe_calib和gallery_calib计算基于backbone的重合度
overlapDegree = 2*sum(sum(probe_calib&gallery_calib)) / (sum(im1(:))+sum(im2(:)));

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

disp (['overlapDegree:',num2str(overlapDegree)]);
%---- elastic score  
%利用probe_calib_skel和gallery_calib_skel，计算基于network之间的相似度
neighborSize = 5; %5;
elasticScore_probe = F_getElasticScore(probe_calib_skel,  gallery_calib_skel, ...
                                                neighborSize,   length(find(probe_calib_skel==1)));
disp (['elasticScore_probe:',num2str(elasticScore_probe)]);

elasticScore_gallery = F_getElasticScore(gallery_calib_skel, probe_calib_skel, ...
                                                neighborSize,   length(find(gallery_calib_skel==1)));   
disp (['elasticScore_gallery:',num2str(elasticScore_gallery)]);

elasticScore = max(elasticScore_probe, elasticScore_gallery);
disp (['elasticScore:',num2str(elasticScore)]);

%综合 overlap degree 和elastic score得到最终的score
score = sqrt(overlapDegree*elasticScore);
disp (['score:',num2str(score)]);