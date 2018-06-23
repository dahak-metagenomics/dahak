# Taxonomic Classification: Snakemake Rules

Two kinds of rules: **build rules** and **target file rules**.

**Build rules** are high-level rules that only require input files and
do not perform any actions. These rules trigger other rules
and often start the entire workflow.

**Target file rules** are rules where the user asks for a specific
output file name, and snakemake determines the rule that produces
that file, as well as the rules it depends on.

## Taxonomic Classification: Build Rules

The first step in the taxonomic classification workflow
is to download and unpack sourmash SBT databases:

```
genbank
    
    Download the assembled SBT associated with a given database,
    and for a given k value.

sbts
    
    Unpack the assembled SBTs associated with a given database
    and for a given k value.
```

Next, a build rule to dowload and unpack kaiju databases:

```
usekaiju
    
    Download and unpack kaiju database.
```

Merge the paired-end read files:
    
```
merge
    
    Merge paired-end read files and compute signatures.
```

There is also an equivalent for the 10% subsampled reads:
    
```
merge_subset10
    
    Merge paired-end read files and compute signatures.
    Only uses the 10% subsampled reads.
```

Do everything needed to perform a kaiju run:

```
runkaiju
    
    Run the kaiju program.
    
runkaiju_subset10
    
    Run the kaiju program.
```

Run the krona visualization tool to visualize
the kaiju results:

```
runkrona
    
    Run the krona visualization tool.
    
runkrona_subset10
    
    Run the krona visualization tool.
```


