% ���������������ļ�������ʾgabor�˲����
clc;clear

imgname = '001-4-1';

rootpath = 'F:\��m-retrieve\ָ����\ָ����\pics-per3���ܣ�LSQ���ģ�\FvrQuryPics\';
img_path = [rootpath,imgname(1:5),'\',imgname,'.bmp'];

im = imread(img_path);
%% Ԥ���� 1. ȥ���豸���и���  2. ��ȡROI
%ȥ���豸���и���,��ͼƬ���м���
im(235:end, :) = [];   im(1:35, :) = [];
im(:, 295:end) = [];   im(:, 1:5) = [];
% figure;imshow(im,[])

%ͼ��תΪ�Ҷ��Լ�double
if ndims(im) == 3
    im = rgb2gray(im);
elseif ~isa(im, 'double')
    im = im2double(im);
end

% ͼ����С�Լӿ��ٶ�, ���������
%�ٶȹ��� �Ͳ���Ҫ
% im = imresize(im, 0.5);

%��ȷ��ROI��ȡ�� ����ROI���߶ȹ�һ��
im_ROI = F_extractingROI(im);
%% ��ROI�������gabor��ǿ
%����gabor�˲����Ĳ���

waveLength = 16:1:18;%gabor�˲����Ĳ���
orien =   22.5:22.5:157.5 ;%gabor�˲����ĽǶ�

%����matlab�Դ���������gabor�˲���
%ʡ�Ժ������з�
gaborFilter = gabor(waveLength, orien, ...
                                        'SpatialAspectRatio', 1.2, ... %gabor�˲����Ĳ���
                                        'SpatialFrequencyBandwidth', 1.4);%...����
                                    
%����gabor�˲�����ROI�����˲�
[gabor_rep, ~] = imgaborfilt(im_ROI, gaborFilter); %ֻȡ������Ӧ
ROI_enhanced = min(abs(gabor_rep), [], 3);%min�������÷���ʾ���ŵ�3������бȽϣ����Ƕ�24���˲����ȡ��С
figure,imshow(ROI_enhanced,[min(min(ROI_enhanced)),max(max(ROI_enhanced))])
