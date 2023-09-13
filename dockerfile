From tomcat:8.5.72-jdk8-openjdk-buster

LABEL key="Mudassir"

RUN apt-get update

RUN apt-get install vim -y

RUN wget https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.8.4/apache-maven-3.8.4-bin.tar.gz -P /tmp

RUN tar xf /tmp/apache-maven-*.tar.gz -C /opt

RUN  ln -s /opt/apache-maven-3.8.4 /opt/maven

WORKDIR /app

COPY ./pom.xml ./pom.xml

COPY ./src ./src

RUN mvn package

RUN run -rf /usr/local/tomcat/webapps/*

RUN cp /app/target/addressbookpractice.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalishna.", "run"]

