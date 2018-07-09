# Assembly: Snakemake Rules

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

(Also see [Assembly: Snakemake Configuration](assembly_params.md).)

List of available build rules in the assembly workflow:

```
assembly_workflow_metaspades
    
    Build rule: trigger the metaspades assembly step.
    
assembly_workflow_megahit
    
    Build rule: trigger the megahit assembly step.
    
assembly_workflow_all
    
    Build rule: trigger the assembly step with all assemblers.
    
```

List of other target rules in the assembly workflow
(these should not be called directly):

```
assembly_metaspades
    
    Perform read assembly of trimmed reads using metaspades.
    
assembly_megahit
    
    Perform read assembly of trimmed reads using megahit.
    
assembly_statistics_quast
    
    Compute assembly statistics with quast
    
assembly_statistics_multiqc
    
    Compute assembly statistics with multiqc
```

