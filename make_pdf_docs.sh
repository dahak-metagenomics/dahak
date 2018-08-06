#!/bin/bash
set -e

# you should
# pip install mkdocs-pandoc
# or 
# pip install -r requirements.txt
# first
mkdocs2pandoc --help > /dev/null

# Combine all markdown into a single (kinda) markdown
mkdocs2pandoc > dahak_docs.pd

# Make that into a single PDF
pandoc --toc -f markdown+grid_tables+table_captions -o dahak_docs.pdf dahak_docs.pd

