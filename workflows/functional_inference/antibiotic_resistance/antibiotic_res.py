import matplotlib as mpl
import matplotlib.pyplot as plt
import pandas as pd
import glob
import qgrid
import numpy as np
from clustergrammer_widget import *

def concat_abricate_files(filenames):
    x = glob.glob(filenames)
    list_of_dfs = [pd.read_table(filename, header = 1) for filename in x]
    for dataframe, filename in zip(list_of_dfs, x):
        dataframe['filename'] = filename
    combined_df = pd.concat(list_of_dfs, ignore_index=True)
    return combined_df

def calc_total_genes_abricate():
    combined_df = concat_abricate_files('*tab')
    x = combined_df.groupby('filename').GENE.count()
    y = x.to_frame()
    bingo = y.sort_values('GENE',ascending=False)
    bingo
    return bingo

def calculate_unique_genes_abricate():
    combined_df = concat_abricate_files("*tab")
    x = combined_df.groupby('filename').GENE.nunique()
    y = x.to_frame()
    bingo = y.sort_values('GENE',ascending=False)
    bingo
    return bingo

def calc_total_genes_srst2():
    combined_df = concat_srst2_txt('srst2/*results.txt')
    x = combined_df.groupby('filename').gene.count()
    y = x.to_frame()
    bingo = y.sort_values('gene',ascending=False)
    bingo
    return bingo

def concat_srst2_txt(filenames):
    x = glob.glob(filenames)
    list_of_dfs = [pd.read_table(filename, header = 0) for filename in x]
    for dataframe, filename in zip(list_of_dfs, x):
        dataframe['filename'] = filename
    combined_df = pd.concat(list_of_dfs, ignore_index=True, sort=True)
    return combined_df

def calculate_unique_genes_srst2():
    combined_df = concat_srst2_txt('srst2/*results.txt')
    x = combined_df.groupby('filename').gene.nunique()
    y = x.to_frame()
    bingo = y.sort_values('gene',ascending=False)
    bingo
    return bingo

def interactive_table(filename):
    return qgrid.show_grid(filename, show_toolbar=True)

def interactive_map(filename):
    # initialize network object
    net = Network(clustergrammer_widget)
    # load dataframe
    net.load_df(filename)
    # cluster using default parameters
    net.cluster(enrichrgram=False)
    # make the visualization
    return net.widget()
