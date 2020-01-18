#!/usr/bin/env bash
docker run -p 127.0.0.1:5432:5432 --name phoenix-postgres -e POSTGRES_PASSWORD=postgres postgres
