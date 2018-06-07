function [PoolData, PoolDataIndices]=dataPool(TargetRawData,NumberOfInstances)

PoolDataIndices = randsample(size(TargetRawData,1), NumberOfInstances);
PoolData = TargetRawData(PoolDataIndices, :);

end

