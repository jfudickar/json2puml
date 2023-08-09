curl -X GET http://localhost:8080/api/heartbeat  -v -o result\heartbeat_result.txt
curl -X GET http://localhost:8080/api/serviceinformation  -v -o result\serviceinformation_result.json
curl -X GET http://localhost:8080/api/inputlistfile  -v -o result\inputlistfile_result.json
curl -X GET http://localhost:8080/api/definitionfile  -v -o result\definitionfile_result.json
curl -X GET http://localhost:8080/api/errormessages  -v -o result\erromessages_result.json