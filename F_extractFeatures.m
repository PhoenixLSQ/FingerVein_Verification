function binary_im = F_extractFeatures(im)
%�����飺���ļ����� ��ȡ����
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

% figure,imshow(ROI_enhanced,[min(min(ROI_enhanced)),max(max(ROI_enhanced))])
% ��ʾGaborͼ
%% ��ȡ����Ѫ��
%����ELLBP��ȡѪ��
%�õ�ELLBP
nFiltDims = [7, 7];
isScale = true;
shiftLLBP = F_lineShiftLBP(ROI_enhanced, nFiltDims, isScale);%��ȡELLBP

%��ELLBP���ж�ֵ���� 
thresh = graythresh(shiftLLBP);                       % ��ȡ��ֵ������ֵ
binary_im = imbinarize(shiftLLBP, thresh*1.3); % ����ֵ��1.3�����ж�ֵ��
binary_im(end-5:end, :) = 0; % ɾ�����6�У�ȥ��ѭ�������Ӱ��
binary_im(1:5, :) = 0; % ɾ��ǰ5�У� ȥ��ѭ�������Ӱ��

%ȥ��С�������
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
