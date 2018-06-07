clc
clear all
close all

NumberOfHiddenNodes=34;
InputFolder='';
diary(strcat(InputFolder,'AnalysisSMC_Shifted2.txt'));
diary on

InputAccuracyFileType='Target_30V_PosteriorAccuracy_Pool_%d_H_%d_FullSD_VC%d.csv';
InputPrecisionFileType='Target_30V_PosteriorPrecision_Pool_%d_H_%d_FullSD_VC%d.csv';
MainResultFileType='Target_30V_AllResults_H_%d_FullSD_VC%d.csv';
MainResultFileType2='Target_30V_AllResults_H_%d_FullSD_VC%d2.csv';
MainResultFileType3='Target_30V_AllResults_H_%d_FullSD_VC%d3.csv';

VC=3;
NumberOfRuns=10;
StartColumn=2;
AllPoolNumbers=1:10;
NumberOfPools=length(AllPoolNumbers);

for PoolIndexNumber=1:NumberOfPools
    PoolNumber=AllPoolNumbers(1,PoolIndexNumber);
    InputAccuracyFile=sprintf(InputAccuracyFileType, PoolNumber,NumberOfHiddenNodes,VC);
    InputPrecisionFile=sprintf(InputPrecisionFileType, PoolNumber,NumberOfHiddenNodes,VC);
    MainResultFile=sprintf(MainResultFileType,NumberOfHiddenNodes,VC);
    MainResultFile2=sprintf(MainResultFileType2,NumberOfHiddenNodes,VC);
    MainResultFile3=sprintf(MainResultFileType3,NumberOfHiddenNodes,VC);
    AllAccuracy=csvread(strcat(InputFolder,InputAccuracyFile));
    BestPosteriorAccuracy=AllAccuracy(:,StartColumn:StartColumn+1*NumberOfRuns-1);
    BestPriorAccuracy=AllAccuracy(:,StartColumn+1*NumberOfRuns:StartColumn+2*NumberOfRuns-1);
    BestTrainingParameterAccuracy=AllAccuracy(:,StartColumn+2*NumberOfRuns:StartColumn+3*NumberOfRuns-1);
    BestTestParameterAccuracy=AllAccuracy(:,StartColumn+3*NumberOfRuns:StartColumn+4*NumberOfRuns-1);
    
    BestPriorAccuracyMean=mean(BestPriorAccuracy,2);
    BestPosteriorAccuracyMean=mean(BestPosteriorAccuracy,2);
    BestTrainingParameterAccuracyMean=mean(BestTrainingParameterAccuracy,2);
    BestTestParameterAccuracyMean=mean(BestTestParameterAccuracy,2);
    display(sprintf('PoolNumber =%d ,Posterior >= Least Error =%d',PoolNumber,length(find(BestPosteriorAccuracyMean>=BestTrainingParameterAccuracyMean))));
    MaxCosts=AllAccuracy(:,1);
    AllAccuracyMeans=horzcat(MaxCosts, BestPosteriorAccuracyMean,BestPriorAccuracyMean,BestTrainingParameterAccuracyMean,BestTestParameterAccuracyMean);
    
    AllPrecision=csvread(strcat(InputFolder,InputPrecisionFile));
    BestPosteriorPrecision=AllPrecision(:,StartColumn:StartColumn+1*NumberOfRuns-1);
    BestPriorPrecision=AllPrecision(:,StartColumn+1*NumberOfRuns:StartColumn+2*NumberOfRuns-1);
    BestTrainingParameterPrecision=AllPrecision(:,StartColumn+2*NumberOfRuns:StartColumn+3*NumberOfRuns-1);
    BestTestParameterPrecision=AllPrecision(:,StartColumn+3*NumberOfRuns:StartColumn+4*NumberOfRuns-1);
    
    BestPriorPrecisionMean=mean(BestPriorPrecision,2);
    BestPosteriorPrecisionMean=mean(BestPosteriorPrecision,2);
    BestTrainingParameterPrecisionMean=mean(BestTrainingParameterPrecision,2);
    BestTestParameterPrecisionMean=mean(BestTestParameterPrecision,2);
    
    
    MaxCosts=AllPrecision(:,1);
    AllPrecisionMeans= horzcat(MaxCosts, BestPosteriorPrecisionMean,BestPriorPrecisionMean,BestTrainingParameterPrecisionMean,BestTestParameterPrecisionMean);
    Results=vertcat(AllAccuracyMeans,AllPrecisionMeans);
    
    
    if PoolIndexNumber==1
        AllResults=Results;
        AllBestPosteriorAccuracy=BestPosteriorAccuracy;
        AllBestPriorAccuracy=BestPriorAccuracy;
        AllBestTrainingParameterAccuracy=BestTrainingParameterAccuracy;
        AllBestTestParameterAccuracy=BestTestParameterAccuracy;
        AllBestPosteriorPrecision=BestPosteriorPrecision;
        AllBestPriorPrecision=BestPriorPrecision;
        AllBestTrainingParameterPrecision=BestTrainingParameterPrecision;
        AllBestTestParameterPrecision=BestTestParameterPrecision;
        BestPriorAccuracyMeanAllRuns=BestPriorAccuracyMean;
        BestPosteriorAccuracyMeanAllRuns=BestPosteriorAccuracyMean;
        BestTrainingParameterAccuracyMeanAllRuns=BestTrainingParameterAccuracyMean;
        BestTestParameterAccuracyMeanAllRuns=BestTestParameterAccuracyMean;
        
        BestPriorPrecisionMeanAllRuns=BestPriorPrecisionMean;
        BestPosteriorPrecisionMeanAllRuns=BestPosteriorPrecisionMean;
        BestTrainingParameterPrecisionMeanAllRuns=BestTrainingParameterPrecisionMean;
        BestTestParameterPrecisionMeanAllRuns=BestTestParameterPrecisionMean;
        
        
    else
        AllResults=AllResults+Results;
        AllBestPosteriorAccuracy=horzcat(AllBestPosteriorAccuracy,BestPosteriorAccuracy);
        AllBestPriorAccuracy=horzcat(AllBestPriorAccuracy,BestPosteriorAccuracy);
        AllBestTrainingParameterAccuracy=horzcat(AllBestTrainingParameterAccuracy,BestTrainingParameterAccuracy);
        AllBestTestParameterAccuracy=horzcat(AllBestTestParameterAccuracy,BestTestParameterAccuracy);
        AllBestPosteriorPrecision=horzcat(AllBestPosteriorPrecision,BestPosteriorPrecision);
        AllBestPriorPrecision=horzcat(AllBestPriorPrecision,BestPosteriorPrecision);
        AllBestTrainingParameterPrecision=horzcat(AllBestTrainingParameterPrecision,BestTrainingParameterPrecision);
        AllBestTestParameterPrecision=horzcat(AllBestTestParameterPrecision,BestTestParameterPrecision);
       
        BestPriorAccuracyMeanAllRuns=horzcat(BestPriorAccuracyMeanAllRuns,BestPriorAccuracyMean);
        BestPosteriorAccuracyMeanAllRuns=horzcat(BestPosteriorAccuracyMeanAllRuns,BestPosteriorAccuracyMean);
        BestTrainingParameterAccuracyMeanAllRuns=horzcat(BestTrainingParameterAccuracyMeanAllRuns,BestTrainingParameterAccuracyMean);
        BestTestParameterAccuracyMeanAllRuns=horzcat(BestTestParameterAccuracyMeanAllRuns,BestTestParameterAccuracyMean);
        
        BestPriorPrecisionMeanAllRuns=horzcat(BestPriorPrecisionMeanAllRuns,BestPriorPrecisionMean);
        BestPosteriorPrecisionMeanAllRuns=horzcat(BestPosteriorPrecisionMeanAllRuns,BestPosteriorPrecisionMean);
        BestTrainingParameterPrecisionMeanAllRuns=horzcat(BestTrainingParameterPrecisionMeanAllRuns,BestTrainingParameterPrecisionMean);
        BestTestParameterPrecisionMeanAllRuns=horzcat(BestTestParameterPrecisionMeanAllRuns,BestTestParameterPrecisionMean);
        
        
        
    end
    ResultFile=strrep(InputAccuracyFile,'Accuracy','Results');
    csvwrite(strcat(InputFolder,ResultFile),Results);
    
    
    
