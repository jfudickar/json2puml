sudo docker run --rm --name json2puml --mount type=bind,source=/home/jens/docker/logs,target=/json2puml/logs --mount type=bind,source=/home/jens/docker/output,target=/json2puml/output json2puml -option:full -parameterfile:/json2puml/samples/jsonplaceholder/placeholdercurlunixparameter.json

