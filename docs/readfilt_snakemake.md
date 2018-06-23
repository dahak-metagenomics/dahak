# Read Filtering: Snakemake Rules

Two kinds of rules: **build rules** and **target file rules**.

**Build rules** are high-level rules that only require input files and
do not perform any actions. These rules trigger other rules
and often start the entire workflow.

**Target file rules** are rules where the user asks for a specific
output file name, and snakemake determines the rule that produces
that file, as well as the rules it depends on.

## Read Filtering: Build Rules

There are three basic build rules for read filtering:

```plain
fetch
    
    Fetch read data from OSF. Uses full reads.
    
pre_trim
    
    Pre-trimming quality assessment of read data. Uses full reads.
    
post_trim
    
    Post-trimming quality assessment of read data. Uses full reads.
```

Additionally, there are build rules for the subsampled
reads, which make the workflows faster for testing:

10% subsampled reads:

```plain
fetch_subset10
    
    Fetch read data from OSF. Uses 10% subsampled reads.
    
pre_trim_subset10
    
    Pre-trimming quality assessment of read data. Uses 10% subsampled reads.
    
post_trim_subset10
    
    Post-trimming quality assessment of read data. Uses 10% subsampled reads.
```

25% subsampled reads:

```plain
fetch_subset25
    
    Fetch read data from OSF. Uses 25% subsampled reads.
    
pre_trim_subset25
    
    Pre-trimming quality assessment of read data. Uses 25% subsampled reads.
    
post_trim_subset25
    
    Post-trimming quality assessment of read data. Uses 25% subsampled reads.
```    

50% subsampled reads:

```plain
fetch_subset50
    
    Fetch read data from OSF. Uses 50% subsampled reads.
    
pre_trim_subset50
    
    Pre-trimming quality assessment of read data. Uses 50% subsampled reads.
    
post_trim_subset50
    
    Post-trimming quality assessment of read data. Uses 50% subsampled reads.
```

