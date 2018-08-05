build docker image
'''
docker build -t kraken --build-arg db_type=standard .
'''
Where db_type is the standard database or one of the genomic databases as shown on the krakenhll documentation

run docker image
'''
docker run -v /home/directory:/tmp -it kraken ./krakenhll
'''
Where /home/directory is the directory on the host machine.