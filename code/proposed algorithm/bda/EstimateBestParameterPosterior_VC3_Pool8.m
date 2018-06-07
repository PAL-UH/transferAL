%%%%% Estimation of Posterior Probability of Parameter%%%

clc
clear all
close all

TestStartingColumn=2;
RandomPoolStartingColumn=3;
PriorMean=PRIOR_MEAN;
PriorStandardDeviation=PRIOR_STD;
% PriorMean=106.23;
% PriorStandardDeviation=45.94;
%PriorParameter=floor(PriorMean);
PriorParameter=ceil(PriorMean);
InitialParameterValue=floor(PriorMean-(1*PriorStandardDeviation));
FinalParameterValue=ceil(PriorMean+(1*PriorStandardDeviation));
ParameterRange=(InitialParameterValue:FinalParameterValue)';
NumberOfParameterValues=length(ParameterRange);

QueryInputFolder='';
TestInputFolder='';
RandomPoolInputFolder='';
OutputFolder='';


% QueryInputFolder='C:\Users\Sisyphus\Dropbox\PhD Authentic\Results\MyLCEQAlgo\Supernova 2C\';
% TestInputFolder='C:\Users\Sisyphus\Dropbox\PhD Authentic\Datasets\Supernova_2C\Supernova 2C Pool Data\Supernova 2 Class Test Data\';
% RandomPoolInputFolder='C:\Users\Sisyphus\Dropbox\PhD Authentic\Datasets\Supernova_2C\Supernova 2C Pool Data\';
% OutputFolder='C:\Users\Sisyphus\Dropbox\PhD Authentic\Results\MyAlgoParameterEstimation\';




TestInputFileType='Target_Test_%d.csv';
PoolInputFileType='Target_Random_Pool_%d.csv';
QueryInputFileType='LCEQ_H_PRIOR_MEAN__30V_Target_Queries_Pool_%d.csv';
PriorInputFile='Priors_BasedOnMaxAccuracy.csv';

PriorAccuracyOutputFileType='Target_30V_PriorAccuracy_Pool_%d_H_PRIOR_MEAN_FullSD_VC3.csv';
PosteriorAccuracyOutputFileType='Target_30V_PosteriorAccuracy_Pool_%d_H_PRIOR_MEAN_FullSD_VC3.csv';
PriorTPRateOutputFileType='Target_30V_PriorTPRate_Pool_%d_H_PRIOR_MEAN_FullSD_VC3.csv';
PosteriorTPRateOutputFileType='Target_30V_PosteriorTPRate_Pool_%d_H_PRIOR_MEAN_FullSD_VC3.csv';
PriorPrecisionOutputFileType='Target_30V_PriorPrecision_Pool_%d_H_PRIOR_MEAN_FullSD_VC3.csv';
PosteriorPrecisionOutputFileType='Target_30V_PosteriorPrecision_Pool_%d_H_PRIOR_MEAN_FullSD_VC3.csv';
PriorTAUCOutputFileType='Target_30V_PriorTAUC_Pool_%d_H_PRIOR_MEAN_FullSD_VC3.csv';
PosteriorTAUCOutputFileType='Target_30V_PosteriorTAUC_Pool_%d_H_PRIOR_MEAN_FullSD_VC3.csv';
DiaryFileType='Target_30V_Posterior_Pool_%d_H_PRIOR_MEAN_FullSD_VC3.txt';
RawPosteriorFileType='Target_30V_Posterior_Pool_%d_H_PRIOR_MEAN_FullSD_VC3.csv';
ImageFileType='Target_30V_Posterior_Pool_%d_H_PRIOR_MEAN_FullSD_VC3_Run_%d';
PositiveClass=0;
NumberOfHiddenNodes=12;
PaperTheoremNumber=3;
MaxCostArray=[100;200;500;1000];
NumberOfMaxCosts=length(MaxCostArray);
NumberOfRuns=10;
TagStringType='H=%d';

AllPriorsRaw=csvread(strcat(OutputFolder,PriorInputFile));
AllPriors=AllPriorsRaw(InitialParameterValue-1:FinalParameterValue-1,2);

