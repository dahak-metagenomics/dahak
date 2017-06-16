# Assembly with MEGAHIT

## install

```
sudo apt-get -y update && \
sudo apt-get -y install trimmomatic fastqc python-pip \
   samtools zlib1g-dev ncurses-dev python-dev python3.5-dev python3.5-venv make \
    libc6-dev g++ zlib1g-dev bioperl \
    libdatetime-perl libxml-simple-perl libdigest-md5-perl

```

and install a few things:

```
python3.5 -m venv ~/py3
. ~/py3/bin/activate
pip install -U pip
pip install -U Cython
pip install -U jupyter jupyter_client ipython pandas matplotlib scipy scikit-learn khmer

pip install khmer==2.1.1
```

## Download data set

```
mkdir ~/work
cd ~/work
curl -O -L https://s3.amazonaws.com/public.ged.msu.edu/ecoli_ref-5m.fastq.gz
```

Split reads:
```
split-paired-reads.py ecoli_ref-5m.fastq.gz -1 ecoli-1.fq.gz -2 ecoli-2.fq.gz --gzip
```

## Run Trimmomatic

This is "light" trimming as per MacManes paper - trim only Bs from fastqc sequence.

Download the adapters:
```
curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-semi-2015-03-04/TruSeq2-PE.fa
```

Trim:

```
TrimmomaticPE ecoli-1.fq.gz \
                 ecoli-2.fq.gz \
        ecoli-1.qc.fq.gz s1_se \
        ecoli-2.qc.fq.gz s2_se \
        ILLUMINACLIP:TruSeq2-PE.fa:2:40:15 \
        LEADING:2 TRAILING:2 \
        SLIDINGWINDOW:4:2 \
        MINLEN:25
```

## Build MEGAHIT

```
cd ~/
git clone https://github.com/voutcn/megahit.git
cd megahit
make -j 6
```

## Run MEGAHIT

```
cd ~/work
~/megahit/megahit -1 ecoli-1.qc.fq.gz -2 ecoli-2.qc.fq.gz -f -o ecoli

cp ecoli/final.contigs.fa ecoli-assembly.fa
```

## Measuring the assembly

```
cd ~/
git clone https://github.com/ablab/quast.git -b release_4.2
export PYTHONPATH=$(pwd)/quast/libs/
```

```
cd ~/work
python2.7 ~/quast/quast.py ecoli-assembly.fa -o ecoli_report
```

## Annotating short read data set

Install prokka and dependencies:

```
sudo PERL_MM_USE_DEFAULT=1 PERL_EXTUTILS_AUTOINSTALL="--defaultdeps" perl -MCPAN -e 'install "XML::Simple"'
```

```
cd ~/
wget http://www.vicbioinformatics.com/prokka-1.11.tar.gz
tar -xvzf prokka-1.11.tar.gz
```

```
export PATH=$PATH:$HOME/prokka-1.11/bin
prokka --setupdb
```

```
cd ~/work
prokka ecoli-assembly.fa --outdir prokka_annotation --prefix metagG --metagenome
```