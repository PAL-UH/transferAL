#!/bin/bash
#PBS -o VC3_Pool5_output2.txt
#PBS -e VC3_Pool5_error2.txt
#PBS -N VC3_Pool5
#PBS -l nodes=2:ppn=1
#PBS -l walltime=120:00:00
#PBS -m ae
#PBS -M kinjaldhargupta@gmail.com
cd /project/vilalta/kdg/ICML2017
module add matlab
matlab  -nodesktop -nosplash -nodisplay -nojvm < EstimateBestParameterPosterior_VC3_Pool5.m