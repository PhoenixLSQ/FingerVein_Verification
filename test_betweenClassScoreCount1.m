%test_betweenClassScoreCount1
%�˳������ڰ��չ�˾�ķ����������ƥ����ļ������Ӧ����
%ÿ��10��ͼƬ��ǰ3����������ͼƬ��10��ͼƬ������ѯͼƬ�����ظ���
%��䣺ÿһ���10���е�1�ŷֱ���ʣ��������������е�����ͼƬ�������Զ������ٽ����������е���߷�ȡ��
%       ��Ϊ�˴������Զ����Ľ��������ͼƬ�Դ�����
%���ڣ�ÿһ���10���е�1�ŷֱ���������3��ͼƬ��ͼ����һ�������Զ��������ظ�����ȡ�����е���߷���Ϊ�˴�������
%       �����Ľ��
clear;

% imgFolderList = dir('.\imgAll\FvrDataBase_V1.0_Ellbp');%��ȡ���д���ͼƬ���ļ���
imgFoldername = 'F:\��m-retrieve\ָ����\ָ����\pics-0.54%frr\';
imgFolderList = dir([imgFoldername,'FvrQuryPicsEllbp']);%��ȡ���д���ͼƬ���ļ���

%cell��ÿһ�зֱ���sample�����Աȵ�ͼƬ�����ж�Ӧ��ellbp������SURF���������
betweenClassImgNameScoreFvrDataBaseV1sort = cell(1, 7);

%����һ�µȻ�Ҫ�õĲ���
numOfMatch = 0;
tic;
for num1 = 3:1:length(imgFolderList)%list��ǰ���������ļ��У�ȥ��
    imgSampleList = dir([imgFolderList(num1).folder,'\',imgFolderList(num1).name]);%����ļ����г�ȥ��Ч���ַ��������е�ͼƬ
    
        for num2 = 3:1:length(imgSampleList)%list��ǰ���������ļ��У�ȥ����ȡһ���ڵ�����ͼƬ
                imgSample = imread(strcat(imgSampleList(num2).folder,'\',imgSampleList(num2).name));%��ȡ�ļ����е�ͼƬ
                
            for num3  = 3:1:length(imgFolderList)
                imgList = dir([imgFolderList(num3).folder,'\',imgFolderList(num3).name]);%��ȡ�����е��ļ���
                num_score = 0;
                mat_score = [];
                
                for num4 = 3:1:5%ֻ��ǰ����ͼƬ����Ϊ���ƥ�䣩
                    %���ÿ��ֻȡǰ3��ͼƬ,�������ļ����������ж��ǲ�������
                    if ~(strcmp(imgList(num4).folder,imgSampleList(num2).folder))%��� ��ʱѭ�������ļ��к�����ͬ�Ž���ƥ��
                        imgBank = imread(strcat(imgList(num4).folder,'\',imgList(num4).name));
                        num_score = num_score + 1;
%                         [mat_score(num_score)] = F_measureSimilarity(imresize(imgSample,0.6),imresize(imgBank,0.6));
                        [mat_score(num_score),pos(num_score,:),corrmaxvalue(num_score)] = Q_measureSimilarity(imresize(imgSample,0.6),imresize(imgBank,0.6));                        
                    end
                end
                if ~isempty(mat_score)
                    numOfMatch = numOfMatch + 1;
                    disp(numOfMatch);
                    [~,y] = max(mat_score);%�ҵ���ߵ÷ֶ�Ӧ��ͼƬ����
                    % ÿ��cell��ÿ�д�ŵ������ǣ���ѯͼ�ļ�������ͼ�ļ��������ƶȡ���ѯͼ�����ļ���������ͼ�����ļ�����,norm��ƽ����
                    betweenClassImgNameScoreFvrDataBaseV1sort(numOfMatch,:) = {imgSampleList(num2).name,...
                                                                                            imgList(y+2).name,...
                                                                                            max(max(mat_score)),...
                                                                                            imgSampleList(1).folder(end-4:end),...
                                                                                            imgList(1).folder(end-4:end),...
                                                                                            pos(y,:),...
                                                                                            corrmaxvalue(y)};
                end
                
            end
        end
end
toc;
save('0118_Between_limit_CorrRatioThresh0.1.mat','betweenClassImgNameScoreFvrDataBaseV1sort');

load splat;
sound(y,Fs);