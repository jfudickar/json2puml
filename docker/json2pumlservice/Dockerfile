# Base Container
FROM json2pumlbase

# Copy files into the container
COPY src/json2puml/ /json2puml/
    
# Configuration Definition of Json2Puml
ENV Json2PumlConfigurationFile=/json2puml/configuration/json2pumlconfiguration.json 

CMD  ["./json2puml/bin/json2pumlservice", "-debug"]
