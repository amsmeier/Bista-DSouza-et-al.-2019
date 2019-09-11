function map=analyzePairedMap(map)

[rows, numTraces] = size(map.averageMap);
sr=map.samplingRate;

filter_flag = 0;freq = 50;sampleRate = 10000;
if filter_flag
    [b,a] = butter(4,freq*2/sampleRate,'low');
    Hd = dfilt.df2t(b,a);
    for i = 1:size(map.averageMap,2)
        map.averageMap(:,i) = filter(Hd,map.averageMap(:,i))';
    end
end

baselineStartIndex = 1;
baselineEndIndex = 999;
stimOnInd=1000; %<--------------1000!
responseOnsetEnd=1150;
synEndInd=1750;
chargeEndInd=2500;

baselineMedians = median(map.averageMap(1:999,:));
baselineSDs = std(map.averageMap(baselineStartIndex:baselineEndIndex,:));
SD=mean(baselineSDs);

dirLevel=6; %<---------Config

dirNegThresh = baselineMedians-dirLevel*SD;
threshold=repmat(dirNegThresh, rows, 1);
for i=1:numTraces
    if isempty(find(diff(map.averageMap(stimOnInd:responseOnsetEnd,i)<threshold(stimOnInd:responseOnsetEnd,i))==1));
        onset(i)=NaN;
        Maximum(i)=max(map.averageMap(stimOnInd:synEndInd,i));
        minimum(i)=NaN;
        minOnset(i)=NaN;
        onset90(i)=NaN;
        onset10(i)=NaN;
        riseTime1090(i)=NaN;
        traceMean(i)=0; % for printing the significant traces TM, comment out if need the whole map
    else
        onset(i)=min(find(diff(map.averageMap(stimOnInd:responseOnsetEnd,i)<threshold(stimOnInd:responseOnsetEnd,i))==1))/sr;
        [Minimum MinOnset]=min(map.averageMap(stimOnInd:synEndInd,i));
        Maximum(i)=max(map.averageMap(stimOnInd:synEndInd,i));

        onset90(i)= min(find(diff((map.averageMap(stimOnInd:synEndInd,i)<.9*min((map.averageMap(stimOnInd:synEndInd,i))))==1)));
        try
            onset10(i)=min(find(diff((map.averageMap(stimOnInd:synEndInd,i)<.1*min((map.averageMap(stimOnInd:synEndInd,i))))==1)));
        catch
            onset10(i)=NaN;
        end
        % end
        minimum(i)=Minimum;
        minOnset(i)=MinOnset/sr;
        riseTime1090(i)=(onset90(i)-onset10(i))/sr;
        traceMean(i)=mean(map.averageMap(stimOnInd:synEndInd,i)); % comment out it need the whole map TM
    end
%     traceMean(i)=mean(map.averageMap(stimOnInd:synEndInd,i));
%     integral(i)= trapz(map.averageMap(stimOnInd:ch9argeEndInd,i))/sr;

    %Above is original, below - using onset, taking of less than 10%
   indexx=find(map.averageMap(:,i)<threshold(1,1));
    integral(i)=sum(map.averageMap(indexx,i))/1000;
    
    [a b]=find(map.pattern{1}==i);
    if a==11&&b==8
        iiii =  0;
    end

    mapOnset(a,b)=onset(i);
    mapMinOnset(a,b)=minOnset(i);
    mapMin(a,b)=minimum(i);
    mapMean(a,b)=traceMean(i);
    mapIntegral(a,b)=integral(i);
    mapRiseTime1090(a,b)=riseTime1090(i);
    mapMaximum(a,b)=Maximum(i);
end

% color='rbgkcm';
cell=input('Cell Number?(ex: 1st cell = 1)');
if cell ==1 
    save('Pyramidal_output1.txt','integral','-ascii')
else
%     [Py]=textread('Pyramidal_output.txt');
%     [lengPy]=size(Py);
%     newPy=zeros(2*lengPy(1),lengPy(2));
%     newPy(1:lengPy(1),:)=Py;
%     newPy(lengPy(1):end,:)=integral;
    %Gotta stack Py of diff experiments.
    save('Pyramidal_output2.txt','integral','-ascii')
% elseif cell ==3
%     [Py]=textread('Pyramidal_output.txt');
%     [lengPy]=size(Py);
%     newPy=zeros(3/2*lengPy(1),lengPy(2));
%     newPy(1:lengPy(1),:)=Py;
%     newPy(lengPy(1):end,:)=integral;
    %Gotta stack Py of diff experiments.
%     save('Pyramidal_output.txt','newPy','-ascii')

end
%     figure(13)
%     hold on
%     integral1=integral;
%     hist(integral1,50)
%     hhh = findobj(gca,'Type','patch');
%     set(hhh(1),'FaceColor',color(cell),'EdgeColor','k')
% elseif cell ==2
%     figure(13)
%     hold on
%     integral2=integral;
%     hist(integral2,50)
%     hhh = findobj(gca,'Type','patch');
%     set(hhh(1),'FaceColor','r','EdgeColor','k')
%     set(hhh(2),'FaceColor','b','EdgeColor','k')
% elseif cell ==3
%     figure(13)
%     hold on
%     integral3=integral;
%     hist(integral3,50)
%     hhh = findobj(gca,'Type','patch');
%     set(hhh(1),'FaceColor','r','EdgeColor','k')
%     set(hhh(2),'FaceColor','b','EdgeColor','k')
%     set(hhh(3),'FaceColor','g','EdgeColor','k') 
% else
%     figure(13)
%     hold on
%     integral4=integral;
%     hist(integral4,50)
%     hhh = findobj(gca,'Type','patch');
%     set(hhh(1),'FaceColor','r','EdgeColor','k')
%     set(hhh(2),'FaceColor','b','EdgeColor','k')
%     set(hhh(3),'FaceColor','g','EdgeColor','k') 
%     set(hhh(4),'FaceColor','k','EdgeColor','k') 
% end
% map.analysis.xSpacing=map.xSpacing;
% map.analysis.ySpacing=map.ySpacing;
% map.analysis.onset=mapOnset;
% map.analysis.minOnset=mapMinOnset;
% map.analysis.minimum=mapMin;
% map.analysis.mean=mapMean;
% map.analysis.integral=mapIntegral;
% map.analysis.riseTime1090=mapRiseTime1090;
% map.analysis.maximum=mapMaximum;
% [map.soma1Coordinates(1) map.soma1Coordinates(2)]=somaPositionTransformerMH(map.soma1Coordinates(1), map.soma1Coordinates(2), map.spatialRotation,map.xPatternOffset,map.yPatternOffset);
% 
% for n=1:size(map.analysis.mean,1)
%     nancolumnvector(n)=NaN;
% end
