json2puml /parameterfile:spacex_parameter_launches.json /option:full /curlparameter:launch=next /formatdefinitionfiles
json2puml /parameterfile:spacex_parameter_launches.json /option:full /curlparameterfile:spacex_curl_parameter_launches_latest.json /formatdefinitionfiles /outputformat:svg,png,zip,filelist,log
json2puml /parameterfile:spacex_parameter_launches.json /option:full /curlparameter:launch=5eb87cd9ffd86e000604b32a

json2puml /parameterfile:spacex_parameter_launches.json /option:default /curlparameter:launch=next 
json2puml /parameterfile:spacex_parameter_launches.json /option:default /curlparameterfile:spacex_curl_parameter_launches_latest.json /outputformat:svg,png,zip,filelist,log
json2puml /parameterfile:spacex_parameter_launches.json /option:default /curlparameter:launch=5eb87cd9ffd86e000604b32a

json2puml /parameterfile:spacex_parameter_launches.json /option:compact /curlparameter:launch=next /formatdefinitionfiles
json2puml /parameterfile:spacex_parameter_launches.json /option:compact /curlparameterfile:spacex_curl_parameter_launches_latest.json /outputformat:svg,png,zip,filelist,log
json2puml /parameterfile:spacex_parameter_launches.json /option:compact /curlparameter:launch=5eb87cd9ffd86e000604b32a

json2puml /parameterfile:spacex_parameter_launches.json /option:launch-crew-rocket /curlparameter:launch=next /formatdefinitionfiles
json2puml /parameterfile:spacex_parameter_launches.json /option:launch-crew-rocket /curlparameterfile:spacex_curl_parameter_launches_latest.json /outputformat:svg,png,zip,filelist,log
json2puml /parameterfile:spacex_parameter_launches.json /option:launch-crew-rocket /curlparameter:launch=5eb87cd9ffd86e000604b32a
