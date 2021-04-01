#!/bin/bash
#$ -S /bin/bash

#Full path to Python with required libraries
py_path=./Anaconda3/bin/python

#Full paath to FS directory
dirFS=./cross_section/sc_cross_section

#Full Path to the subject list
dirSub=./subj.txt

#Full path to output directory where the QC predictions are saved
dirO=./results
mkdir -p ${dirO}

#Full Path to tool's main directory
maindir=./FreeSurfer_Cortex_AutoQC
cd ${maindir}/scripts
################################################## 




#For FS version 5.3, use,
sh aparc_metrics.sh -o ${dirO}/aparc.csv -f ${dirFS} -s $(cat ${dirSub})

#For FS version 7.1.1, use,
# sh aparc_metrics_FS7.sh -o ${dirI}/aparc.csv -f ${dirFS} -s $(cat ${dirSub})

#For generating QC predictions
${py_path} qc.py --maindir ${maindir} --inp ${dirO}/aparc.csv --out ${dirO}/QC_predictions.csv
