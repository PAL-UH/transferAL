#!/bin/bash
#PBS -o ParameterPriorEstimation.txt
#PBS -e ParameterPriorEstimation.txt
#PBS -N ParameterPriorEstimation
#PBS -l nodes=2:ppn=1
#PBS -l walltime=120:00:00
#PBS -m ae
#PBS -M kinjaldhargupta@gmail.com
cd /project/vilalta/kdg/ICML2017
module add matlab
matlab  -nodesktop -nosplash -nodisplay -nojvm < ParameterPriorEstimation.m