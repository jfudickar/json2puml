curl -X GET http://192.168.178.241:8080/api/heartbeat  -v -o result\heartbeat_result.txt
curl -X GET http://192.168.178.241:8080/api/serviceinformation  -v -o result\serviceinformation_result_vm.json
curl -X GET http://192.168.178.241:8080/api/inputlistfile  -v -o result\inputlistfile_result_vm.json
curl -X GET http://192.168.178.241:8080/api/definitionfile  -v -o result\definitionfile_result_vm.json
curl -X GET http://192.168.178.241:8080/api/errormessages  -v -o result\erromessages_result_vm.json