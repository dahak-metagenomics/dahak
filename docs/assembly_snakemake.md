# Assembly: Snakemake Rules

Two kinds of rules: **build rules** and **target file rules**.

**Build rules** are high-level rules that only require input files and
do not perform any actions. These rules trigger other rules
and often start the entire workflow.

**Target file rules** are rules where the user asks for a specific
output file name, and snakemake determines the rule that produces
that file, as well as the rules it depends on.


TODO: Finish
