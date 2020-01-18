use Mix.Config

config :kv_server, Blog.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "kv_server_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"
