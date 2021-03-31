# FreeSurfer Cortex AutoQC
Region specific automatic quality assurance for MRI derived cortical segmentations

We make use of a large database of FreeSurfer processed 12000 T1 volumes to train a machine learning model to accurately label each cortical region as a "pass" or "fail". This tool we facilitate a more anatomically accurate large-scale multi-site research. This tool provides the flexibility to predict labels for left and right lobes per region of interest(ROI) or combine it bilaterally per ROI resulting in a single label.

All available cortical measures were extracted for each of the parcellated regions from Desikan-Killiany atlas. This set comprises of regional measures including volume (grayvol), surface area (surfavg), thickness (thickstd and thickavg), number of vertices (numvert), and curvature measures like folding index (foldind), intrinsic curvature index (curvind), integrated rectified Gaussian curvature (gauscurv), mean curvature index (meancurv) and global measures including intracranial volume (ICV), left and right average thickness (LThickness, RThickness), left and right surface area average (LSurfavg, RSurfavg).

Light Gradient Boosted Network with Random Forest base estimator was trained to make the predictions. This repository provides you with the training script if anyone wishes to train on other data, pre-trained models for testing and a script to predict the labels directly. 

## Requirements:
* python >= 3.7.9
* jupyterlab >= 1.1.4
* scikit-learn >= 0.23.2
* pandas >= 1.1.3
* lightgbm >= 2.3.0

## How to use the tool:
* Clone the github directory using: git clone https://github.com/USC-IGC/FreeSurfer_Cortex_AutoQC.git
* Install all the packages required to run this tool mentioned in requirements.txt file.
* The "run.sh" file would extract features and feed it to the model and predict the labels for each ROI.
* For testing the tool:
  * In scripts folder, open run.sh file and make the following changes:
    1. Add the path for python on line 7
    2. Add the FS directory path on line 10
    3. Add the path for subject list text file on line 13
    4. Add the output directory path on line 16
    5. If using FSv7.1.1, comment line 26 and uncomment line 29 
  * Run the bash file ---> sh run.sh

## References:
ISBI link:
