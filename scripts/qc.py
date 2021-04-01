import numpy as np
import pandas as pd
import argparse
import pickle

from sklearn.impute import SimpleImputer
from sklearn.preprocessing import normalize, MinMaxScaler
import lightgbm as lgb

import warnings
warnings.filterwarnings('ignore')



#Argument parser
parser = argparse.ArgumentParser()
parser.add_argument("--inp", help="""Input path with aparc measures csv file""")
parser.add_argument("--out", help="""output path with name of the file """)
args = parser.parse_args()


#All ROI's for QC
roi_list = ["temporalpole", "frontalpole", "bankssts", "superiortemporal", "middletemporal", 
               "precentral", "postcentral", "supramarginal", "superiorparietal", "precuneus", "cuneus", 
               "pericalcarine", "lingual", "superiorfrontal", "rostralanteriorcingulate", "caudalanteriorcingulate",
               "posteriorcingulate", "isthmuscingulate", "medialorbitofrontal", "inferiortemporal", "lateraloccipital",
               "inferiorparietal", "caudalmiddlefrontal", "rostralmiddlefrontal", "lateralorbitofrontal",
               "parsorbitalis", "parstriangularis", "parsopercularis", "insula", "transversetemporal", "entorhinal",
               "paracentral", "fusiform", "parahippocampal"]


#Read data
df_test = pd.read_csv(args.inp)

#Get Subject list
subject_list = df_test["SubjID"]

#Create new dataframe for predictions
df_prediction = pd.DataFrame()
df_prediction["SubjID"] = subject_list

#Selected columns in dataframe
columns = list(pd.read_csv('./features.csv').Features)
X_test = df_test[columns]

#Mean Imputation
X_test = SimpleImputer().fit(X_test).transform(X_test)

#Normalize
X_test = normalize(X_test)

#Scaling
minmax = pickle.load(open('./models/minmax.sav', 'rb'))
X_test = minmax.transform(X_test)

#Generate dataframe from array
X_test = pd.DataFrame(X_test)
X_test.columns = columns
    

for selected_roi in roi_list:
    #Load model and predict labels 
    file = './models/model_' + str(selected_roi) + '.sav'
    loaded_model = pickle.load(open(file, 'rb'))
    result = loaded_model.predict(X_test)
    df_prediction[str(selected_roi)] = result
    print("Done with " + selected_roi)
    

#Save the predictions in csv file
df_prediction.to_csv(args.out, index=False)

