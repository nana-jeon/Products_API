#Stage 1: Build the JAR
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

#Copy Gradle wrapper and build files
COPY gradlew .
COPY gradle gradle
COPY build.gradle settings.gradle ./

#Copy source code
COPY src src

#Build the application JAR
RUN ./gradlew bootJar --no-daemon -x test

#Stage 2: Run the JAR
FROM eclipse-temurin:21-jdk
WORKDIR /app

#Copy JAR from build stage
COPY --from=build /app/build/libs/*.jar app.jar

#Expose port
EXPOSE 8080

#Run the app
ENTRYPOINT ["java","-jar","app.jar"]