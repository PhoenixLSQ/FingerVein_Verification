% 本程序用于输入文件名，显示gabor滤波结果
clc;clear

imgname = '001-4-1';

rootpath = 'F:\·m-retrieve\指静脉\指静脉\pics-per3徐总（LSQ更改）\FvrQuryPics\';
img_path = [rootpath,imgname(1:5),'\',imgname,'.bmp'];

im = imread(img_path);
%% 预处理 1. 去除设备固有干扰  2. 提取ROI
%去除设备固有干扰,将图片进行剪裁
im(235:end, :) = [];   im(1:35, :) = [];
im(:, 295:end) = [];   im(:, 1:5) = [];
% figure;imshow(im,[])

%图像转为灰度以及double
if ndims(im) == 3
    im = rgb2gray(im);
elseif ~isa(im, 'double')
    im = im2double(im);
end

% 图像缩小以加快速度, 看具体情况
%速度够， 就不需要
% im = imresize(im, 0.5);

%精确的ROI提取， 并对ROI做尺度归一化
im_ROI = F_extractingROI(im);
%% 对ROI区域进行gabor增强
%设置gabor滤波器的参数

waveLength = 16:1:18;%gabor滤波器的波长
orien =   22.5:22.5:157.5 ;%gabor滤波器的角度

%利用matlab自带函数构建gabor滤波器
%省略号是续行符
gaborFilter = gabor(waveLength, orien, ...
                                        'SpatialAspectRatio', 1.2, ... %gabor滤波器的参数
                                        'SpatialFrequencyBandwidth', 1.4);%...参数
                                    
%利用gabor滤波器对ROI进行滤波
[gabor_rep, ~] = imgaborfilt(im_ROI, gaborFilter); %只取幅度响应
ROI_enhanced = min(abs(gabor_rep), [], 3);%min的这种用法表示沿着第3个轴进行比较，就是对24个滤波结果取最小
figure,imshow(ROI_enhanced,[min(min(ROI_enhanced)),max(max(ROI_enhanced))])
