%%%%%%% MCEQ %%%%%%%

clc
clear all
close all
InputFolder='';
TargetRawDataInputFile='mars-tgt.csv';
%TargetRawData=csvread(strcat(InputFolder,TargetRawDataInputFile));
TargetRawData=csvread(TargetRawDataInputFile);
[TargetRawDataRows TargetRawDataCols]=size(TargetRawData);
TargetIndices=(1:TargetRawDataRows)';
StartingColumn=1;

TargetData=TargetRawData(:,StartingColumn:TargetRawDataCols-1);
TargetLabels=TargetRawData(:,TargetRawDataCols);
%TargetData=zscore(TargetData);

PoolInputFolder='';
PoolInputFileType='LCEQ_34H_30V_Accuracy_Results_Pool_%d.csv';

MaxCost=300;%floor(TargetRawDataRows/2);
InitialCost=10;
NumIterations=MaxCost-InitialCost+1;
AllQueries=(1:NumIterations)';
MaxNumberOfRuns=10;
InitialPoolNumber=1;
FinalPoolNumber=15;
NumberOfPools=FinalPoolNumber-InitialPoolNumber+1;
%NumberOfHiddenNodes=9;%%NumberOfHiddenNodes=9;
K_MCE=1;
K_LCE=1;
PositiveClass=1;
PrintStep=50;

% AccuracyOutputFile='Landmine_Accuracy_Results_MCEQ.csv';
% TPRateOutputFile='Landmine_TPRate_Results_MCEQ.csv';
%ZetaValues=zeros(MaxCost,MaxNumberOfRuns);
%QueriesOutputFileType='LCEQ_%dH_Landmine_Queries_Pool_%d.csv'

AccuracyOutputFilePerRunType='LCEQ_%dH_%dH_30V_Accuracy_Results_Pool_%d.csv';
TPRateOutputFilePerRunType='LCEQ_%dH_30V_TPRate_Results_Pool_%d.csv';
PrecisionOutputFilePerRunType='LCEQ_%dH_30V_Precision_Results_Pool_%d.csv';
AUCOutputFilePerRunType='LCEQ_%dH_30V_AUC_Results_Pool_%d.csv';


PoolNumber=1;
PoolInputFile=sprintf(PoolInputFileType,PoolNumber);
PoolRawData= csvread(strcat(PoolInputFolder,PoolInputFile));
%PoolRawData= csvread(PoolInputFile);
PoolIndices=PoolRawData(:,1);

PoolData=TargetData(PoolIndices,:);
PoolLabels=TargetLabels(PoolIndices,:);
[PoolDataRows PoolDataCols]=size(PoolData);

UniqueLabels=unique(PoolLabels);
NumClass=length(UniqueLabels);

TestDataIndices=setdiff(TargetIndices,PoolIndices);
TestData=TargetData(TestDataIndices,:);
TestLabels=TargetLabels(TestDataIndices,:);
TrueLabels=TestLabels;

RandomIndices=PoolIndices(PoolRawData(:,3),1);
RandomPoolData=TargetData(RandomIndices,:);
RandomPoolLabels=TargetLabels(RandomIndices,:);
RandomPoolAllIndices=(1:PoolDataRows)';


for NumberOfHiddenNodes=11:11
ClassificationAccuracy=zeros(MaxCost,MaxNumberOfRuns);
TPRate=zeros(MaxCost,MaxNumberOfRuns);
Precision=zeros(MaxCost,MaxNumberOfRuns);
TAUC=zeros(MaxCost,MaxNumberOfRuns);
RunNumber=0;
IndexNumber=0;
Lambda=1;%Lambda=0.26;
AllQueryIndices=zeros(MaxCost,MaxNumberOfRuns);
IndexShift=0;
AccuracyOutputFilePerRun=sprintf(AccuracyOutputFilePerRunType,NumberOfHiddenNodes,PoolNumber);
TPRateOutputFilePerRun=sprintf(TPRateOutputFilePerRunType,NumberOfHiddenNodes,PoolNumber);
PrecisionOutputFilePerRun=sprintf(PrecisionOutputFilePerRunType,NumberOfHiddenNodes,PoolNumber);
AUCOutputFilePerRun=sprintf(AUCOutputFilePerRunType,NumberOfHiddenNodes,PoolNumber);
OutputFolder='';%'C:\Users\kinjal\Dropbox\PhD Authentic\Results\LCEQ_%dH\Landmine\';
	QueriesOutputFilePerRunType='LCEQR_%dH_30V_Queries_Pool_%d.csv';
	QueriesOutputFilePerRun=sprintf(QueriesOutputFilePerRunType,NumberOfHiddenNodes,PoolNumber);
	AllQueryIndices=zeros(MaxCost,MaxNumberOfRuns)
