From tomcat:8.5.72-jdk8-openjdk-buster

Maintainer "Mudassir"

Run apt-get update

Run apt-get install vim -y

Run wget https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.8.4/apache-maven-3.8.4-bin.tar.gz -P /tmp

Run tar xf /tmp/apache-maven-*.tar.gz -C /opt

Run  ln -s /opt/apache-maven-3.8.4 /opt/maven

Workdir /app

Copy ./pom.xml ./pom.xml

Copy ./src ./src

Run mvn package

Run run -rf /usr/local/tomcat/webapps/*

Run cp /app/target/addressbookpractice.war /usr/local/tomcat/webapps/

Expose 8080

Cmd ["catalina.sh", "run"]

