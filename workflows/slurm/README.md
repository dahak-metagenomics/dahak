# Running Dahak with SLURM

## Read Filtering

Let's begin with the read filtering workflow.
To run this on a cluster, we should provide a
configuration file for the cluster that specifies
default and custom values for memory, threads, 
job size, and other SLURM parameters.

The basic format for the JSON configuration file is:

```
{
    "__default__" :
    {
        "key" : "value"
    },
    "rule_name_1" :
    {
        "key" : "value"
    },
    ...
}
```