end
AllResultsMeans=AllResults/PoolNumber;
csvwrite(strcat(InputFolder,MainResultFile),AllResultsMeans);
[AllResultsMeansRows AllResultsMeansCols]=size(AllResultsMeans);
display(sprintf('All Pools ,Posterior >= Least Error =%d',length(find(AllResultsMeans(1:floor(AllResultsMeansRows/2),2)>=AllResultsMeans(1:floor(AllResultsMeansRows/2),4)))));
display(sprintf('All Pools ,Posterior >= Prior =%d',length(find(AllResultsMeans(1:floor(AllResultsMeansRows/2),2)>=AllResultsMeans(1:floor(AllResultsMeansRows/2),3)))));
display(sprintf('NumberOfHiddenNodes=%d, VC=%d, NumberOfPools=%d',NumberOfHiddenNodes,VC,NumberOfPools));

AllBestPosteriorAccuracyMeans=mean(AllBestPosteriorAccuracy,2);
AllBestPriorAccuracyMeans=mean(AllBestPriorAccuracy,2);
AllBestTrainingParameterAccuracyMeans=mean(AllBestTrainingParameterAccuracy,2);
AllBestTestParameterAccuracyMeans=mean(AllBestTestParameterAccuracy,2);
display(sprintf('All Pools ,Posterior >= Least Error =%d',length(find(AllBestPosteriorAccuracyMeans>=AllBestTrainingParameterAccuracyMeans))));
display(sprintf('All Pools ,Posterior >= Prior =%d',length(find(AllBestPosteriorAccuracyMeans>=AllBestPriorAccuracyMeans))));
AllBestPosteriorAccuracyStandardDeviation=(std(AllBestPosteriorAccuracy'))';
AllBestPriorAccuracyStandardDeviation=(std(AllBestPriorAccuracy'))';
AllBestTrainingParameterAccuracyStandardDeviation=(std(AllBestTrainingParameterAccuracy'))';
AllBestTestParameterAccuracyStandardDeviation=(std(AllBestTestParameterAccuracy'))';

AllBestPosteriorPrecisionMeans=mean(AllBestPosteriorPrecision,2);
AllBestPriorPrecisionMeans=mean(AllBestPriorPrecision,2);
AllBestTrainingParameterPrecisionMeans=mean(AllBestTrainingParameterPrecision,2);
AllBestTestParameterPrecisionMeans=mean(AllBestTestParameterPrecision,2);

AllBestPosteriorPrecisionStandardDeviation=(std(AllBestPosteriorPrecision'))';
AllBestPriorPrecisionStandardDeviation=(std(AllBestPriorPrecision'))';
AllBestTrainingParameterPrecisionStandardDeviation=(std(AllBestTrainingParameterPrecision'))';
AllBestTestParameterPrecisionStandardDeviation=(std(AllBestTestParameterPrecision'))';

AllAccuracyResults=horzcat(MaxCosts,AllBestPosteriorAccuracyMeans,AllBestPosteriorAccuracyStandardDeviation,AllBestPriorAccuracyMeans,AllBestPriorAccuracyStandardDeviation,AllBestTrainingParameterAccuracyMeans,AllBestTrainingParameterAccuracyStandardDeviation,AllBestTestParameterAccuracyMeans,AllBestTestParameterAccuracyStandardDeviation);
AllPrecisionResults=horzcat(MaxCosts, AllBestPosteriorPrecisionMeans,AllBestPosteriorPrecisionStandardDeviation,AllBestPriorPrecisionMeans,AllBestPriorPrecisionStandardDeviation,AllBestTrainingParameterPrecisionMeans,AllBestTrainingParameterPrecisionStandardDeviation,AllBestTestParameterPrecisionMeans,AllBestTestParameterPrecisionStandardDeviation);
csvwrite(strcat(InputFolder,MainResultFile2),vertcat(AllAccuracyResults,AllPrecisionResults));

display(sprintf('All Pools ,Posterior >= Least Error =%d',length(find(AllAccuracyResults(:,2)>=AllAccuracyResults(:,6)))));
display(sprintf('All Pools ,Posterior >= Prior =%d',length(find(AllPrecisionResults(:,2)>=AllPrecisionResults(:,4)))));

BestPriorAccuracyMeanAllRunsMean=mean(BestPriorAccuracyMeanAllRuns,2);
BestPosteriorAccuracyMeanAllRunsMean=mean(BestPosteriorAccuracyMeanAllRuns,2);
BestTrainingParameterAccuracyMeanAllRunsMean=mean(BestTrainingParameterAccuracyMeanAllRuns,2);
BestTestParameterAccuracyMeanAllRunsMean=mean(BestTestParameterAccuracyMeanAllRuns,2);

BestPriorPrecisionMeanAllRunsMean=mean(BestPriorPrecisionMeanAllRuns,2);
BestPosteriorPrecisionMeanAllRunsMean=mean(BestPosteriorPrecisionMeanAllRuns,2);
BestTrainingParameterPrecisionMeanAllRunsMean=mean(BestTrainingParameterPrecisionMeanAllRuns,2);
BestTestParameterPrecisionMeanAllRunsMean=mean(BestTestParameterPrecisionMeanAllRuns,2);

BestPriorAccuracyMeanAllRunsSTD=(std(BestPriorAccuracyMeanAllRuns'))';
BestPosteriorAccuracyMeanAllRunsSTD=(std(BestPosteriorAccuracyMeanAllRuns'))';
BestTrainingParameterAccuracyMeanAllRunsSTD=(std(BestTrainingParameterAccuracyMeanAllRuns'))';
BestTestParameterAccuracyMeanAllRunsSTD=(std(BestTestParameterAccuracyMeanAllRuns'))';

BestPriorPrecisionMeanAllRunsSTD=(std(BestPriorPrecisionMeanAllRuns'))';
BestPosteriorPrecisionMeanAllRunsSTD=(std(BestPosteriorPrecisionMeanAllRuns'))';
BestTrainingParameterPrecisionMeanAllRunsSTD=(std(BestTrainingParameterPrecisionMeanAllRuns'))';
BestTestParameterPrecisionMeanAllRunsSTD=(std(BestTestParameterPrecisionMeanAllRuns'))';

AccuracyResultsAllRuns=horzcat(MaxCosts,BestPosteriorAccuracyMeanAllRunsMean,BestPosteriorAccuracyMeanAllRunsSTD,BestPriorAccuracyMeanAllRunsMean,BestPriorAccuracyMeanAllRunsSTD,BestTrainingParameterAccuracyMeanAllRunsMean,BestTrainingParameterAccuracyMeanAllRunsSTD,BestTestParameterAccuracyMeanAllRunsMean,BestTestParameterAccuracyMeanAllRunsSTD);
PrecisionResultsAllRuns=horzcat(MaxCosts, BestPosteriorPrecisionMeanAllRunsMean,BestPosteriorPrecisionMeanAllRunsSTD,BestPriorPrecisionMeanAllRunsMean,BestPriorPrecisionMeanAllRunsSTD,BestTrainingParameterPrecisionMeanAllRunsMean,BestTrainingParameterPrecisionMeanAllRunsSTD,BestTestParameterPrecisionMeanAllRunsMean,BestTestParameterPrecisionMeanAllRunsSTD);
csvwrite(strcat(InputFolder,MainResultFile3),vertcat(AccuracyResultsAllRuns,PrecisionResultsAllRuns));

display(sprintf(' Pools ,Posterior >= Least Error =%d',length(find(AccuracyResultsAllRuns(:,2)>=AccuracyResultsAllRuns(:,6)))));
display(sprintf(' Pools ,Posterior >= Prior =%d',length(find(AccuracyResultsAllRuns(:,2)>=AccuracyResultsAllRuns(:,4)))));
diary off