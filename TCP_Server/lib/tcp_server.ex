defmodule TcpServer do
  @moduledoc """
  Provides TCP server functions.

  ## Examples

      iex> TcpServer.start_server()
      {:ok, #PID<0.111.0>}

  """

  @doc """
  Starts the server, returns {:ok, #PID<0.111.0>}
  """
  def start_server do
    pid =
      spawn_link(fn ->
        {:ok, lSocket} = :gen_tcp.listen(port(), [:binary, {:active, false}])
        spawn(fn -> acceptState(lSocket) end)
        :timer.sleep(:infinity)
      end)

    {:ok, pid}
  end

  @doc """
  turns a listening socket to accept socket.
  """
  def acceptState(lSocket) do
    {:ok, aSocket} = :gen_tcp.accept(lSocket)
    spawn(fn -> acceptState(lSocket) end)
    handler(aSocket)
  end

  @doc """
  handles messages sent to accepting socket
  """
  def handler(aSocket) do
    :inet.setopts(aSocket, [{:active, :once}])

    receive do
#      {:tcp, aSocket, "quit"} ->
#        :gen_tcp.close(aSocket)
#
#      {:tcp, aSocket, <<"value=", x::binary>>} ->
#        val = String.to_integer(x)
#        result = val * val
#        :gen_tcp.send(aSocket, "Value squared is: #{result}")
#        handler(aSocket)

      {:tcp, aSocket, binaryMsg} ->
        IO.inspect byte_size(binaryMsg)
        IO.inspect(binaryMsg)
        handler(aSocket)
    end
  end

  @doc """
  defines a socket port
  """
  defp port do
    9000
  end
end
