FROM tomcat:8.5.72-jdk8-openjdk-buster


# Define the Maven version and download URL
ENV MAVEN_VERSION 3.8.4
ENV MAVEN_DOWNLOAD_URL https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.8.4/apache-maven-3.8.4-bin.tar.gz

# Create a directory for Maven installation
RUN mkdir -p /usr/share/maven

# Download and extract Maven
RUN curl -fsSL $MAVEN_DOWNLOAD_URL -o /tmp/apache-maven.tar.gz \
    && tar -xzvf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
    && rm -f /tmp/apache-maven.tar.gz

# Set environment variables for Maven
ENV MAVEN_HOME /usr/share/maven
ENV PATH $MAVEN_HOME/bin:$PATH


WORKDIR /app

COPY ./pom.xml ./pom.xml

COPY ./src ./src

RUN mvn package

RUN rm -rf /usr/local/tomcat/webapps/*

RUN cp /app/target/addressbook.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
