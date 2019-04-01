%test_withinClassScoreCount3
%�˳������ڲ������ƥ����ļ������Ӧ����
clear;
% imgFolderList = dir('.\imgAll\FvrDataBase_V1.0_Ellbp');%��ȡ���д���ͼƬ���ļ���
imgFolderList = dir('.\20190117Ellbp');%��ȡ���д���ͼƬ���ļ���

withinClassImgNameScoreFvrDataBaseV1sort = cell(1,6);

%����һ�µȻ�Ҫ�õĲ���
numOfMatch = 0;

for num1 = 3:1:length(imgFolderList)   %list��ǰ���������ļ��У�ȥ��
    imgSampleList = dir([imgFolderList(num1).folder,'\',imgFolderList(num1).name]);%����ļ����г�ȥ��Ч���ַ��������е�ͼƬ
    
    for num2 = 3:1:length(imgSampleList)   %list��ǰ���������ļ��У�ȥ��
        imgSample = imread(strcat(imgSampleList(num2).folder,'\',imgSampleList(num2).name));   %��ȡ�ļ����е�ͼƬ
        for num3  = 4:1:length(imgSampleList)
            if ~(strcmp(imgSampleList(num3).name,imgSampleList(num2).name))   %�����ʱѭ������ͼƬ������ͬ�Ž���ƥ��
                imgBank = imread(strcat(imgSampleList(num3).folder,'\',imgSampleList(num3).name));
                
                [score,pos,corrmaxvalue] = Q_measureSimilarity(imresize(imgSample,0.6),imresize(imgBank,0.6));
                numOfMatch = numOfMatch + 1;
                
                withinClassImgNameScoreFvrDataBaseV1sort(numOfMatch,:) = {imgSampleList(num2).name,...
                                                                                imgSampleList(num3).name,...
                                                                                  score,...
                                                                                    imgSampleList(3).folder(end-4:end),...
                                                                                      pos,...
                                                                                        corrmaxvalue};
                
                disp(numOfMatch);
                
            end
        end
    end
end
save('1v1_Within0117.mat','withinClassImgNameScoreFvrDataBaseV1sort');
load splat;
sound(y,Fs);
