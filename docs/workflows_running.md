# Running Workflows

You can run a workflow by asking
snakemake to create a target file,
or by using a conveniently-named 
build rule that will trigger all of the
other rules in a given workflow.

## Target File

## Build Rule

A build rule is just a conveniently-named
rule that will require the last file of 
a workflow as an input, and do nothing.
This rule can be called to trigger the 
entire workflow to be run.

For example, if the outcome of an analysis
is `krona_report_XYZ123.html`, and it is the result 
of a long sequence of tasks based on raw data
in `XYZ123.fq.gz` and various input parameters, 
we can define a rule that will require
`krona_XYZ123.html` as an input (and do
nothing), which triggers the HTML report
to be built, which triggers the filtering
and extraction to be done, which triggers
the downloading of the raw data, etc.

```
rule make_krona_reports: 
    input:
        expand('krona_report_{prefix}.html', prefix=["XYZ123","ABC246"])
```

