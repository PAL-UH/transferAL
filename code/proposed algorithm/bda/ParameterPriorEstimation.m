clc
clear all
close all

StartingColumn=1;

SampleInputFileType='Source_Sample_Dataset_80.csvSource_Sample_Dataset_%d.csv';
ChoiceOfLearningAlgorithm='MNN';


NumberOfFolds=10;
ParameterRange=2:50;
%PositiveClass=0;
DisplayString='Sample Number= %d, ParameterValueNumber=%d';
OutputResultsFileType='Source_Results_Sample_Dataset_%d.csv';
OutputPredictionsFileType='Source_Predictions_Sample_Dataset_%d.csv';

SamplePercentage=80;

tic
    
    for SampleNumber=1:100
               
        SampleInputFile=sprintf(SampleInputFileType,SampleNumber);
        OutputResultsFile=sprintf(OutputResultsFileType,SampleNumber);
        OutputPredictionsFile=sprintf(OutputPredictionsFileType,SampleNumber);
        
        SampleRawData= csvread(SampleInputFile);
        [SampleRawDataRows SampleRawDataCols]=size(SampleRawData);        
        SampleData=SampleRawData(:,StartingColumn:SampleRawDataCols-1);
        SampleLabels=SampleRawData(:,SampleRawDataCols);
        [SampleDataRows SampleDataCols]=size(SampleData);
               
        
        UniqueLabels=unique(SampleLabels);
        NumClass=length(UniqueLabels);
        TrueLabels=SampleLabels;
        AllIndices=(1:SampleDataRows)';
        NumberofExamplesPerFold=floor(SampleDataRows/NumberOfFolds);
        
        EveryPredictedLabels=zeros(SampleDataRows,length(ParameterRange));
        AllClassificationAccuracy=zeros(length(ParameterRange),1);
        AllTPRate=zeros(length(ParameterRange),NumClass*2);
        AllPrecisions=zeros(length(ParameterRange),NumClass*3);
        %AllTAUC1=zeros(length(ParameterRange),1);
        
        for ParameterValueNumber=1:length(ParameterRange)
            ParameterValue=ParameterRange(1,ParameterValueNumber);
            display(sprintf(DisplayString,SampleNumber,ParameterValueNumber));
            AllPredictedLabels=zeros(SampleDataRows,1);
            
            for k=1:NumberOfFolds
                TestDataStartIndex=(k-1)*NumberofExamplesPerFold+1;
                TestDataEndIndex=(k)*NumberofExamplesPerFold;
                if k==NumberOfFolds
                    TestDataEndIndex=TestDataEndIndex+mod(SampleDataRows,NumberOfFolds);
                end
                TestDataIndices=(TestDataStartIndex:TestDataEndIndex)';
                TestData=SampleData(TestDataIndices,:);
                TestLabels=SampleLabels(TestDataIndices,:);
                TrainingDataIndices=setdiff(AllIndices,TestDataIndices);
                TrainingData=SampleData(TrainingDataIndices,:);
                TrainingLabels=SampleLabels(TrainingDataIndices,:);
                
                Model=train_with_MNN(TrainingData,TrainingLabels,ParameterValue);
                [PredictedLabels, PredictedPosterior]=test_with_MNN(Model,TestData,UniqueLabels);
                AllPredictedLabels(TestDataStartIndex:TestDataEndIndex)=PredictedLabels;
                
            end
            
            ClassificationAccuracy=find_classification_accuracy(TrueLabels,AllPredictedLabels);
            TPRate=find_true_positive_rate_per_class(TrueLabels,AllPredictedLabels);
            Precisions=find_precision_rate_per_class(TrueLabels,AllPredictedLabels);
            
            %[TXCoord1,TYCoord1,TThresholrray1,TAUC1] = perfcurve(TrueLabels,AllPredictedLabels,PositiveClass);
            
            EveryPredictedLabels(:,ParameterValueNumber)=AllPredictedLabels;
            AllClassificationAccuracy(ParameterValueNumber,:)=ClassificationAccuracy;
            AllTPRate(ParameterValueNumber,:)=TPRate;
            AllPrecisions(ParameterValueNumber,:)=Precisions;
%            AllTAUC1(ParameterValueNumber,:)=TAUC1;

            
            
        end
        
        
        AllResults=horzcat((ParameterRange)',AllClassificationAccuracy,AllTPRate,AllPrecisions);
        %csvwrite(strcat(OutputFolder,OutputResultsFile),AllResults);
        %csvwrite(strcat(OutputFolder,OutputPredictionsFile),horzcat(SampleLabels,EveryPredictedLabels));
		csvwrite(OutputResultsFile,AllResults);
        csvwrite(OutputPredictionsFile,horzcat(SampleLabels,EveryPredictedLabels));
        
        
    end
    
    tp = toc
