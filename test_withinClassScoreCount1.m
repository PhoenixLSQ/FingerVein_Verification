%test_withinClassScoreCount1
%�˳������ڲ������ƥ����ļ������Ӧ����
clear;

imgFoldername = 'F:\��m-retrieve\ָ����\ָ����\pics-0.54%frr\';
imgFolderList = dir([imgFoldername,'FvrQuryPicsEllbp']);%��ȡ���д���ͼƬ���ļ���

% imgFolderList = dir('.\FvrQuryPicsEllbp');%��ȡ���д���ͼƬ���ļ���


%cell��ÿһ�зֱ���sample�����Աȵ�ͼƬ�����ж�Ӧ��ellbp������SURF���������
withinClassImgNameScoreFvrDataBaseV1sort = cell(1,6);

%����һ�µȻ�Ҫ�õĲ���
numOfMatch = 0;
tic;
for num1 = 3:1:length(imgFolderList)%list��ǰ���������ļ��У�ȥ��
    imgSampleList = dir([imgFolderList(num1).folder,'\',imgFolderList(num1).name]);%����ļ����г�ȥ��Ч���ַ��������е�ͼƬ
    
        for num2 = 3:1:length(imgSampleList)%list��ǰ���������ļ��У�ȥ��
            imgSample = imread(strcat(imgSampleList(num2).folder,'\',imgSampleList(num2).name));%��ȡ�ļ����е�ͼƬ
            num_score = 0;
            mat_score = [];
                
            for num3  = 3:1:5%ֻ��ǰ����ͼƬ���бȽ�
                %��ȡ��������ͼƬ�����бȽϣ�ע��ͼƬ��������Ƚϣ��������ļ����������ж��ǲ�������
                imgBank = imread(strcat(imgSampleList(num3).folder,'\',imgSampleList(num3).name));
                num_score = num_score + 1;
%                 mat_score(num_score) = F_measureSimilarity(imresize(imgSample,0.6),imresize(imgBank,0.6));
                  [mat_score(num_score),pos(num_score,:),corrmaxvalue(num_score)] = Q_measureSimilarity(imresize(imgSample,0.6),imresize(imgBank,0.6)) ;
                
            end
            numOfMatch = numOfMatch + 1;         
            disp(numOfMatch);
            [~,y] = max(mat_score);%�ҵ���ߵ÷ֶ�Ӧ��ͼƬ����
            withinClassImgNameScoreFvrDataBaseV1sort(numOfMatch,:) = {imgSampleList(num2).name,...
                                                                                    imgSampleList(y+2).name,...
                                                                                    max(mat_score),...
                                                                                    imgSampleList(3).folder(end-4:end),...
                                                                                     pos(y,:),...
                                                                                     corrmaxvalue(y)};
        end
end
toc;
save('0121_Within_newNumber0.1.mat','withinClassImgNameScoreFvrDataBaseV1sort');
load splat;
sound(y,Fs);