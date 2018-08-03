import seaborn as sns
import pandas as pd
import os
import glob

def concat_sourmash_csv(filenames):
    x = glob.glob(filenames)
    list_of_dfs = [pd.read_csv(filename, header = 0) for filename in x]
    for dataframe, filename in zip(list_of_dfs, x):
        dataframe['filename'] = filename
    combined_df = pd.concat(list_of_dfs, ignore_index=True)
    return combined_df

def plot_otu_presence_absence(filenames):
    combined_df = concat_sourmash_csv(filenames)
    plot = combined_df['name'].value_counts().plot(kind="bar", figsize = (60,8))
    return plot 