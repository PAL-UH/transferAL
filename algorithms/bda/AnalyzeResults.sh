#!/bin/bash
#PBS -o AnalyzeResults.txt
#PBS -e AnalyzeResults.txt
#PBS -N AnalyzeResults
#PBS -l nodes=2:ppn=1
#PBS -l walltime=120:00:00
#PBS -m ae
#PBS -M kinjaldhargupta@gmail.com
cd /project/vilalta/kdg/ICML2017
module add matlab
matlab  -nodesktop -nosplash -nodisplay -nojvm < AnalyzeResults.m