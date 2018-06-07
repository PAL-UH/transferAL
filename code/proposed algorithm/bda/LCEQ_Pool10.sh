#!/bin/bash
#PBS -o LCEQ_Pool10_output.txt
#PBS -e LCEQ_Pool10_error.txt
#PBS -N LCEQ_Pool10
#PBS -l nodes=2:ppn=1
#PBS -l walltime=120:00:00
#PBS -m ae
#PBS -M kinjaldhargupta@gmail.com
cd /project/vilalta/kdg/ICML2017
module add matlab
matlab  -nodesktop -nosplash -nodisplay -nojvm < LCEQ_Pool10.m