% LSQ annotation: �˳����ý�ԭͼ��ȡElbp�����󣬱��浽ԭͼ���ļ�������·����2019.1.21

clear;

% picsFoldername = 'F:\��m-retrieve\ָ����\ָ����\pics-per3���ܣ�LSQ���ģ�\';
 picsFoldername = 'F:\��m-retrieve\ָ����\ָ����\����\';
imgFoldername = 'FvrQuryPics\';

imgFolderList = dir([picsFoldername,imgFoldername]);
% imgFolderList = dir('F:\��m-retrieve\ָ����\ָ����\pics-�����±��0121\FvrQuryPics');

numOfFile = 0;

for num1 = 3:1:length(imgFolderList)%list��ǰ���������ļ��У�ȥ��
    imgSampleList = dir([imgFolderList(num1).folder,'\',imgFolderList(num1).name]);%����ļ����г�ȥ��Ч���ַ��������е�ͼƬ
%     imgNameAndSURFDescripter = cell(1,2);

        for num2 = 3:1:length(imgSampleList)%list��ǰ���������ļ��У�ȥ����ȡһ���ڵ�����ͼƬ
            numOfFile = numOfFile + 1;
            disp(numOfFile);
            imgSample = imread(strcat(imgSampleList(num2).folder,'\',imgSampleList(num2).name));%��ȡ�ļ����е�ͼƬ
            imgSample = F_extractFeatures(imgSample);
            mkdir([picsFoldername,'FvrQuryPicsEllbp\',imgFolderList(num1).name]);
                imwrite(imgSample,[picsFoldername,'\FvrQuryPicsEllbp\',imgFolderList(num1).name,'\',imgSampleList(num2).name]);
%                 mkdir('.\FvrQuryPicsEllbp\',imgFolderList(num1).name);
%                 imwrite(imgSample,['.\FvrQuryPicsEllbp\',imgFolderList(num1).name,'\',imgSampleList(num2).name]);
                
        end
end

