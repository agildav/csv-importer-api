# README

Requirements:

1. Install Docker and Docker Compose.

Steps to build:

1. At the root of the project, create the `.env` file with values as in `.env.example` and execute `docker-compose -f "docker-compose.yml" up -d --build`
2. Then, execute `docker attach $(docker-compose ps -q web)`
3. Inside container, execute `rake setup:reset`
4. Start application with `hivemind`

Application will be running with specified PORT in `.env` (3000 by default).
