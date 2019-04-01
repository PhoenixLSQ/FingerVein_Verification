function binary_im = F_extractFeatures(im)
%程序简介：本文件用于 提取特征
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

% figure,imshow(ROI_enhanced,[min(min(ROI_enhanced)),max(max(ROI_enhanced))])
% 显示Gabor图
%% 提取静脉血管
%基于ELLBP提取血管
%得到ELLBP
nFiltDims = [7, 7];
isScale = true;
shiftLLBP = F_lineShiftLBP(ROI_enhanced, nFiltDims, isScale);%提取ELLBP

%对ELLBP进行二值化， 
thresh = graythresh(shiftLLBP);                       % 获取二值化的阈值
binary_im = imbinarize(shiftLLBP, thresh*1.3); % 用阈值的1.3倍进行二值化
binary_im(end-5:end, :) = 0; % 删除最后6行，去除循环卷积的影响
binary_im(1:5, :) = 0; % 删除前5行， 去除循环卷积的影响

%去除小面积区域
regionProp  = regionprops(binary_im, 'PixelList', 'Area');
regionIdx = {regionProp(:).PixelList};
regionArea = [regionProp(:).Area];
idx = find(regionArea<=100);
for iPiexlList = 1 : length(idx)
   
    subscripts = regionIdx{idx(iPiexlList)};
    subscripts = subscripts(:, 2:-1:1);
    linear_idx  = sub2ind(size(binary_im), subscripts(:, 1), subscripts(:, 2));
    binary_im(linear_idx) = 0;
    
end
end
