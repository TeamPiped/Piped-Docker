#!/bin/sh

echo "hibernate.connection.url: jdbc:postgresql://${POSTGRES_HOST}:5432/piped" > /app/config.properties
echo "hibernate.connection.username: ${POSTGRES_USER}" >> /app/config.properties
echo "hibernate.connection.password: ${POSTGRES_PASSWORD}" >> /app/config.properties
echo "hibernate.connection.driver_class: org.postgresql.Driver" >> /app/config.properties
echo "hibernate.dialect: org.hibernate.dialect.PostgreSQLDialect" >> /app/config.properties

exec java -server -Xmx1G -XX:+UnlockExperimentalVMOptions -XX:+OptimizeStringConcat -XX:+UseStringDeduplication -XX:+UseCompressedOops -XX:+UseNUMA -XX:+UseG1GC -Xshare:on -jar /app/piped.jar
