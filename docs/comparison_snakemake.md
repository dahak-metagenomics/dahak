# Comparison: Snakemake Rules

List of available build rules in the comparison workflow:

```
comparison_workflow_reads
    
    Build rule: run sourmash compare on all reads
    
comparison_workflow_assembly
    
    Build rule: run sourmash compare on all assemblies
    
comparison_workflow_reads_assembly
    
    Build rule: run sourmash compare on all reads and assemblies together
```  

List of other target rules in the comparison workflow
(these should not need to be called directly):

```
compute_read_signatures
    
    Compute read signatures from trimmed data using sourmash.
    
compute_assembly_signatures
    
    Compute assembly signatures using sourmash.
    
compare_read_signatures
    
    Compare signatures of specified reads.
    
compare_assembly_signatures
    
    Compare different assembly signatures using sourmash.
    
compare_read_assembly_signatures
    
    Compare signatures of reads and assembly files.
```  

