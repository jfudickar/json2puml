# Base Container
FROM json2pumlbase

# Copy files into the container
COPY src/json2puml/ /json2puml/

# Configuration Definition of Json2Puml
ENV Json2PumlConfigurationFile=/json2puml/configuration/json2pumlconfiguration.json 

# Command to be started, additional parameters can be defined via command line	
ENTRYPOINT ["./json2puml/bin/json2puml", "-debug"]
