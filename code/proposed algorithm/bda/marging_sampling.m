function [Margins]=marging_sampling(Predicted_Test_Posterior)
Number_Of_Target_Examples=length(Predicted_Test_Posterior(:,1));
MaximumProbability=(max(Predicted_Test_Posterior'))';
SecondMaximumProbability=zeros(size(MaximumProbability));
for Row=1:Number_Of_Target_Examples
    IndicesOfNotMaximumProbability=find(Predicted_Test_Posterior(Row,:)<MaximumProbability(Row,1))
    SecondMaximumProbability(Row,1)=max(Predicted_Test_Posterior(Row,IndicesOfNotMaximumProbability));
    display(max(Predicted_Test_Posterior(Row,IndicesOfNotMaximumProbability)))
end
Margins=MaximumProbability-SecondMaximumProbability;
