FROM ubuntu:latest

# Set working directory
WORKDIR /app

# Install dependencies and Java 21
RUN apt-get update && \
    apt-get install -y wget gnupg fontconfig openjdk-21-jre && \
    java -version

# Add Jenkins repository key
RUN wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add Jenkins repository
RUN echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
    > /etc/apt/sources.list.d/jenkins.list

# Install Jenkins
RUN apt-get update && \
    apt-get install -y jenkins

# Expose Jenkins default port
EXPOSE 8080

# Start Jenkins
CMD ["java", "-jar", "/usr/share/java/jenkins.war"]