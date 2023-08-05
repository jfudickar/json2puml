# Base Container
FROM json2pumlbase

# Copy files into the container
COPY src/json2puml/bin/ /json2puml/bin/
COPY src/json2puml/configuration/ /json2puml/configuration/
COPY src/json2puml/definition/ /json2puml/definition/
COPY src/json2puml/inputlist/ /json2puml/inputlist/
COPY src/json2puml/samples/ /json2puml/samples/

RUN mkdir /json2puml/logs && \
  mkdir /json2puml/output  
    
# Configuration Definition of Json2Puml
ENV Json2PumlConfigurationFile=/json2puml/configuration/json2pumlconfiguration.json 

CMD  ["./json2puml/bin/json2pumlservice", "-debug"]
