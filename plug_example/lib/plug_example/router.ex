defmodule PlugExample.Router do
  use Plug.Router

  if Mix.env == :dev do
    use Plug.Debugger, otp_app: :plug_example
  end

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison,
  )

  plug(:dispatch)

  get "/boom" do
    conn |> send_resp(200, "noboom")
    # raise "boom"
  end

  get "/" do
    conn
    |> IO.inspect
    |> send_resp(200, "Welcome")
  end

  post "/" do
    conn
    |> IO.inspect
    |> send_resp(200, "Welcome")
  end

  match _ do
    conn
    |> send_resp(404, "oops")
  end
end
