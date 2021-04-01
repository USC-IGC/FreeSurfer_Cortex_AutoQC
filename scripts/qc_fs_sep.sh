#!/bin/bash
#$ -S /bin/bash

# Python with required libraries
py_path=./Anaconda3/bin/python

#FS directory
dirFS=./cross_section/sc_cross_section

#Path to the subject list
dirSub=./data/subj.txt

#Output directory where the QC predictions are saved
dirO=./results

############ DO NOT CHANGE THIS PATH #############
#Python Script path 
script=./scripts
cd ${script}
################################################## 




#For FS version 5.3, use,
sh aparc_metrics.sh -o ${dirO}/aparc.csv -f ${dirFS} -s $(cat ${dirSub})

#For FS version 7.1.1, use,
# sh aparc_metrics_FS7.sh -o ${dirO}/aparc.csv -f ${dirFS} -s $(cat ${dirSub})  

#For separating features into L and R
${py_path} sep_feat.py 

#For generating QC predictions
${py_path} qc_sep.py --inp ${dirO}/aparc_sep.csv --out ${dirO}/QC_sep_predictions.csv