BestParameterPerRun=zeros(NumberOfMaxCosts,NumberOfRuns);
ClassificationAccuracy=zeros(NumberOfMaxCosts,NumberOfRuns);
TPRate=zeros(NumberOfMaxCosts,NumberOfRuns);
Precision=zeros(NumberOfMaxCosts,NumberOfRuns);
TAUC=zeros(NumberOfMaxCosts,NumberOfRuns);
ClassificationAccuracyPriorParameter=zeros(NumberOfMaxCosts,NumberOfRuns);
TPRatePriorParameter=zeros(NumberOfMaxCosts,NumberOfRuns);
PrecisionPriorParameter=zeros(NumberOfMaxCosts,NumberOfRuns);
TAUCPriorParameter=zeros(NumberOfMaxCosts,NumberOfRuns);
ClassificationAccuracyBestAccuracy=zeros(NumberOfMaxCosts,NumberOfRuns);
TPRateBestAccuracy=zeros(NumberOfMaxCosts,NumberOfRuns);
PrecisionBestAccuracy=zeros(NumberOfMaxCosts,NumberOfRuns);
TAUCBestAccuracy=zeros(NumberOfMaxCosts,NumberOfRuns);
ClassificationAccuracyBestTrainingAccuracy=zeros(NumberOfMaxCosts,NumberOfRuns);
TPRateBestTrainingAccuracy=zeros(NumberOfMaxCosts,NumberOfRuns);
PrecisionBestTrainingAccuracy=zeros(NumberOfMaxCosts,NumberOfRuns);
TAUCBestTrainingAccuracy=zeros(NumberOfMaxCosts,NumberOfRuns);
NumberOfRepetitions=10;
for PoolNumber=8:8
    close all
    RandomPoolInputFile=sprintf(PoolInputFileType,PoolNumber);
    TestInputFile=sprintf(TestInputFileType,PoolNumber);
    PriorAccuracyOutputFile=sprintf(PriorAccuracyOutputFileType,PoolNumber);
    PosteriorAccuracyOutputFile=sprintf(PosteriorAccuracyOutputFileType,PoolNumber);
    PriorTPRateOutputFile=sprintf(PriorTPRateOutputFileType,PoolNumber);
    PosteriorTPRateOutputFile=sprintf(PosteriorTPRateOutputFileType,PoolNumber);
    PriorPrecisionOutputFile=sprintf(PriorPrecisionOutputFileType,PoolNumber);
    PosteriorPrecisionOutputFile=sprintf(PosteriorPrecisionOutputFileType,PoolNumber);
    PriorTAUCOutputFile=sprintf(PriorTPRateOutputFileType,PoolNumber);
    PosteriorTAUCOutputFile=sprintf(PosteriorTPRateOutputFileType,PoolNumber);
    DiaryFile=sprintf(DiaryFileType,PoolNumber);
    RawPosteriorFile=sprintf(RawPosteriorFileType,PoolNumber);
    diary(strcat(OutputFolder,DiaryFile));
    diary on
    
    RandomPoolRawData=csvread(strcat(RandomPoolInputFolder, RandomPoolInputFile));
    [RandomPoolRawDataRows, RandomPoolRawDataCols]=size(RandomPoolRawData);
    RandomPoolData=RandomPoolRawData(:,RandomPoolStartingColumn:RandomPoolRawDataCols-1);
    RandomPoolLabels=RandomPoolRawData(:,RandomPoolRawDataCols);
    
    UniqueLabels=unique(RandomPoolLabels);
    NumberOfClasses=length(UniqueLabels);
    
   
    TestRawData=csvread(strcat(TestInputFolder, TestInputFile));
    [TestRawDataRows, TestRawDataCols]=size(TestRawData);
    TestData=TestRawData(:,TestStartingColumn:TestRawDataCols-1);
    TestLabels=TestRawData(:,TestRawDataCols);
    
    AllRawPosterior=[];
    for MaxCostNumber=1:NumberOfMaxCosts
        close all
        MaxCost=MaxCostArray(MaxCostNumber,1);
        AllRawPosteriorPerRun=[];
        for RunNumber=1:NumberOfRuns
            
			ParameterValue=0;
			CA=zeros(NumberOfParameterValues,NumberOfRepetitions);
			TPR=zeros(NumberOfParameterValues,NumberOfRepetitions);
			PR=zeros(NumberOfParameterValues,NumberOfRepetitions);
			TROC=zeros(NumberOfParameterValues,NumberOfRepetitions);
			TrainError=zeros(NumberOfParameterValues,NumberOfRepetitions);
			
			AllLikelihood=zeros(NumberOfParameterValues,1);
			AllError=zeros(NumberOfParameterValues,1);
			
            figure
            for NumberOfHiddenNodes=InitialParameterValue:FinalParameterValue
				ParameterValue=ParameterValue+1;
                QueryInputFile=sprintf(QueryInputFileType,PoolNumber);
                AllQueryIndices=csvread(strcat(QueryInputFolder, QueryInputFile));
                
                QueryIndices=AllQueryIndices(1:MaxCost,RunNumber);
                TrainingPoolData=RandomPoolData(QueryIndices,:);
                TrainingPoolLabels=RandomPoolLabels(QueryIndices,1);
                [NumberOfTrainingExamples,NumberOfFeatures]=size(TrainingPoolData);
                TotalError=0;
                for i=1:NumberOfRepetitions
                    [Model]=train_with_MNN(TrainingPoolData,TrainingPoolLabels,NumberOfHiddenNodes);
                    [TrainingPoolPredictedLabels, TrainingPoolPredictedPosterior]=test_with_MNN(Model,TrainingPoolData,UniqueLabels);
                    TrainClassificationAccuracy=find_classification_accuracy(TrainingPoolLabels,TrainingPoolPredictedLabels);
                    TrainError(ParameterValue,i)=1-(TrainClassificationAccuracy*0.01);
                    [TestPredictedLabels, TestPredictedPosterior]=test_with_MNN(Model,TestData,UniqueLabels);
                    CA(ParameterValue,i)=find_classification_accuracy(TestLabels,TestPredictedLabels);
					TPRates=find_true_positive_rate_per_class(TestLabels,TestPredictedLabels);
					TPR(ParameterValue,i)=TPRates(1,3);
					Precisions=find_precision_rate_per_class(TestLabels,TestPredictedLabels);
					PR(ParameterValue,i)=Precisions(1,5);
					[TXCoord1,TYCoord1,TThresholrray1,ROC] = perfcurve(TestLabels,TestPredictedLabels,PositiveClass);
					TROC(ParameterValue,i)=ROC;
					                  
                end
                Error=mean(TrainError(ParameterValue,:),2);
                H=NumberOfHiddenNodes;
                F=NumberOfFeatures;
                C=NumberOfClasses;
                T=2*H*(F+2)+2*C*(H+2); %NumberOfTransactions;
                W=(F+1)*H+(H+1)*C;
                %W=H*(F+1+C)+C =H+C/(F+1+C)=H;
                D=W;
                N=NumberOfTrainingExamples;
                switch(PaperTheoremNumber)
                    case 1
                        VC_Dimension=(T^2)*(D^2);
                    case 2
                        VC_Dimension=4*D*(T+2);
                    case 3
                        VC_Dimension=H*log(H);
                    case 4
                        VC_Dimension=W;
					case 5
						%VC_Dimension=W*log(W);
                end
                %         K1=1;
						VC_Dimension=ceil(VC_Dimension);
   
   switch N
       case 50
           K1=1;
       case 100
            K1=1;%10^(-10);
       case 200
            K1=1;%10^(-100);
       case 500
            K1=1;%0^(-200);
       case 1000
            K1=1;%10^(-300);
       case 2000
            K1=1;%10^(-300);
   end
              
                   
                
                mH_Matrix=zeros(2*N,VC_Dimension); % GrowthFunction
                mH_Matrix(:,1)=K1*ones(2*N,1);
                mH_Matrix(1,2:VC_Dimension)=K1*2*ones(1,VC_Dimension-1);
               % if N<=1000
                    for i=1:2*N-1
                        for j=1:VC_Dimension-1
                            mH_Matrix(i+1,j+1)= mH_Matrix(i,j+1)+mH_Matrix(i,j);
                            
                        end
