#!/bin/bash
#PBS -o EstimateBestParameterPriorDistribution.txt
#PBS -e EstimateBestParameterPriorDistribution.txt
#PBS -N EstimateBestParameterPriorDistribution
#PBS -l nodes=2:ppn=1
#PBS -l walltime=120:00:00
#PBS -m ae
#PBS -M kinjaldhargupta@gmail.com
cd /project/vilalta/kdg/ICML2017
module add matlab
matlab  -nodesktop -nosplash -nodisplay -nojvm < EstimateBestParameterPriorDistribution.m