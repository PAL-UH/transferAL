%%%%%%% LCEQ %%%%%%%

clc
clear all
close all

PriorMean=34; %Insert Prior Mean
TestStartingColumn=1; RandomPoolStartingColumn=2;


TestInputFileType='Target_Test_%d.csv';
PoolInputFileType='Target_Random_Pool_%d.csv';

MaxCost=50;%floor(TargetRawDataRows/2);
InitialCost=40;
NumIterations=MaxCost;
AllQueries=(1:NumIterations)';
MaxNumberOfRuns=1;InitialPoolNumber=1;
FinalPoolNumber=10;
NumberOfPools=FinalPoolNumber-InitialPoolNumber+1;

K_MCE=1;
K_LCE=1;
PositiveClass=0;
PrintStep=50;

%PoolShiftFeature=ShiftFeature+RandomPoolStartingColumn-1;
%TestShiftFeature=ShiftFeature+TestStartingColumn-1;
%ZetaValues=zeros(MaxCost,MaxNumberOfRuns);% PrecisionOutputFile='Supernova_Precision_Results_MCEQ.csv';
ZetaValuesFileType='LCEQ_%dH_30V_ZetaValues_Pool_%d.csv';

AccuracyOutputFilePerRunType='LCEQ_%dH_30V_Accuracy_Results_Pool_%d.csv';
TPRateOutputFilePerRunType='LCEQ_%dH_30V_TPRate_Results_Pool_%d.csv';
PrecisionOutputFilePerRunType='LCEQ_%dH_30V_Precision_Results_Pool_%d.csv';
PoolDataFolder='';%'C:\Users\kinjal\Dropbox\PhD Authentic\Datasets\Supernova_2C\Supernova 2C Pool Data\';
TestDataFolder='';%'C:\Users\kinjal\Dropbox\PhD Authentic\Datasets\Supernova_2C\Supernova 2C Pool Data\Supernova 2 Class Test Data\';
OutputFolder='';%'C:\Users\kinjal\Dropbox\PhD Authentic\Results\MyLCEQAlgo\Supernova 2C\';


PoolNumber=8;
PoolInputFile=sprintf(PoolInputFileType,PoolNumber);
PoolRawData= csvread(strcat(PoolDataFolder,PoolInputFile));
ZetaValues=zeros(MaxCost,MaxNumberOfRuns);% PrecisionOutputFile=;
[PoolRawDataRows PoolRawDataCols]=size(PoolRawData);

PoolData=PoolRawData(:,RandomPoolStartingColumn:PoolRawDataCols-1);
PoolLabels=PoolRawData(:,PoolRawDataCols);
[PoolDataRows PoolDataCols]=size(PoolData);

UniqueLabels=unique(PoolLabels);
NumClass=length(UniqueLabels);

TestInputFile=sprintf(TestInputFileType,PoolNumber);
TestRawData=csvread(strcat(TestDataFolder,TestInputFile));
[TestDataRows TestDataCols]=size(TestRawData);
TestData=TestRawData(:,TestStartingColumn:TestDataCols-1);
TrueLabels=TestRawData(:,TestDataCols);

DiaryFileType='LCEQ_%dH_%dH_30V_Accuracy_Results_Pool_%d.txt';
RandomPoolData=PoolData;
RandomPoolLabels=PoolLabels;
%unique_indices = zeros(NumClass)

%for i=1:NumClass
%    unique_induces(i) = find(RandomPoolLabels==i);
%end

RandomPoolAllIndices=(1:PoolDataRows)';
tic
for NumberOfHiddenNodes=PriorMean:PriorMean+1
	ClassificationAccuracy=zeros(MaxCost,MaxNumberOfRuns);
	TPRate=zeros(MaxCost,MaxNumberOfRuns);
	Precision=zeros(MaxCost,MaxNumberOfRuns);
	RunNumber=0;
	IndexNumber=0;
	Lambda=1;
	%Zeta= binornd(1,Lambda)
	IndexShift=0;
	diary(sprintf(DiaryFileType,PriorMean,PriorMean+1,PoolNumber));diary on
	
	
	AccuracyOutputFilePerRun=sprintf(AccuracyOutputFilePerRunType,NumberOfHiddenNodes,PoolNumber);
	TPRateOutputFilePerRun=sprintf(TPRateOutputFilePerRunType,NumberOfHiddenNodes,PoolNumber);
	PrecisionOutputFilePerRun=sprintf(PrecisionOutputFilePerRunType,NumberOfHiddenNodes,PoolNumber);
	%%ZetaValuesFilePerRun=sprintf(ZetaValuesFileType,PoolNumber)OutputFolder='';ts\LCEQ\Supernova\';
	QueriesOutputFilePerRunType='LCEQ_%dH_30V_Queries_Pool_%d.csv';
	QueriesOutputFilePerRun=sprintf(QueriesOutputFilePerRunType,NumberOfHiddenNodes,PoolNumber);
	AllQueryIndices=zeros(MaxCost,MaxNumberOfRuns);
	while RunNumber<MaxNumberOfRuns
		RunNumber=RunNumber+1
		IndexNumber=IndexNumber+1;
		%Zeta= binornd(1,Lambda)
		StartIndex=(IndexNumber-1)*InitialCost+1+IndexShift
		EndIndex=(IndexNumber)*InitialCost+IndexShift
		QueriedLabels=RandomPoolLabels(StartIndex:EndIndex,:);
		if length(unique(QueriedLabels))~=NumClass
			display('Wrong Initial Dataset');
            %for i=1:NumClass
            %    lbl = find(QueriedLabels==i);
            %    if isempty(lbl)
            %        idx = randsample(unique_induces(i), 1);
            %        RandomPoolLabels(idx)
            %    end
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
		%[TXCoord1,TYCoord1,TThresholrray1] = perfcurve(TrueLabels,TestPredictedLabels,PositiveClass);
		TPRate(Cost,RunNumber)=TPRates(1,4);
		Precision(Cost,RunNumber)=Precisions(1,6);
		Iteration=0;
		DisplayString='PoolNumber =%d RunNumber= %d Iteration = %d, Cost = %d';

		while Cost<MaxCost
			Iteration=Iteration+1;     ZetaValues(Cost,RunNumber)= binornd(1,Lambda);
			NotQueriedIndices=setdiff(RandomPoolAllIndices,QueriedIndices);
			PoolUnlabeledData=RandomPoolData(NotQueriedIndices,:);
			PoolUnlabeledDataLabels=RandomPoolLabels(NotQueriedIndices,:);
			PoolUnlabeledDataRows=length(PoolUnlabeledDataLabels);
			[PoolPredictedLabels, PoolPredictedPosterior]=test_with_MNN(CurrentModel,PoolUnlabeledData,UniqueLabels);
			Cost
			if ZetaValues(Cost,RunNumber)==1
				[Margins]=marging_sampling(PoolPredictedPosterior);
				[SortedMargins, SortedMarginIndices]=sortrows(Margins);
				MinMarginSampleIndices=SortedMarginIndices(1:K_LCE,:);

				LCEQExamples=PoolUnlabeledData(MinMarginSampleIndices,:);
				%LCEQExamplePredictedLabels=PoolPredictedLabels(MinMarginSampleIndices,:);
				
			else
				if length(PoolUnlabeledData(:,1))>K_LCE
					[LCEQExamples MinMarginSampleIndices]=datasample(PoolUnlabeledData,K_LCE);
				else
					LCEQExamples=PoolUnlabeledData;
					MinMarginSampleIndices=(1:length(PoolUnlabeledData(:,1)))';
				end
			end
			LCEQExamplesIndices=NotQueriedIndices(MinMarginSampleIndices,:);
			LCEQExamplesLabels=PoolUnlabeledDataLabels(MinMarginSampleIndices,:);

			QueriedData=vertcat(QueriedData,LCEQExamples);
			QueriedLabels=vertcat(QueriedLabels,LCEQExamplesLabels);
			QueriedIndices=vertcat(QueriedIndices,LCEQExamplesIndices);
			Cost=Cost+K_LCE;
			
			TrainingModel=train_with_MNN(QueriedData,QueriedLabels,NumberOfHiddenNodes);
			[TestPredictedLabels, TestPredictedPosterior]=test_with_MNN(TrainingModel,TestData,UniqueLabels);
			ClassificationAccuracy(Cost,RunNumber)=find_classification_accuracy(TrueLabels,TestPredictedLabels);
			TPRates=find_true_positive_rate_per_class(TrueLabels,TestPredictedLabels);
			Precisions=find_precision_rate_per_class(TrueLabels,TestPredictedLabels);
%			[TXCoord1,TYCoord1,TThresholrray1] = perfcurve(TrueLabels,TestPredictedLabels,PositiveClass);
			TPRate(Cost,RunNumber)=TPRates(1,4);
			Precision(Cost,RunNumber)=Precisions(1,6);
				
			% end
			CurrentModel=TrainingModel;
			if mod(Cost,PrintStep)==0
				display(sprintf(DisplayString,PoolNumber, RunNumber, Iteration,Cost));
			end
			
			
		end
		AllQueryIndices(:,RunNumber)=QueriedIndices;
		csvwrite(strcat(OutputFolder,QueriesOutputFilePerRun),AllQueryIndices);	
		csvwrite(strcat(OutputFolder,AccuracyOutputFilePerRun),ClassificationAccuracy);
		csvwrite(strcat(OutputFolder,TPRateOutputFilePerRun),TPRate);
		csvwrite(strcat(OutputFolder,PrecisionOutputFilePerRun),Precision);
		
	end

	% csvwrite(AccuracyOutputFile,ClassificationAccuracy);
	% csvwrite(TPRateOutputFile,TPRate);
	% csvwrite(PrecisionOutputFile,Precision);
	% csvwrite(AUCOutputFile,TAUC);

	if length(find(RandomPoolLabels(QueriedIndices,:)~=QueriedLabels))~=0
		display('Algorithm not correct')
	end
	display('LCEQ Algorithm Done');diary off
end
t=toc