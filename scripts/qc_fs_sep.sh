#!/bin/bash
#$ -S /bin/bash

# Full path to python with required libraries
py_path=./Anaconda3/bin/python

#Full path to FS directory
dirFS=./cross_section/sc_cross_section

#Full Path to the subject list
dirSub=./data/subj.txt

#Full path tooutput directory where the QC predictions are saved
dirO=./results

#Path to tool's main directory path 
maindir=./FreeSurfer_Cortex_AutoQC
cd ${maindir}/scripts
################################################## 




#For FS version 5.3, use,
sh aparc_metrics.sh -o ${dirO}/aparc.csv -f ${dirFS} -s $(cat ${dirSub})

#For FS version 7.1.1, use,
# sh aparc_metrics_FS7.sh -o ${dirO}/aparc.csv -f ${dirFS} -s $(cat ${dirSub})  

#For separating features into L and R
${py_path} sep_feat.py --maindir ${maindir}

#For generating QC predictions
${py_path} qc_sep.py --maindir ${maindir} --inp ${dirO}/aparc_sep.csv --out ${dirO}/QC_sep_predictions.csv

