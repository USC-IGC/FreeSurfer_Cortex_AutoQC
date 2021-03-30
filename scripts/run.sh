#!/bin/bash
#$ -S /bin/bash



# Path to Python with required libraries
py_path=./Anaconda3/bin/python

#FS directory
dirFS=./data

#Path to the subject list
dirSub=./data/subj.txt

#Output directory where the QC predictions are saved
dirO=./results/

#Python Script path
script=./scripts/
cd ${script}




#For FS version 5.3, use,
sh aparc_metrics.sh -o ${dirO}/aparc.csv -f ${dirFS} -s $(cat ${dirSub})

#For FS version 7.1.1, use,
# sh aparc_metrics_FS7.sh -o ${dirO}/aparc.csv -f ${dirFS} -s $(cat ${dirSub})  

#For generating QC predictions
${py_path} qc_test.py --inp ${dirO}/aparc.csv --out ${dirO}/QC_predictions.csv




