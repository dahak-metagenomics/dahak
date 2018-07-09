# Assembly: Snakemake Rules

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
(these should not need to be called directly):

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

