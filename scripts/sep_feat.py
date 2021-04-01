import numpy as np
import pandas as pd
import argparse

import warnings
warnings.filterwarnings('ignore')

#Argument parser
parser = argparse.ArgumentParser()
parser.add_argument("--maindir", help="""Path to the tool's main directory""")
parser.add_argument("--out", help="""Path to the output directory""")
args = parser.parse_args()


df_full = pd.read_csv(args.out + '/aparc.csv')
features = pd.read_csv(args.maindir + '/features.csv')
feat_cols = list(features.Features) + ['SubjID']
df = df_full[feat_cols]

# Get all left hemisphere measures in a list as features 
list_L = list(df.columns[df.columns.to_series().str.contains('L_')])
list_R = list(df.columns[df.columns.to_series().str.contains('R_')])

# New feature names
list_feat_new = [s[2:] for s in list_L]
list_feat_new.extend(['Thickness', 'SurfArea', 'ICV', 'SubjID'])

# Additional features
list_L.extend(['LThickness', 'LSurfArea', 'ICV', 'SubjID'])
list_R.extend(['RThickness', 'RSurfArea', 'ICV', 'SubjID'])

# Generate new dataframes for left and right hemispheres
df_L = df[list_L]
df_L.set_axis(list_feat_new, axis=1, inplace=True)

df_R = df[list_R]
df_R.set_axis(list_feat_new, axis=1, inplace=True)

# New data frame with double data
df_new = pd.concat([df_L, df_R], ignore_index=True)

# Save dataframe
df_new.to_csv(args.maindir + '/aparc_sep.csv', index=False)
