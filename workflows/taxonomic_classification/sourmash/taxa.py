from __future__ import print_function
import seaborn as sns
import pandas as pd
import os
import glob
import numpy as np
from clustergrammer_widget import *
from ipywidgets import interact, interactive, fixed, interact_manual
import matplotlib as mpl
import matplotlib.pyplot as plt
import qgrid

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

def create_sourmash_presence_absence_table(filenames):
    # Creat concatenated tsv file 
    combined_df = concat_sourmash_csv(filenames)
    g = combined_df.groupby('name')
    ug = list(set(combined_df['name']))

    a = []
    for name in ug:
        gene_group = g.get_group(name)
        if len(gene_group['filename'])>1:
            a.append(gene_group[['filename', 'name']])

    from collections import defaultdict
    gene_filenames = defaultdict(list)

    for line in a:
       gene_filenames[line['name'].iloc[0]].extend(line['filename'].tolist())
    
    filenames = set()
    for files in gene_filenames.values():
        filenames.update(files)

    filenames = list(filenames)
    data = {}
    for name, files in gene_filenames.items():
        data[name] = [file in files for file in filenames]
    dense_df = pd.DataFrame.from_dict(data, orient='index', columns=filenames)
    return dense_df

def interactive_table_abricate(filenames):
    dense_df = create_sourmash_presence_absence_table(filenames)
    return qgrid.show_grid(dense_df, show_toolbar=True)

def interactive_map_sourmash(filenames):
    dense_df = create_sourmash_presence_absence_table(filenames)
    # initialize network object
    net = Network(clustergrammer_widget)
    # load dataframe
    net.load_df(dense_df)
    # cluster using default parameters
    net.cluster(enrichrgram=False)
    # make the visualization
    return net.widget()