from __future__ import print_function
from clustergrammer_widget import *
#from antibiotic_res import *
from ipywidgets import interact, interactive, fixed, interact_manual
import matplotlib as mpl
import matplotlib.pyplot as plt
import pandas as pd
import glob
import qgrid
import numpy as np


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

def interactive_table_abricate():
    dense_df = create_abricate_presence_absence_gene_table()
    return qgrid.show_grid(dense_df, show_toolbar=True)

def interactive_table_srst2():
    dense_df = create_srst2_presence_absence_gene_table()
    return qgrid.show_grid(dense_df, show_toolbar=True)


def interactive_map_abricate():
    dense_df = create_abricate_presence_absence_gene_table()
    # initialize network object
    net = Network(clustergrammer_widget)
    # load dataframe
    net.load_df(dense_df)
    # cluster using default parameters
    net.cluster(enrichrgram=False)
    # make the visualization
    return net.widget()

def interactive_map_srst2():
    dense_df = create_abricate_presence_absence_gene_table()
    # initialize network object
    net = Network(clustergrammer_widget)
    # load dataframe
    net.load_df(dense_df)
    # cluster using default parameters
    net.cluster(enrichrgram=False)
    # make the visualization
    return net.widget()

def create_abricate_presence_absence_gene_table():
    # Creat concatenated tsv file 
    combined_df = concat_abricate_files('*tab')
    # Remove columns keeping only 'gene' and 'filename'
    # Drop any na values
    combined_df.dropna(axis=0, inplace=True)
    #new_combined_df.head()
    g = combined_df.groupby('GENE')
    ug = list(set(combined_df['GENE']))

    a = []
    for GENE in ug:
        gene_group = g.get_group(GENE)
        if len(gene_group['filename'])>1:
            a.append(gene_group[['filename', 'GENE']])

    from collections import defaultdict
    gene_filenames = defaultdict(list)

    for line in a:
        gene_filenames[line['GENE'].iloc[0]].extend(line['filename'].tolist())
    
    filenames = set()
    for files in gene_filenames.values():
        filenames.update(files)

    filenames = list(filenames)
    data = {}
    for gene, files in gene_filenames.items():
        data[gene] = [file in files for file in filenames]
    dense_df = pd.DataFrame.from_dict(data, orient='index', columns=filenames)
    return dense_df

def create_srst2_presence_absence_gene_table():
    # Creat concatenated tsv file 
    combined_df = concat_srst2_txt('srst2/*results.txt')
    # Remove columns keeping only 'gene' and 'filename'
    # Drop any na values
    combined_df.dropna(axis=0, subset=['gene'], inplace=True)
    g = combined_df.groupby('gene')
    ug = list(set(combined_df['gene']))

    a = []
    for gene in ug:
        gene_group = g.get_group(gene)
        if len(gene_group['filename'])>1:
            a.append(gene_group[['filename', 'gene']])

    from collections import defaultdict
    gene_filenames = defaultdict(list)

    for line in a:
        gene_filenames[line['gene'].iloc[0]].extend(line['filename'].tolist())
    
    filenames = set()
    for files in gene_filenames.values():
        filenames.update(files)

    filenames = list(filenames)
    data = {}
    for gene, files in gene_filenames.items():
        data[gene] = [file in files for file in filenames]
    dense_df = pd.DataFrame.from_dict(data, orient='index', columns=filenames)
    return dense_df

