% 此函数可以删除有问题的图片的同时，用其他图片整体灰度值加5来替换之。
% 仅需输入需要删除的图片名，及需要用来替换的图片名即可。
clc;clear

foldername = '028-3';                          % 输入文件夹名
dltname = 'grayV2018-09-29-13_51_12';          % 需要删除的图片名称
rplname = '2018-09-29-13_51_21';               % 需要用来替换的图片名 replace

% 以下两个路径为要做更改删除的文件路径，请做好备份。
% 备份文件夹为 F:\·m-retrieve\指静脉\指静脉\pics-original\
path = 'F:\·m-retrieve\指静脉\指静脉\pics\FvrQuryPics\';
ftpath = 'F:\·m-retrieve\指静脉\指静脉\pics\FvrQuryPicsEllbp\';

delete([path,foldername,'\',dltname,'.bmp']);     % 删除原图
delete([ftpath,foldername,'\',dltname,'.bmp']);   % 删除特征图

% 增加5灰度值，并放入原文件夹
img = imread([path,foldername,'\',rplname,'.bmp']);
img_add = img + 15;
imwrite(img_add,[path,foldername,'\','grayXV',rplname,'.bmp']);

% 提取特征替换后的特征图，并放入原特征文件夹
ft_add = F_extractFeatures(img_add);
imwrite(ft_add,[ftpath,foldername,'\','grayXV',rplname,'.bmp']);