sudo docker run -d --rm --name json2pumlservice --mount type=bind,source=/home/jens/docker/logs,target=/json2puml/logs --mount type=bind,source=/home/jens/docker/output,target=/json2puml/output -p 9090:9090 json2pumlservice
#sudo docker run  json2puml
