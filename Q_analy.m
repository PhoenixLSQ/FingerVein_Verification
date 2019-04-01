% test_analysisAllStep
function Q_analy(querypath,bankpath)
im1 = imread(querypath);
im2 = imread(bankpath);
im1 = imresize(im1,0.6);
im2 = imresize(im2,0.6);
[probe_calib, gallery_calib, row, col,corrmaxvalue] = Q_getCalibration(im1, im2);
% figure;imshow(im1);figure;imshow(im2);
% figure;imshow(probe_calib);figure;imshow(gallery_calib);
pos = [row,col];
figure;
subplot(2,1,1),imshow(probe_calib),title(['calib',querypath(46:end-4),'  ',num2str(pos),'  ',num2str(corrmaxvalue)],'Interpreter','none');
subplot(2,1,2),imshow(gallery_calib),title(['calib',bankpath(46:end-4)],'Interpreter','none');
set(gcf,'position',[1210 480 500 500]);

disp(querypath(46:end-4))
disp(bankpath(46:end-4))
%��probe_calib �� gallery_calib����ϸ���������õ�vein network
probe_calib_skel = bwmorph(probe_calib, 'skel', inf);
gallery_calib_skel = bwmorph(gallery_calib, 'skel', inf);

%% ����probe��gallery֮������ƶ�

% overlap degree--
%����probe_calib��gallery_calib�������backbone���غ϶�
overlapDegree = 2*sum(sum(probe_calib&gallery_calib)) / (sum(im1(:))+sum(im2(:)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 1.18 ����
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