import pandas as pd
import seaborn as sns
import numpy
from matplotlib import pyplot
from sklearn import manifold
import os.path
import matplotlib.pyplot as plt
import numpy as np
import scipy as sp

def load_sourmash_csv(filename):
    global r
    r = pd.read_csv(filename)
    return r 

def sort_by_similarity(filename, saved_file):
    df = pd.read_csv(filename)
    x = dict([(i,os.path.basename(i)) for i in df.columns])
    dfnew = df.rename(index=str, columns=x)
    #Reset index to columns 
    dfnew ['']= dfnew.columns
    output = dfnew.set_index('')
    stacked_output = output.stack()
    stacked_sorted_output = pd.DataFrame(stacked_output, columns=['Jaccard_similarity']).sort_values('Jaccard_similarity', ascending=False)
    stacked_sorted_output.to_csv('saved_file')
    stacked_sorted_output
    return stacked_sorted_output

def create_tsne(filename, save_fig):
    m = numpy.loadtxt(open(filename),delimiter=",", skiprows=1)
    from sklearn.manifold import TSNE
    from sklearn.preprocessing import StandardScaler
    data_std = StandardScaler().fit_transform(m)

    from sklearn.decomposition import PCA
    pca = PCA(n_components=8, svd_solver='full')
    data_pca = pca.fit_transform(data_std)

    t = TSNE(n_components=2, perplexity=5).fit_transform(data_pca)

    df = pd.DataFrame(t)
    df.columns=['t1','t2']

    return pyplot.scatter(df.t1, df.t2)
    pyplot.savefig(save_fig)

def create_cluster_map(filename, save_name, title):
    df = pd.read_csv(filename) 
    x = dict([(i,os.path.basename(i)) for i in df.columns])
    dfnew = df.rename(index=str, columns=x)

    #Reset index to columns 
    dfnew ['']= dfnew.columns
    output = dfnew.set_index('')

    #Create cluster map
    cmap = sns.cubehelix_palette(8, start=2, rot=0, dark=0, light=.95, reverse=True, as_cmap=True)
    o = sns.clustermap(output, col_cluster=True, row_cluster=True, linewidths=.5, figsize=(10, 10), cmap=cmap)
    o.ax_heatmap.set_yticklabels(o.ax_heatmap.get_yticklabels(), rotation=0)
    sns.set_context('paper')
    o.fig.suptitle(title) 
    return o.savefig(save_name)
    
    
#df_csv = pd.read_csv("SRR606249.pe.trim2and30_reads_and_contigs_comparison.k51.csv")

def create_mds_plot(filename, save_fig):
    m = numpy.loadtxt(open(filename),delimiter=",", skiprows=1)
    from sklearn.manifold import mds
    from sklearn.preprocessing import StandardScaler
    data_std = StandardScaler().fit_transform(m)

    from sklearn.decomposition import PCA
    pca = PCA(n_components=8, svd_solver='full')
    data_pca = pca.fit_transform(data_std)

    mds = manifold.MDS(n_components=2, max_iter=3000, eps=1e-9,
                   dissimilarity="euclidean", n_jobs=1).fit_transform(m)



    df = pd.DataFrame(mds)
    df.columns=['t1','t2']

    #df['labels'] = df_csv.columns

    return pyplot.scatter(df.t1, df.t2)
