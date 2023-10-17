# Base Container
FROM eclipse-temurin:latest

# Install additional packages
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get install -y plantuml && \
    apt-get clean && \
    rm -f -r /var/lib/apt/lists/*
   
# overwrite planuml file with updated version
ARG plantumlversion=1.2023.11
RUN wget -O /usr/share/plantuml/plantuml.jar https://github.com/plantuml/plantuml/releases/download/v${plantumlversion}/plantuml.jar
