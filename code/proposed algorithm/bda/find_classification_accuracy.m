function [Classification_Accuracy]=find_classification_accuracy(Actual_Labels,Predicted_Labels)

Correctly_Classified_Instances_Indices=find(Actual_Labels==Predicted_Labels);
%Number_Of_Correctly_Classified_Most_Confident_Instances=size(Correctly_Classified_Instances_Indices,1);
Number_Of_Correctly_Classified_Instances=length(Correctly_Classified_Instances_Indices);
Total_Number_Of_Examples=length(Actual_Labels(:,1));
%Classification_Accuracy=100*(Number_Of_Correctly_Classified_Most_Confident_Instances/Total_Number_Of_Examples);
Classification_Accuracy=100*(Number_Of_Correctly_Classified_Instances/Total_Number_Of_Examples);