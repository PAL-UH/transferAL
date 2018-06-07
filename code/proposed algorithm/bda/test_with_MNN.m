function [Labels,Posterior]=test_with_MNN(Model,Data,UniqueLabels)

 outputs = Model(Data');
 Posterior=outputs';
 Number_Of_Samples=length(Data(:,1));
 [Number_Of_Examples, Number_Of_Classes]=size(outputs');
 %Number_Of_Classes=2;
 Classes=UniqueLabels;
 Labels=zeros(Number_Of_Samples,1);
 %DataClasses=[0 1];
 for SampleNumber=1:Number_Of_Samples
     ExamplePosterior=Posterior(SampleNumber,:)';
     [Value, Index]=max(ExamplePosterior);
     Labels(SampleNumber,1)=Classes(Index,1);
 end