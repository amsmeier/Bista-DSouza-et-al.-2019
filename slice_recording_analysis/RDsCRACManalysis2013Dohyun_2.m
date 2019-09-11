function RDsCRACManalysis2013Dohyun_2

CaseList={

%    'V1toPM_L23_sCRACM'
%    'V1toPM_L5_sCRACM'
%    'PMtoV1_L23_sCRACM'
%    'PMtoV1_L5_sCRACM'
%    'PMtoLM_L23_sCRACM'
%    'PMtoLM_L5_sCRACM'
%    'LMtoPM_L23_sCRACM'
%    'LMtoPM_L5_sCRACM'
    'LPtoV1_patch_sCRACM'
%    'LPtoV1_interpatch_sCRACM'
%    'LPtoV1_patch_vs_interpatch'
%    'LPtoV1_pooled_sCRACM'
%    'dLGNtoV1_patch_sCRACM'
%    'dLGNtoV1_interpatch_sCRACM'
%    'dLGNtoV1_POOLED'
    };

for m=1:size(CaseList,1)
    CellList = lists_RD1(CaseList{m});
    
    %Makes a matrix of all maps for a given list
    %Designed for a multi column list of all possible pairs
    for r=1:size(CellList,1)
        for c=1:size(CellList,2)
            data{r,c} = eval(char(CellList{r,c}));
            if strcmp((data{r,c}.hemisphere),'L')==1
                data{r,c}.mean = fliplr(data{r,c}.mean);
            elseif strcmp((data{r,c}.hemisphere),'R')==1
                data{r,c}.mean = data{r,c}.mean;
            else
               disp([char(CellList{r,c}) 'does not specify hemisphere.'])
            end
            %Changes Inf and -Inf values in maps to NaN
            data{r,c}.mean(data{r,c}.mean==Inf)=NaN;
            data{r,c}.mean(data{r,c}.mean==-Inf)=NaN;
            tempmatrix=data{r,c}.mean;
            tempmatrix(tempmatrix==0)=NaN;
            meanthresholdedmatrix{r,c} = tempmatrix;
            sumofmeanthresholdedmatrix(r,c) = nansum(tempmatrix(:));
  %          meanofmeanthresholdedmatrix(r,c) = nanmean(tempmatrix(:));
            meannotthresholdedmatrix{r,c} = data{r,c}.mean;
            sumofmeannotthresholdedmatrix(r,c) = sum(data{r,c}.mean(:));
        end
    end
    
 %   sumofmeanthresholdedmatrix(r,c)
 %   meanofmeanthresholdedmatrix(r,c)
 %   sumofmeannotthresholdedmatrix(r,c)
 
    
    Title1=char(CaseList(m));
    
    if size(CellList,1)<=4
         figure('Name',Title1)
         for n=1:size(CellList,1)
        %     subplot(4,2,(2*n)-1)
             subplot(1,2,1)
             A=min(min([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
             B=max(max([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
             CLim=[A-(0.05*(B-A)) B+(0.05*(B-A))];
             imagesc(meannotthresholdedmatrix{n,1},CLim),colormap(flipud(jet2(256))),axis equal
             title(num2str(data{n,1}.experimentNumber));
        %    subplot(4,2,2*n)
             subplot(1,2,2)
             imagesc(meannotthresholdedmatrix{n,2},CLim),colormap(flipud(jet2(256))),axis equal    %include "colorbar" for colorbar (see other lines)
             title(num2str(data{n,2}.experimentNumber));
         end
    elseif size(CellList,1)>4      
        figure('Name',Title1)
        for n=1:4
            subplot(4,2,(2*n)-1) 
            A=min(min([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
            B=max(max([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
            CLim=[A-(0.05*(B-A)) B+(0.05*(B-A))];
            imagesc(meannotthresholdedmatrix{n,1},CLim),colormap(flipud(jet2(256))),axis equal
            title(num2str(data{n,1}.experimentNumber));
            subplot(4,2,2*n)
            imagesc(meannotthresholdedmatrix{n,2},CLim),colorbar,colormap(flipud(jet2(256))),axis equal
            title(num2str(data{n,2}.experimentNumber));
        end
        if size(CellList,1)<=8
         figure('Name',Title1)
         for n=5:size(CellList,1)
             subplot(4,2,(2*n)-9)   
             A=min(min([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
             B=max(max([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
             CLim=[A-(0.05*(B-A)) B+(0.05*(B-A))];
             imagesc(meannotthresholdedmatrix{n,1},CLim),colormap(flipud(jet2(256))),axis equal
             title(num2str(data{n,1}.experimentNumber));
             subplot(4,2,2*n-8)
             imagesc(meannotthresholdedmatrix{n,2},CLim),colorbar,colormap(flipud(jet2(256))),axis equal
             title(num2str(data{n,2}.experimentNumber));
         end
        elseif size(CellList,1)>8
            figure('Name',Title1)
            for n=5:8
                subplot(4,2,(2*n)-9)
                A=min(min([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
                B=max(max([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
                CLim=[A-(0.05*(B-A)) B+(0.05*(B-A))];
                imagesc(meannotthresholdedmatrix{n,1},CLim),colormap(flipud(jet2(256))),axis equal
                title(num2str(data{n,1}.experimentNumber));
                subplot(4,2,2*n-8)
                imagesc(meannotthresholdedmatrix{n,2},CLim),colorbar,colormap(flipud(jet2(256))),axis equal
                title(num2str(data{n,2}.experimentNumber));
            end
            if size(CellList,1)<=12
                figure('Name',Title1)
                for n=9:size(CellList,1)
                    subplot(4,2,(2*n)-17)
                    A=min(min([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
                    B=max(max([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
                    CLim=[A-(0.05*(B-A)) B+(0.05*(B-A))];
                    imagesc(meannotthresholdedmatrix{n,1},CLim),colormap(flipud(jet2(256))),axis equal
                    title(num2str(data{n,1}.experimentNumber));
                    subplot(4,2,2*n-16)
                    imagesc(meannotthresholdedmatrix{n,2},CLim),colorbar,colormap(flipud(jet2(256))),axis equal
                    title(num2str(data{n,2}.experimentNumber));
                end
            elseif size(CellList,1)>12
                figure('Name',Title1)
                for n=9:12
                    subplot(4,2,(2*n)-17)
                    A=min(min([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
                    B=max(max([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
                    CLim=[A-(0.05*(B-A)) B+(0.05*(B-A))];
                    imagesc(meannotthresholdedmatrix{n,1},CLim),colormap(flipud(jet2(256))),axis equal
                    title(num2str(data{n,1}.experimentNumber));
                    subplot(4,2,2*n-16)
                    imagesc(meannotthresholdedmatrix{n,2},CLim),colorbar,colormap(flipud(jet2(256))),axis equal
                    title(num2str(data{n,2}.experimentNumber));
                end
                if size(CellList,1)<=16
                    figure('Name',Title1)
                    for n=13:size(CellList,1)
                        subplot(4,2,(2*n)-25)
                        A=min(min([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
                        B=max(max([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
                        CLim=[A-(0.05*(B-A)) B+(0.05*(B-A))];
                        imagesc(meannotthresholdedmatrix{n,1},CLim),colormap(flipud(jet2(256))),axis equal
                        title(num2str(data{n,1}.experimentNumber));
                        subplot(4,2,2*n-24)
                        imagesc(meannotthresholdedmatrix{n,2},CLim),colorbar,colormap(flipud(jet2(256))),axis equal
                        title(num2str(data{n,2}.experimentNumber));
                    end
                elseif size(CellList,1)>16
                    figure('Name',Title1)
                    for n=13:16
                        subplot(4,2,(2*n)-25)
                        A=min(min([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
                        B=max(max([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
                        CLim=[A-(0.05*(B-A)) B+(0.05*(B-A))];
                        imagesc(meannotthresholdedmatrix{n,1},CLim),colormap(flipud(jet2(256))),axis equal
                        title(num2str(data{n,1}.experimentNumber));
                        subplot(4,2,2*n-24)
                        imagesc(meannotthresholdedmatrix{n,2},CLim),colorbar,colormap(flipud(jet2(256))),axis equal
                        title(num2str(data{n,2}.experimentNumber));
                    end
                    if size(CellList,1)<=20
                        figure('Name',Title1)
                        for n=17:size(CellList,1)
                            subplot(4,2,(2*n)-33)
                            A=min(min([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
                            B=max(max([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
                            CLim=[A-(0.05*(B-A)) B+(0.05*(B-A))];
                            imagesc(meannotthresholdedmatrix{n,1},CLim),colormap(flipud(jet2(256))),axis equal
                            title(num2str(data{n,1}.experimentNumber));
                            subplot(4,2,2*n-32)
                            imagesc(meannotthresholdedmatrix{n,2},CLim),colorbar,colormap(flipud(jet2(256))),axis equal
                            title(num2str(data{n,2}.experimentNumber));
                        end
                    elseif size(CellList,1)>20
                        figure('Name',Title1)
                        for n=17:20
                            subplot(4,2,(2*n)-33)
                            A=min(min([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
                            B=max(max([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
                            CLim=[A-(0.05*(B-A)) B+(0.05*(B-A))];
                            imagesc(meannotthresholdedmatrix{n,1},CLim),colormap(flipud(jet2(256))),axis equal
                            title(num2str(data{n,1}.experimentNumber));
                            subplot(4,2,2*n-32)
                            imagesc(meannotthresholdedmatrix{n,2},CLim),colorbar,colormap(flipud(jet2(256))),axis equal
                            title(num2str(data{n,2}.experimentNumber));
                        end   
                        
                        if size(CellList,1)<=24
                        figure('Name',Title1)
                        for n=21:size(CellList,1)
                            subplot(4,2,(2*n)-41)
                            A=min(min([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
                            B=max(max([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
                            CLim=[A-(0.05*(B-A)) B+(0.05*(B-A))];
                            imagesc(meannotthresholdedmatrix{n,1},CLim),colormap(flipud(jet2(256))),axis equal
                            title(num2str(data{n,1}.experimentNumber));
                            subplot(4,2,2*n-40)
                            imagesc(meannotthresholdedmatrix{n,2},CLim),colorbar,colormap(flipud(jet2(256))),axis equal
                            title(num2str(data{n,2}.experimentNumber));
                        end
                    elseif size(CellList,1)>24
                        figure('Name',Title1)
                        for n=21:24
                            subplot(4,2,(2*n)-41)
                            A=min(min([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
                            B=max(max([meannotthresholdedmatrix{n,1} meannotthresholdedmatrix{n,2}]));
                            CLim=[A-(0.05*(B-A)) B+(0.05*(B-A))];
                            imagesc(meannotthresholdedmatrix{n,1},CLim),colormap(flipud(jet2(256))),axis equal
                            title(num2str(data{n,1}.experimentNumber));
                            subplot(4,2,2*n-40)
                            imagesc(meannotthresholdedmatrix{n,2},CLim),colorbar,colormap(flipud(jet2(256))),axis equal
                            title(num2str(data{n,2}.experimentNumber));
                        end   
                        end  
                    end
                end
            end
        end
    end
    
  %Not thresholded sum
  PV = sumofmeannotthresholdedmatrix(:,1)
  Pyr = sumofmeannotthresholdedmatrix(:,2) 
  sumofmeannotthresholdedmatrixnormal=sumofmeannotthresholdedmatrix(:,1)./sumofmeannotthresholdedmatrix(:,2) 
   
  %Thresholded sum
  %  sumofmeanthresholdedmatrixnormal=sumofmeanthresholdedmatrix(:,1)/sumofmeanthresholdedmatrix(:,2);
    
    %Not thresholded plots
    %Plot the ratio
    %Uncomment to see computation of mean and geometric mean
    plotablemean(m)=geomean(sumofmeannotthresholdedmatrixnormal);
    plotablestd(m)=std(sumofmeannotthresholdedmatrixnormal);
    plotablese(m)=std(sumofmeannotthresholdedmatrixnormal)/sqrt(size(sumofmeannotthresholdedmatrixnormal,1)-1);
      
%     geomean(sumofmeannotthresholdedmatrixnormal);
    
    scatter=[];
    scatter=randn(1,size(CellList,1));
    figure('Name',[Title1 'sumofmeannotthresholdedmatrixnormal']),plot(scatter/10,sumofmeannotthresholdedmatrixnormal,'LineStyle','none','Marker','o','Color','Red');
    set(gca,'XLim',[-1 1]);
    k=length(scatter);    
    display('-------------------------------------------')
    if m==1;
        for kk=1:k
            fprintf('(L2FS Position,PYR) = (%1.2f,%1.2f)\n',scatter(kk),sumofmeannotthresholdedmatrixnormal(kk))
        end
    elseif m==2;
        for kk=1:k
            fprintf('(L2FS Position,PYR) = (%1.2f,%1.2f)\n',scatter(kk),sumofmeannotthresholdedmatrixnormal(kk))
        end
    else
        for kk=1:k
            fprintf('(L6FS Position,PYR) = (%1.2f,%1.2f)\n',scatter(kk),sumofmeannotthresholdedmatrixnormal(kk))
        end
    end
        
    hold on
    plot([max(scatter/10) min(scatter/10)],[1 1],'LineStyle','--','Marker','none','Color','Black');
    xlabel('L2/3 Pyr')
    ylabel('L2/3 PV')
    
    figure('Name',[Title1 'sumofmeannotthresholdedmatrix']), plot(-sumofmeannotthresholdedmatrix(:,2),-sumofmeannotthresholdedmatrix(:,1),'LineStyle','none','Marker','.','MarkerSize',30,'Color','black'), axis square
    daspect([1 1 1]);
    XLim=get(gca,'XLim');
    YLim=get(gca,'YLim');
    XYLim=[XLim YLim];
    XYLimMax=max(max(XYLim));
  %  set(gca,'XLim',[0 650],'YLim',[0 650]);           % use this for V1->PM, L5
  %  set(gca,'XLim',[0 1200],'YLim',[0 1200]);
    set(gca,'XLim',[0 XYLimMax],'YLim',[0 XYLimMax]);
    hold on
    plot([0 XYLimMax],[0 XYLimMax],'LineStyle',':','Color','Black','LineWidth',0.5);
    plot([0 XYLimMax],[0 plotablemean(m)*XYLimMax],'LineStyle','-','Color','Red','LineWidth',2);
 %   pol=polyfit(-sumofmeannotthresholdedmatrix(:,2),-sumofmeannotthresholdedmatrix(:,1),1);
 %   yfit=pol(1)*-sumofmeannotthresholdedmatrix(:,2)+pol(2);
 %   plot(-sumofmeannotthresholdedmatrix(:,2),yfit);
    xlabel('L5 Pyr')
    ylabel('L5 PV')
 %   k=length(sumofmeannotthresholdedmatrix(:,2));
    display('-------------------------------------------')
 %    if m==1;
 %       for kk=1:k
 %           fprintf('(L5FS Position,PYR) = (%1.2f,%1.2f)\n',sumofmeannotthresholdedmatrix(kk,2),sumofmeannotthresholdedmatrix(kk,1))
 %       end
 %    elseif m==2;
 %       for kk=1:k
 %           fprintf('(L2FS Position,PYR) = (%1.2f,%1.2f)\n',sumofmeannotthresholdedmatrix(kk,2),sumofmeannotthresholdedmatrix(kk,1))
 %       end
 %   else
%         for kk=1:k
%             fprintf('(L6FS Position,PYR) = (%1.2f,%1.2f)\n',sumofmeannotthresholdedmatrix(kk,2),sumofmeannotthresholdedmatrix(kk,1))
%         end
%     end
    
    [p h]= signrank(sumofmeannotthresholdedmatrix(:,2),sumofmeannotthresholdedmatrix(:,1))
%      temp1=XYLimMax
%      temp2=plotablemean(m)
%      temp3=plotablemean(m)*XYLimMax
%      temp4=sumofmeannotthresholdedmatrixnormal

    tempmatrix={};
    data={};
    meanthresholdedmatrix={};
    meannotthresholdedmatrix={};
    sumofmeanthresholdedmatrix=[];
    sumofmeannotthresholdedmatrix=[];
    CellList={};
    Title1=[];
    CLim=[];
end
% plotablemean;
% plotablestd;
% plotablese;
% Y=[1/plotablemean(7),1/plotablemean(6),1/plotablemean(5),1,plotablemean(1
% )];
% figure('Name','Deep L5B ratio')
% plot(Y);
% Y=[1,1/plotablemean(1),1/plotablemean(2),1/plotablemean(3),1/plotablemean(4)];
% figure('Name','L6 ratio')
% plot(Y);
%         




