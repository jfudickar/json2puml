# Base Container
FROM eclipse-temurin:latest

# Install additional packages
RUN apt-get update && \
    apt-get install -y graphviz && \
    apt-get install -y curl && \
    apt-get install -y plantuml && \
    apt-get clean;
   
