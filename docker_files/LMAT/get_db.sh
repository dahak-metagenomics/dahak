#!/bin/sh

dtype=db
outdir=.
name=kML.v4-14.20.g10.db
usage="
    $0: LMAT database auto-download utility
    Usage: $0 --dtype=<inputs|db> --name=<db_name> --outdir=<Destination path for database/input files>

    option list:
    --dtype=$dtype (default) (either inputs for runtime inputs or db for database)
    --outdir=$outdir (default) (place downloaded data in this directory
    --name=$name (default) (name of database or runtime inputs data)

    example usage:

    # download taxonomy data and auxillary files
    $0 --dtype=inputs --name=04072014 --outdir=.

    # download marker database
    $0 --dtype=db --name=kML.v4-14.20.g10.db --outdir=.
      

    Current databases:
    kML.v4-14.20.g10.db  - Microbial marker database (small database for fast microbial profiling
    kML+Human.v4-14.20.g10.db  - Microbial marker database with explicit human read tagging (small database for fast microbial profiling)
    lmat-4-14.20mer.db  - Fullsized database for extensive read binning
    lmat.genes.7-14.db  - Gene database for gene name binning
    lmat-world-region  - Database for binning human reads by world region

    Current runtime input files:
    04072014 - use for all databases except world-region
    world-region - use for world-region 

    Legacy names for older databases
    <kML-18mer-large|kML-18mer-medium|kML-18mer-small|gene-20mer|kFull-20mer|inputs> [Destination path for database/input files]
    runtime_inputs (for runtime inputs data)

    Please see LMAT documentation for more details.
"

if test $# = 0; then
   echo "${usage}"
   exit 1
fi

while test -n "${1}"; do
   opt=${1}
   optarg=`expr "x$opt" : 'x[^=]*=\(.*\)'`

   case $opt in
   --dtype=*)
      dtype=$optarg;;
   --outdir=*)
      outdir=$optarg;;
   --name=*)
      name=$optarg;;
   *)
      echo "Unrecognized argument [$opt]"
      echo "${usage}"
      exit 1
   esac
   shift
done

if ! test -d $outdir; then
    echo "$outdir not found, creating directory"
    mkdir $outdir
    if ! test -d $outdir; then
	echo Could not create directory for database download.  Please ensure that the parent directory name is correct.
	exit 1
    fi
fi

if [ $name == "kML-18mer-medium" ]
then
name=kML.18mer.16bit
for suffix in a b c d e
do
    wget -q -O - ftp://gdo-bioinformatics.ucllnl.org/pub/lmat/18merML/$name.db.$suffix.gz | gunzip -c >> $outdir/$name.db
echo "Part $suffix out of 5 done"
done
echo Download complete.  When running LMAT set --db_file=$outdir/$name.db

elif [ $name == "kML-18mer-small" ]
then
name=kML.18mer.16bit.reduced
echo downloading...
wget -q -O -  ftp://gdo-bioinformatics.ucllnl.org/pub/lmat/18merML/$name.db.gz | gunzip -c > $outdir/$name.db
echo Download complete.  When running LMAT set --db_file=$outdir/$name.db

elif [ $name == "gene-20mer" ]
then
name=gene.20mer
for suffix in a b c d e
do
wget -q -O -  ftp://gdo-bioinformatics.ucllnl.org/pub/lmat/GeneDB/$name.db.a$suffix.gz | gunzip -c >> $outdir/$name.db
echo "Part $suffix out of 5 done"
done
echo Download complete.  When running LMAT set --db_file=$outdir/$name.db
elif [ $name == "kFull-20mer" ]
then

   mx=19
   for suffix in `seq 0 $mx` ; do
      file=kFull.20mer.g1000.part.$suffix.lzma
      echo "Retrieve $file"
      wget -q -O - ftp://gdo-bioinformatics.ucllnl.org/pub/lmat/20merFullDB/$file | unlzma -c >> $outdir/m9.20mer.16bit.g1000.db
      echo part $suffix out of $mx done
      size=`stat $outdir/m9.20mer.16bit.g1000.db | grep Size | awk '{print $2}'`
      if [ $size -gt 400000000000 ] ; then
         truncate -s 400GB $outdir/m9.20mer.16bit.g1000.db
         break
      fi
   done
   echo Download complete.  When running LMAT set --db_file=$outdir/m9.20mer.16bit.g1000.db 

elif [ $name == "kML-18mer-large" ]
then
for suffix in `seq 0 7` ; do
wget -q -O - ftp://gdo-bioinformatics.ucllnl.org/pub/lmat/18merML/kML.18mer.no_prune.16bit.part.$suffix.lzma | unlzma -c >> $outdir/kML.18mer.no_prune.16bit.db
echo part $(( 1 + $suffix )) out of 8 done
done
echo Download complete.  When running LMAT set --db_file=$outdir/kML.18mer.no_prune.16bit.db 

elif [ $dtype == "inputs" ]
then
echo "Downloading LMAT runtime-input files to $outdir"
input_file='04072014'
wget -q -O - ftp://gdo-bioinformatics.ucllnl.org/lmat/runtime_inputs/$input_file.tgz | tar -C $outdir/ -zxvf - 
abspath=`readlink -f $outdir`
echo "For LMAT to run correctly, please set the LMAT_DIR environment variable to $abspath"

else
   ## Now assume naming convention to avoid updating this file for evry new database
   wget -q -O $outdir/dbinfo ftp://gdo-bioinformatics.ucllnl.org/lmat/$name/dbinfo 
   mx=`head -1 $outdir/dbinfo | cut -f1`
   cmprs=`head -1 $outdir/dbinfo | cut -f2`
   mbytes=`head -1 $outdir/dbinfo | cut -f3`
   rm -f $outdir/dbinfo
   if [ $mx == -1 ] ; then
      file=$name.$cmprs
      if [ $cmprs == "lzma" ] ; then
         wget -q -O - ftp://gdo-bioinformatics.ucllnl.org/lmat/$name/$file | unlzma > $outdir/$name
      elif [ $cmprs == "gz" ] ; then 
         wget -q -O - ftp://gdo-bioinformatics.ucllnl.org/lmat/$name/$file | gunzip > $outdir/$name
      else 
         echo "Unrecognized compression, failed to download"
      fi
   else 
      for suffix in `seq 0 $mx` ; do
         file=$name.$suffix.$cmprs
         echo "Retrieve $file"
         if [ $cmprs == "lzma" ] ; then
            wget -q -O - ftp://gdo-bioinformatics.ucllnl.org/lmat/$name/$file | unlzma -c >> $outdir/$name
         elif [ $cmprs == "gz" ] ; then 
            wget -q -O - ftp://gdo-bioinformatics.ucllnl.org/lmat/$name/$file | gunzip -c >> $outdir/$name
         else 
            echo "Unrecognized compression, failed to download"
         fi
         echo part $suffix out of $mx done
         size=`stat $outdir/$name | grep Size | awk '{print $2}'`
         if [ $size -gt $mbytes ] ; then
            truncate -s $mbytes $outdir/$name
            break
         fi
      done
      echo Download complete.  When running LMAT set --db_file=$outdir/$name
   fi

fi

echo "Download complete"