%                         if N> 1000 & (i==1000 | i==2000 | i==2500)
%                             mH_Matrix(i+1,:)=(10^-300)*mH_Matrix(i+1,:);
%                             mH_Matrix(i+1:end,1)=(10^-300);
%                         end
                    end
%                 else
%                    for i=1:2*N-1
%                         for j=1:VC_Dimension-1
%                             
% 
%                        end
%                        if i>1000
%                         mH_Matrix(i,:)=(10^-300)*mH_Matrix(i,:);
%                        end
%                    end 
% 
%                 end
                mH=mH_Matrix(2*N,VC_Dimension);
                
                % %                 mH=0;
                % %                 for i=1:VC_Dimension+1
                % %                     mH=mH+nchoosek(2*N,i-1);
                % %      
                %mH=VC_Dimension;
                Delta=0.05;
                Epsilon=sqrt((8/N)*(log((4*(mH))/Delta)));
                K2=2; %% Contsant of Variation
                Lambda=K2*Epsilon;
                display(sprintf('H=%d,VC Dimension=%d,mH=%0.4e,Lambda=%5.4f',H,VC_Dimension,mH,Lambda));
                ErrorFunction=0:0.01:1;
                % LikelihoodLine=Lambda*exp(-(Lambda*ErrorFunction));
                LikelihoodLine=Lambda*exp(-(Lambda*ErrorFunction));
                % LikelihoodLine=exp(-(Lambda+ErrorFunction));
                % Posterior=exp(-(Lambda*ErrorFunction));
                
                hold on
                plot(ErrorFunction, LikelihoodLine);
                TagString=sprintf(TagStringType,NumberOfHiddenNodes);
                
                %Likelihood=exp(-(Lambda*Error));
                Likelihood=Lambda*exp(-(Lambda*Error));
                % plot(Error,Likelihood,'ro');
                % text(Error,Likelihood,TagString)
                AllLikelihood(ParameterValue,1)=Likelihood;
            end
            %legend('28','29','30','31','32','33','34','35','36','37','38','39','40');
            [MaxLikelihood MaxLikelihoodIndex]=max(AllLikelihood);
            AllPosterior=AllLikelihood.*AllPriors;
            [MaxPosterior MaxPosteriorIndex]=max(AllPosterior);
            
            BestParameter=InitialParameterValue+MaxPosteriorIndex-1;
            display(sprintf('Pool= %d Run = %d MaxCost = %d ,Best Parameter = %d',PoolNumber,RunNumber,MaxCost,BestParameter));
            DisplayStringType='H=%d , Accuracy=%2.2f, Precision=%0.2f, TPRate=%0.2f ,  AUC=%0.2f';
			
			ClassificationAccuracy(MaxCostNumber,RunNumber)=mean(CA(MaxPosteriorIndex,:),2);
            TPRate(MaxCostNumber,RunNumber)=mean(TPR(MaxPosteriorIndex,:),2);
            Precision(MaxCostNumber,RunNumber)=mean(PR(MaxPosteriorIndex,:),2);
            TAUC(MaxCostNumber,RunNumber)=mean(TROC(MaxPosteriorIndex,:),2);
			display(sprintf(DisplayStringType,BestParameter,ClassificationAccuracy(MaxCostNumber,RunNumber),Precision(MaxCostNumber,RunNumber),TPRate(MaxCostNumber,RunNumber),TAUC(MaxCostNumber,RunNumber)));
            
			PriorParameterIndex=find(ParameterRange==PriorParameter);
			ClassificationAccuracyPriorParameter(MaxCostNumber,RunNumber)=mean(CA(PriorParameterIndex,:),2);
			TPRatePriorParameter(MaxCostNumber,RunNumber)=mean(TPR(PriorParameterIndex,:),2);
			PrecisionPriorParameter(MaxCostNumber,RunNumber)=mean(PR(PriorParameterIndex,:),2);
			TAUCPriorParameter(MaxCostNumber,RunNumber)=mean(TROC(PriorParameterIndex,:),2);
            display(sprintf(DisplayStringType,PriorParameter,ClassificationAccuracyPriorParameter(MaxCostNumber,RunNumber),PrecisionPriorParameter(MaxCostNumber,RunNumber),TPRatePriorParameter(MaxCostNumber,RunNumber),TAUCPriorParameter(MaxCostNumber,RunNumber)));
       
            [BestTrainingAccuracy BestTrainingAccuracyIndex]=min(mean(TrainError,2));
			ClassificationAccuracyBestTrainingAccuracy(MaxCostNumber,RunNumber)=mean(CA(BestTrainingAccuracyIndex,:),2);;
			TPRateBestTrainingAccuracy(MaxCostNumber,RunNumber)=mean(TPR(BestTrainingAccuracyIndex,:),2);
			PrecisionBestTrainingAccuracy(MaxCostNumber,RunNumber)=mean(PR(BestTrainingAccuracyIndex,:),2);
			TAUCBestTrainingAccuracy(MaxCostNumber,RunNumber)=mean(TROC(BestTrainingAccuracyIndex,:),2);            
            display(sprintf(DisplayStringType,ParameterRange(BestTrainingAccuracyIndex,1),ClassificationAccuracyBestTrainingAccuracy(MaxCostNumber,RunNumber),PrecisionBestTrainingAccuracy(MaxCostNumber,RunNumber),TPRateBestTrainingAccuracy(MaxCostNumber,RunNumber),TAUCBestTrainingAccuracy(MaxCostNumber,RunNumber)));
          
            
            [BestAccuracy BestAccuracyIndex]=max(mean(CA,2));
			ClassificationAccuracyBestAccuracy(MaxCostNumber,RunNumber)=mean(CA(BestAccuracyIndex,:),2);;
			TPRateBestAccuracy(MaxCostNumber,RunNumber)=mean(TPR(BestAccuracyIndex,:),2);
			PrecisionBestAccuracy(MaxCostNumber,RunNumber)=mean(PR(BestAccuracyIndex,:),2);
			TAUCBestAccuracy(MaxCostNumber,RunNumber)=mean(TROC(BestAccuracyIndex,:),2);            
            display(sprintf(DisplayStringType,ParameterRange(BestAccuracyIndex,1),ClassificationAccuracyBestAccuracy(MaxCostNumber,RunNumber),PrecisionBestAccuracy(MaxCostNumber,RunNumber),TPRateBestAccuracy(MaxCostNumber,RunNumber),TAUCBestAccuracy(MaxCostNumber,RunNumber)));
        
            RawPosterior=horzcat(mean(TrainError,2),AllPosterior,AllLikelihood,AllPriors);
            
            
            hold off
            ImageFile=sprintf(ImageFileType,PoolNumber, RunNumber);
            saveas(gcf, strcat(OutputFolder,ImageFile),'pdf');
        end
        AllRawPosteriorPerRun=vertcat(AllRawPosterior,RawPosterior);
    end
    AllRawPosterior=vertcat(AllRawPosterior,AllRawPosteriorPerRun);
    csvwrite(strcat(OutputFolder,PosteriorAccuracyOutputFile),horzcat(MaxCostArray,ClassificationAccuracy,ClassificationAccuracyPriorParameter,ClassificationAccuracyBestTrainingAccuracy,ClassificationAccuracyBestAccuracy));
    csvwrite(strcat(OutputFolder,PosteriorTPRateOutputFile),horzcat(MaxCostArray,TPRate,TPRatePriorParameter,TPRateBestTrainingAccuracy,TPRateBestAccuracy));
    csvwrite(strcat(OutputFolder,PosteriorPrecisionOutputFile),horzcat(MaxCostArray,Precision,PrecisionPriorParameter,PrecisionBestTrainingAccuracy,PrecisionBestAccuracy));
    csvwrite(strcat(OutputFolder,PosteriorTAUCOutputFile),horzcat(MaxCostArray,TAUC,TAUCPriorParameter,TAUCBestTrainingAccuracy,TAUCBestAccuracy));
    csvwrite(strcat(OutputFolder,RawPosteriorFile),AllRawPosterior);
    
	
% 	csvwrite(strcat(OutputFolder,PriorAccuracyOutputFile),horzcat(MaxCostArray,ClassificationAccuracy,ClassificationAccuracyBestAccuracy));
% 	csvwrite(strcat(OutputFolder,PriorTPRateOutputFile),horzcat(MaxCostArray,TPRate,TPRateBestAccuracy));
% 	csvwrite(strcat(OutputFolder,PriorPrecisionOutputFile),horzcat(MaxCostArray,Precision,PrecisionBestAccuracy));
% 	csvwrite(strcat(OutputFolder,PriorTAUCOutputFile),horzcat(MaxCostArray,TAUC,TAUCBestAccuracy));
    diary off
end
