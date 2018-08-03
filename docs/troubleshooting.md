# Troubleshooting

## Errors 

### Snakemake error: Directory cannot be locked

If you see an error like this when running Snakemake:

```
Building DAG of jobs…
Error: Directory cannot be locked. Please make sure that no other Snakemake process is trying to create the same files in the following directory:/home/user/dahak_2018/dahak/workflows
If you are sure that no other instances of snakemake are running on this directory, the remaining lock was likely caused by a kill signal or a power loss. It can be removed with the --unlock argument.
```

you can try the following:

* Remove locks with `snakemake --unlock`
* Remove or rename `data/` directory
* Run `export SINGULARITY_BINDPATH="data:/data"`
* Re-run the Snakemake command



