#!/bin/bash
#$ -S /bin/bash



# Path to Python with required libraries
py_path=./Anaconda3/bin/python

#FS directory
dirFS=./data

#Path to the subject list
dirSub=./data/subj.txt

#Directory where the aparc measures are saved
dirI=./data

#Output directory where the QC predictions are saved
dirO=./

#Python Script path
script=./scripts/
cd ${script}




#For FS version 7.1.1, use,
# sh aparc_metrics_FS7.sh -o ${dirI}/aparc.csv -f ${dirFS} -s $(cat ${dirI}/subj_smart_7p1.txt)  

#For FS version 5.3, use,
sh aparc_metrics.sh -o ${dirI}/aparc.csv -f ${dirFS} -s $(cat ${dirSub})

#For generating QC predictions
${py_path} qc_test.py --inp ${dirI}/aparc.csv --out ${dirO}/QC_predictions.csv




