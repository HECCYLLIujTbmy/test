FROM debian:latest

RUN apt-get update && apt-get install -y iproute2 python3

RUN mkdir /app
WORKDIR /app

COPY start_server.sh /app
RUN chmod +x /app/start_server.sh

CMD ["bash", "/app/start_server.sh"]
