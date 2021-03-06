defmodule KVServer do
  @moduledoc """
  Documentation for KVServer.
  """

  require Logger

  def accept_tcp(port) do
    # The options below mean:
    #
    # 1. `:binary` - receives data as binaries (instead of lists)
    # 2. `packet: :line` - receives data line by line
    # 3. `active: false` - blocks on ':gen_tcp.recv/2` until data is
    #    available
    # 4. `reuseaddr: true` - allows us to reuse the address if the
    #    listener crashes

    {:ok, socket} =
      :gen_tcp.listen(
        port, [
          :binary,
          packet: :line,
          active: false,
          reuseaddr: true,
        ]
      )
    Logger.info("Accepting connections on port #{port}")
    tcp_loop_acceptor(socket)
  end

  defp tcp_loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(
      KVServer.TaskSupervisor, fn -> serve_tcp(client) end
    )
    :ok = :gen_tcp.controlling_process(client, pid)
    tcp_loop_acceptor(socket)
  end

  defp serve_tcp(socket) do
    socket
    |> tcp_read_line()
    |> IO.inspect
    |> tcp_write_line(socket)

    serve_tcp(socket)
  end

  defp tcp_read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  def tcp_write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