while RunNumber<MaxNumberOfRuns
	%%%ZetaValues(Cost,RunNumber)= binornd(1,Lambda);
    RunNumber=RunNumber+1;
    IndexNumber=IndexNumber+1;
    %%ZetaValues(Cost,RunNumber)= binornd(1,Lambda); 
    StartIndex=(IndexNumber-1)*InitialCost+1+IndexShift;
    EndIndex=(IndexNumber)*InitialCost+IndexShift;
    QueriedLabels=RandomPoolLabels(StartIndex:EndIndex,:);
    if length(unique(QueriedLabels))~=NumClass
        display('Wrong Initial Dataset');
        RunNumber=RunNumber-1;
        IndexNumber=IndexNumber-1;
        IndexShift=IndexShift+1;
        continue
    end
    QueriedData=RandomPoolData(StartIndex:EndIndex,:);
    
    QueriedIndices=(StartIndex:EndIndex)';
    Cost =InitialCost;
    InitialModel=train_with_MNN(QueriedData,QueriedLabels,NumberOfHiddenNodes);
    CurrentModel=InitialModel;
    [TestPredictedLabels, TestPredictedPosterior]=test_with_MNN(InitialModel,TestData,UniqueLabels);
    ClassificationAccuracy(Cost,RunNumber)=find_classification_accuracy(TrueLabels,TestPredictedLabels);
    TPRates=find_true_positive_rate_per_class(TrueLabels,TestPredictedLabels);
    Precisions=find_precision_rate_per_class(TrueLabels,TestPredictedLabels);
    [TXCoord1,TYCoord1,TThresholrray1,TAUC(Cost,RunNumber)] = perfcurve(TrueLabels,TestPredictedLabels,PositiveClass);
    TPRate(Cost,RunNumber)=TPRates(1,4);
    Precision(Cost,RunNumber)=Precisions(1,6);
    Iteration=0;
    DisplayString='PoolNumber =%d RunNumber= %d Iteration = %d, Cost = %d';

    while Cost<MaxCost
        Iteration=Iteration+1;
        NotQueriedIndices=setdiff(RandomPoolAllIndices,QueriedIndices);
        PoolUnlabeledData=PoolData(NotQueriedIndices,:);
        PoolUnlabeledDataLabels=PoolLabels(NotQueriedIndices,:);
        PoolUnlabeledDataRows=length(PoolUnlabeledDataLabels);
        [PoolPredictedLabels, PoolPredictedPosterior]=test_with_MNN(CurrentModel,PoolUnlabeledData,UniqueLabels);
        %ZetaValues(Cost,RunNumber)= binornd(1,Lambda);
        if Lambda==1
            [Margins]=marging_sampling(PoolPredictedPosterior);
            [SortedMargins, SortedMarginIndices]=sortrows(Margins);
            MinMarginSampleIndices=SortedMarginIndices(1:K_LCE,:);

            LCEQ_Examples=PoolUnlabeledData(MinMarginSampleIndices,:);
            %LCEQ_%dHExamplePredictedLabels=PoolPredictedLabels(MinMarginSampleIndices,:);
            
        else
            if length(PoolUnlabeledData(:,1))>K_LCE
                [LCEQ_Examples MinMarginSampleIndices]=datasample(PoolUnlabeledData,K_LCE);
            else
                LCEQ_Examples=PoolUnlabeledData;
                MinMarginSampleIndices=(1:length(PoolUnlabeledData(:,1)))';
            end
        end
        LCEQ_ExamplesIndices=NotQueriedIndices(MinMarginSampleIndices,:);
        LCEQ_ExamplesLabels=PoolUnlabeledDataLabels(MinMarginSampleIndices,:);

        QueriedData=vertcat(QueriedData,LCEQ_Examples);
        QueriedLabels=vertcat(QueriedLabels,LCEQ_ExamplesLabels);
        QueriedIndices=vertcat(QueriedIndices,LCEQ_ExamplesIndices);
        Cost=Cost+K_LCE;

        TrainingModel=train_with_MNN(QueriedData,QueriedLabels,NumberOfHiddenNodes);
        [TestPredictedLabels, TestPredictedPosterior]=test_with_MNN(TrainingModel,TestData,UniqueLabels);
        ClassificationAccuracy(Cost,RunNumber)=find_classification_accuracy(TrueLabels,TestPredictedLabels);
        TPRates=find_true_positive_rate_per_class(TrueLabels,TestPredictedLabels);
        Precisions=find_precision_rate_per_class(TrueLabels,TestPredictedLabels);
        [TXCoord1,TYCoord1,TThresholrray1,TAUC(Cost,RunNumber)] = perfcurve(TrueLabels,TestPredictedLabels,PositiveClass);
        TPRate(Cost,RunNumber)=TPRates(1,4);
        Precision(Cost,RunNumber)=Precisions(1,6);
            
        % end
        CurrentModel=TrainingModel;
        if mod(Cost,PrintStep)==0
            display(sprintf(DisplayString,PoolNumber, RunNumber, Iteration,Cost));
        end
        
        
    end
	csvwrite(strcat(OutputFolder,AccuracyOutputFilePerRun),ClassificationAccuracy);
	csvwrite(strcat(OutputFolder,TPRateOutputFilePerRun),TPRate);
	csvwrite(strcat(OutputFolder,PrecisionOutputFilePerRun),Precision);
	csvwrite(strcat(OutputFolder,AUCOutputFilePerRun),TAUC);	%csvwrite(strcat(OutputFolder,%ZetaValuesFilePerRun),%ZetaValues);	  
	  		AllQueryIndices(:,RunNumber)=QueriedIndices;
		csvwrite(strcat(OutputFolder,QueriesOutputFilePerRun),AllQueryIndices);	
end


% csvwrite(AccuracyOutputFile,ClassificationAccuracy);
% csvwrite(TPRateOutputFile,TPRate);
% csvwrite(PrecisionOutputFile,Precision);
% csvwrite(AUCOutputFile,TAUC);
if length(find(RandomPoolLabels(QueriedIndices,:)~=QueriedLabels))~=0
		display('Algorithm not correct')
	end
	display('LCEQ Algorithm Done');
end


% csvwrite(AccuracyOutputFile,ClassificationAccuracy);
% csvwrite(TPRateOutputFile,TPRate);
% csvwrite(PrecisionOutputFile,Precision);
% csvwrite(AUCOutputFile,TAUC);


display('LCEQ_%dH Algorithm Done');
