```
mix phx.new hello
```

The run the Postgres docker container: `run-postgres.sh`a

```bash
#!/usr/bin/env bash
docker run --name phoenix-postgres -e POSTGRES_PASSWORD=postgres postgres
```

