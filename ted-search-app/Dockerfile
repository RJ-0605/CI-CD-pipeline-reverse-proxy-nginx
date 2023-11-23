FROM maven:3.6.3-openjdk-8 AS builder



COPY . /app

WORKDIR /app

RUN mvn verify


COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]

