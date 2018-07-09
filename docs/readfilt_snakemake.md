# Read Filtering: Snakemake Rules

List of available build rules in the read filtering workflow:

```
download_reads
    
    Fetch user-requested files from OSF containing reads that will be used in
    the read filtering process.

    Note that this defines wildcard-based download rules, rather than
    downloading all files all at once, to keep things flexible and fast.
    
download_read_adapters
    
    Download FASTA read adapaters (TruSeq2-PE sequencer by default).
    
pre_trimming_quality_assessment
    
    Perform a pre-trimming quality check of the reads from the sequencer.
    
post_trimming_quality_assessment
    
    Perform a post-trimming quality check 
    of the reads from the sequencer.
    
interleave_reads
    
    Interleave paired-end reads using khmer.
    The trim quality comes from the filename.
    
quality_trimming
    
    Trim reads from the sequencer by dropping low-quality reads.
```

List of other target rules in the read filtering workflow
(these should not need to be called directly):

```
read_filtering_pretrim_workflow
    
    Build rule: trigger the read filtering workflow
    
read_filtering_posttrim_workflow
    
    Build rule: trigger the read filtering workflow
    
```

