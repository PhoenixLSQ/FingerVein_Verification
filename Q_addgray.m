% �˺�������ɾ���������ͼƬ��ͬʱ��������ͼƬ����Ҷ�ֵ��5���滻֮��
% ����������Ҫɾ����ͼƬ��������Ҫ�����滻��ͼƬ�����ɡ�
clc;clear

foldername = '028-3';                          % �����ļ�����
dltname = 'grayV2018-09-29-13_51_12';          % ��Ҫɾ����ͼƬ����
rplname = '2018-09-29-13_51_21';               % ��Ҫ�����滻��ͼƬ�� replace

% ��������·��ΪҪ������ɾ�����ļ�·���������ñ��ݡ�
% �����ļ���Ϊ F:\��m-retrieve\ָ����\ָ����\pics-original\
path = 'F:\��m-retrieve\ָ����\ָ����\pics\FvrQuryPics\';
ftpath = 'F:\��m-retrieve\ָ����\ָ����\pics\FvrQuryPicsEllbp\';

delete([path,foldername,'\',dltname,'.bmp']);     % ɾ��ԭͼ
delete([ftpath,foldername,'\',dltname,'.bmp']);   % ɾ������ͼ

% ����5�Ҷ�ֵ��������ԭ�ļ���
img = imread([path,foldername,'\',rplname,'.bmp']);
img_add = img + 15;
imwrite(img_add,[path,foldername,'\','grayXV',rplname,'.bmp']);

% ��ȡ�����滻�������ͼ��������ԭ�����ļ���
ft_add = F_extractFeatures(img_add);
imwrite(ft_add,[ftpath,foldername,'\','grayXV',rplname,'.bmp']);