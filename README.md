# TTO4emy



# 1. Dockerfile
```sh
FROM debian:latest - указывает базовый образ, который будет использован для создания контейнера. В данном случае используется последний доступный образ Debian.

RUN apt-get update && apt-get install -y iproute2 python3 - обновляет списки пакетов в базовом образе и устанавливает пакеты iproute2 и python3.

RUN mkdir /app - создает директорию /app внутри контейнера. 
WORKDIR /app - устанавливает рабочую директорию в /app. Все последующие команды будут выполняться относительно этой директории.

COPY start_server.sh /app - копирует файл start_server.sh из контекста сборки (текущая директория) внутрь контейнера в директорию /app.

RUN chmod +x /app/start_server.sh - устанавливает права на выполнение для файла start_server.sh внутри контейнера.

CMD ["bash", "/app/start_server.sh"] - задает команду, которая будет выполняться при запуске контейнера. В данном случае, будет запускаться скрипт start_server.sh с использованием оболочки bash.
```

# 2. Start_server.sh
```sh
#!/bin/bash - Эта строка указывает, что скрипт будет выполняться с использованием оболочки bash.

python3 -m http.server & - Запускает простой сервер Python с помощью модуля http.server. Знак амперсанда (&) используется для запуска сервера в фоновом режиме, чтобы скрипт мог продолжить выполнение следующих команд.
/bin/ss -tulpn > /app/result.txt - Выполняет команду /bin/ss -tulpn, которая выводит список открытых портов. Знак > перенаправляет вывод этой команды в файл /app/result.txt. То есть результаты команды будут записаны в файл result.txt в директории /app внутри контейнера.

Таким образом, этот скрипт запускает сервер Python и выводит список открытых портов в файл result.txt.

```

# 3. docker_build.yml

```sh
name: Build and Run Docker image - Название workflow, которое будет отображаться в GitHub Actions.



on:
  push:
    branches:
      - main - Указывает, что workflow будет запускаться при каждом пуше в ветку main.

jobs:
  build:
    runs-on: ubuntu-latest - Начало определения задачи build, которая будет выполняться на операционной системе Ubuntu.

steps:
  - name: Checkout code
    uses: actions/checkout@v2 - Шаг, который проверяет код репозитория и клонирует его в рабочую директорию workflow.

  - name: Build Docker image
    run: docker build -t debian-iproute2 . - Шаг, который собирает Docker-образ с именем debian-iproute2 на основе Dockerfile в текущей директории.

  - name: Run Docker container
    run: docker run --name server-container debian-iproute2 - Шаг, который запускает контейнер с именем server-container на основе собранного Docker-образа debian-iproute2.

  - name: Copy result.txt from Docker container to artifact
    run: docker cp server-container:/app/result.txt result.txt - Шаг, который копирует файл result.txt из запущенного Docker-контейнера server-container в файл result.txt в рабочей директории workflow.

  - name: Create artifact
    run: tar -czvf artifact.tar.gz result.txt - Шаг, который создает артефакт artifact.tar.gz, архивируя файл result.txt в файле артефакта.

  - name: Upload artifact
    uses: actions/upload-artifact@v2
    with:
      name: artifact
      path: artifact.tar.gz - Шаг, который загружает артефакт artifact.tar.gz в GitHub Actions в качестве результата выполнения workflow.

Таким образом, этот workflow собирает Docker-образ, запускает контейнер, копирует файл результатов из контейнера, создает артефакт из файла результатов и загружает артефакт в GitHub Actions.
```

# 4. Вывод
```sh
Netid State  Recv-Q Send-Q Local Address:Port Peer Address:PortProcess
tcp   LISTEN 0      5            0.0.0.0:8000      0.0.0.0:*          
```
