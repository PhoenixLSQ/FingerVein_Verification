%test_withinClassScoreCount1
%�˳������ڲ������ƥ����ļ������Ӧ����
clear;

% imgFoldername = 'F:\��m-retrieve\ָ����\ָ����\pics-per3���ܣ�LSQ���ģ�\';
imgFoldername = 'F:\��Ŀ-ָ����\ʦ�ܽ���\ʦ��������ͼƬ\20190306_��˹ǿ��llbp_ROI\';
imgFolderList = dir([imgFoldername,'FvrQuryPicsEllbp']);%��ȡ���д���ͼƬ���ļ���


%cell��ÿһ�зֱ���sample�����Աȵ�ͼƬ�����ж�Ӧ��ellbp������SURF���������
withinClassImgNameScoreFvrDataBaseV1sort = cell(1,8);

%����һ�µȻ�Ҫ�õĲ���
numOfMatch = 0;
tic;
for num1 = 3:1:length(imgFolderList)%list��ǰ���������ļ��У�ȥ��
    imgSampleList = dir([imgFolderList(num1).folder,'\',imgFolderList(num1).name]);%����ļ����г�ȥ��Ч���ַ��������е�ͼƬ
    
        for num2 = 3:1:length(imgSampleList)%list��ǰ���������ļ��У�ȥ��
            imgSample = imread(strcat(imgSampleList(num2).folder,'\',imgSampleList(num2).name));%��ȡ�ļ����е�ͼƬ
            num_score = 0;
            mat_score = [];
                
            for num3  = (num2+1):1:length(imgSampleList)
                %��ȡ��������ͼƬ�����бȽϣ�ע��ͼƬ��������Ƚϣ��������ļ����������ж��ǲ�������
                imgBank = imread(strcat(imgSampleList(num3).folder,'\',imgSampleList(num3).name));
%                 num_score = num_score + 1;
%                 mat_score(num_score) = F_measureSimilarity(imresize(imgSample,0.6),imresize(imgBank,0.6));
                  [mat_score,pos,corrmaxvalue,overlapDegree,elasticScore] = Q_measureSimilarity(imresize(imgSample,0.6),imresize(imgBank,0.6)) ;
                
            
            numOfMatch = numOfMatch + 1; 
            withinClassImgNameScoreFvrDataBaseV1sort(numOfMatch,:) = {imgSampleList(num2).name,...
                                                                                    imgSampleList(num3).name,...
                                                                                    mat_score,...
                                                                                    imgSampleList(3).folder(end-4:end),...
                                                                                     pos,...
                                                                                     corrmaxvalue,...
                                                                                     overlapDegree,...
                                                                                     elasticScore};
             disp(numOfMatch);                                                                                                  
             end
 %          [~,y] = max(mat_score);%�ҵ���ߵ÷ֶ�Ӧ��ͼƬ����
        end
end
toc;
save('0306_Within_per3_NewTest_ʦ�ܸ�˹ǿ��llbp_ROI_�޼���.mat','withinClassImgNameScoreFvrDataBaseV1sort');
load splat;
sound(y,Fs);