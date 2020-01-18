defmodule PlugExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    children = [
      {Plug.Cowboy,
       scheme: :https,
       plug: PlugExample.Router,
       options: [
         port: 8080,
         keyfile: "priv/keys/localhost.key",
         certfile: "priv/keys/localhost.cert",
         otp_app: :plug_example,
       ]}
      # Starts a worker by calling: PlugExample.Worker.start_link(arg)
      # {PlugExample.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PlugExample.Supervisor]
    Logger.info("Starting application")
    Supervisor.start_link(children, opts)
  end
end
