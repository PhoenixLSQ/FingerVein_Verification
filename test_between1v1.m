%test_betweenClassScoreCount3
%�˳������ڲ������ƥ����ļ������Ӧ����
clear;

imgFolderList = dir('.\20190117Ellbp');%��ȡ���д���ͼƬ���ļ���

%cell��ÿһ�зֱ���sample�����Աȵ�ͼƬ�����ж�Ӧ��ellbp������SURF���������
betweenClassImgNameScoreFvrDataBaseV1sort = cell(1, 7);

%����һ�µȻ�Ҫ�õĲ���
numOfMatch = 0;
tic
for num1 = 3:1:length(imgFolderList)    % list��ǰ���������ļ��У�ȥ��
    imgSampleList = dir([imgFolderList(num1).folder,'\',imgFolderList(num1).name]);    % ����ļ����г�ȥ��Ч���ַ��������е�ͼƬ
    
    for num2 = 3:1:3    %list��ǰ���������ļ��У�ȥ����ȡһ���ڵ�����ͼƬ
        imgSample = imread(strcat(imgSampleList(num2).folder,'\',imgSampleList(num2).name));    %��ȡ�ļ����е�ͼƬ
        
        for num3  = 3:1:length(imgFolderList)
            imgList = dir([imgFolderList(num3).folder,'\',imgFolderList(num3).name]);    %��ȡ�����е��ļ���
            
            for num4 = 4:1:length(imgList)%ÿһ��ĵڶ���ͼƬ��������ͼƬ
                %��ȡ�������ͼƬ�����бȽ�,�������ļ����������ж��ǲ�������
                if ~(strcmp(imgList(num4).folder,imgSampleList(num2).folder)) % ��� ��ʱѭ�������ļ��к�����ͬ�Ž���ƥ��
                    imgBank = imread(strcat(imgList(num4).folder,'\',imgList(num4).name));
                    numOfMatch = numOfMatch + 1;
                    disp(numOfMatch);
                    
                    [score,pos,corrmaxvalue] = Q_measureSimilarity(imresize(imgSample,0.6),imresize(imgBank,0.6));
                    
                    betweenClassImgNameScoreFvrDataBaseV1sort(numOfMatch,:) = {imgSampleList(num2).name,...
                                                                                    imgList(num4).name,...
                                                                                        score,...
                                                                                            imgSampleList(1).folder(end-4:end),...
                                                                                                imgList(1).folder(end-4:end),...
                                                                                                    pos,...
                                                                                                        corrmaxvalue};
                    
                    
                    
                end
            end
        end
    end
end
toc
save('1v1_Between0117.mat','betweenClassImgNameScoreFvrDataBaseV1sort');

load splat;
sound(y,Fs);