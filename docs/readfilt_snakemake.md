# Read Filtering: Snakemake Rules

As mentioned on the [Running Workflows](running_workflows.md) page,
Snakemake can be called with two different types of targets:
build rules (which trigger all rules associated with a workflow)
and target files (which trigger any rules required to produce the
requested file).

The [Running Workflows](running_workflows.md) page also shows
how to call Snakemake and ask for a particular target:

```
$ snakemake [FLAGS] <target>
```

You can replace `<target>` with any of the build rules below.
Note that you should also provide a Snakemake configuration file
that specifies which samples, quality values, k values, etc. to use
when running the workflow.

(Also see [Read Filtering: Snakemake Configuration](readfilt_config.md).)

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
(these should not be called directly):

```
read_filtering_pretrim_workflow
    
    Build rule: trigger the read filtering workflow
    
read_filtering_posttrim_workflow
    
    Build rule: trigger the read filtering workflow
    
```

