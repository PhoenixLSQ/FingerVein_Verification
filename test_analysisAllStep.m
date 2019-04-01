% test_analysisAllStep
% close all;

imgname1 = '028-6\2018-09-29-13_56_16.bmp';
imgname2 = '015-2\2018-11-01-14_12_05.bmp';
% imgname1 = '001-1\001-1-1.bmp';
% imgname2 = '001-2\001-2-1.bmp';


ftpath = 'F:\��m-retrieve\ָ����\ָ����\pics-original\FvrQuryPicsEllbp\';
imgpath = 'F:\��m-retrieve\ָ����\ָ����\pics-original\FvrQuryPics\';
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
%��probe_calib �� gallery_calib����ϸ���������õ�vein network
probe_calib_skel = bwmorph(probe_calib, 'skel', inf);
gallery_calib_skel = bwmorph(gallery_calib, 'skel', inf);

%% ����probe��gallery֮������ƶ�

% overlap degree--
%����probe_calib��gallery_calib�������backbone���غ϶�
overlapDegree = 2*sum(sum(probe_calib&gallery_calib)) / (sum(im1(:))+sum(im2(:)));

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

disp (['overlapDegree:',num2str(overlapDegree)]);
%---- elastic score  
%����probe_calib_skel��gallery_calib_skel���������network֮������ƶ�
neighborSize = 5; %5;
elasticScore_probe = F_getElasticScore(probe_calib_skel,  gallery_calib_skel, ...
                                                neighborSize,   length(find(probe_calib_skel==1)));
disp (['elasticScore_probe:',num2str(elasticScore_probe)]);

elasticScore_gallery = F_getElasticScore(gallery_calib_skel, probe_calib_skel, ...
                                                neighborSize,   length(find(gallery_calib_skel==1)));   
disp (['elasticScore_gallery:',num2str(elasticScore_gallery)]);

elasticScore = max(elasticScore_probe, elasticScore_gallery);
disp (['elasticScore:',num2str(elasticScore)]);

%�ۺ� overlap degree ��elastic score�õ����յ�score
score = sqrt(overlapDegree*elasticScore);
disp (['score:',num2str(score)]);