# Use Maven + OpenJDK 17 base image
FROM maven:3.8.4-openjdk-17-slim AS builder

# Set working directory in the image
WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code and build the application
COPY src ./src
RUN mvn clean package -DskipTests

# Use the JRE image with OpenJDK 17 to run the app
FROM eclipse-temurin:17-jre-alpine

# Set working directory for the app
WORKDIR /opt/app

# Copy the built artifact from the builder stage
COPY --from=builder /app/target/spring-boot-web.jar app.jar

# Command to run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
