%test_betweenClassScoreCount1
clear;

% imgFoldername = 'F:\��m-retrieve\ָ����\ָ����\pics-per3���ܣ�LSQ���ģ�\';
imgFoldername = 'F:\��Ŀ-ָ����\ʦ�ܽ���\ʦ��������ͼƬ\20190306_��˹ǿ��llbp_ROI\';
imgFolderList = dir([imgFoldername,'FvrQuryPicsEllbp']);%��ȡ���д���ͼƬ���ļ���

%cell��ÿһ�зֱ���sample�����Աȵ�ͼƬ�����ж�Ӧ��ellbp������SURF���������
betweenClassImgNameScoreFvrDataBaseV1sort = cell(1, 9);

%����һ�µȻ�Ҫ�õĲ���
numOfMatch = 0;
tic;
for num1 = 3:1:length(imgFolderList)%list��ǰ���������ļ��У�ȥ��
    imgSampleList = dir([imgFolderList(num1).folder,'\',imgFolderList(num1).name]);%����ļ����г�ȥ��Ч���ַ��������е�ͼƬ
    
    for num3  = (num1+1):1:length(imgFolderList)
        imgList = dir([imgFolderList(num3).folder,'\',imgFolderList(num3).name]);%��ȡ�����е��ļ���
        
        for num2 = 3:1:5%list��ǰ���������ļ��У�ȥ����ȡһ���ڵ�����ͼƬ
            imgSample = imread(strcat(imgSampleList(num2).folder,'\',imgSampleList(num2).name));%��ȡ�ļ����е�ͼƬ
            %                 num_score = 0;
            %                 mat_score = [];
            for num4 = 3:1:5 %ֻ��ǰ����ͼƬ����Ϊ���ƥ�䣩
                %���ÿ��ֻȡǰ3��ͼƬ,�������ļ����������ж��ǲ�������
                %                     if ~(strcmp(imgList(num4).folder,imgSampleList(num2).folder))%��� ��ʱѭ�������ļ��к�����ͬ�Ž���ƥ��
                imgBank = imread(strcat(imgList(num4).folder,'\',imgList(num4).name));
                %                         num_score = num_score + 1;
                %                         [mat_score(num_score)] = F_measureSimilarity(imresize(imgSample,0.6),imresize(imgBank,0.6));
                [mat_score,pos,corrmaxvalue,overlapDegree,elasticScore] = Q_measureSimilarity(imresize(imgSample,0.6),imresize(imgBank,0.6)) ;
                
                %                 if ~isempty(mat_score)
                
                %                     [~,y] = max(mat_score);%�ҵ���ߵ÷ֶ�Ӧ��ͼƬ����
                %                     % ÿ��cell��ÿ�д�ŵ������ǣ���ѯͼ�ļ�������ͼ�ļ��������ƶȡ���ѯͼ�����ļ���������ͼ�����ļ�����,norm��ƽ����
                numOfMatch = numOfMatch + 1;
                disp(numOfMatch);
                betweenClassImgNameScoreFvrDataBaseV1sort(numOfMatch,:) = {imgSampleList(num2).name,...
                                                                                imgList(num4).name,...
                                                                                mat_score,...
                                                                                imgSampleList(1).folder(end-4:end),...
                                                                                imgList(1).folder(end-4:end),...
                                                                                pos,...
                                                                                corrmaxvalue,...
                                                                                overlapDegree,...
                                                                                elasticScore};

            end
        end
        
    end
end
toc;
save('0306_Between_per3_NewTest_ʦ�ܸ�˹ǿ��llbp_ROI_�޼���.mat','betweenClassImgNameScoreFvrDataBaseV1sort');

load splat;
sound(y,Fs);