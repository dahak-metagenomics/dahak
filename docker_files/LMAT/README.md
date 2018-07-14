Required Files:
To run LMAT 1.2.4 certain source code files had to be edited and are required for this container:
get_db.sh
frequency_counter.cpp

build docker image
'''
docker build --build-arg db_name=04072014 --build-arg marker_db_arg=<db_name> -t lmat .
'''
Where db_arg is the name of the database specified in the LMAT documentation (ex: kML+Human.v4-14.20.g10.db)

run docker image
'''
docker run -v /home/directory:/tmp -it lmat <LMAT command>
'''
Where /home/directory is the directory on the host machine and <LMAT command> is the LMAT script to run (run_rl.sh, etc.)