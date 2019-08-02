require Logger
import Shoeboat.AddressUtil

defmodule Shoeboat.ProxyDelegate do

  def start_proxy_loop(downstream_socket, upstream_socket, upstream_socket2) do
    {:ok, downstream_peer} = :inet.peername(downstream_socket)
    {:ok, local} = :inet.sockname(downstream_socket)
    Logger.info "Incoming connection from #{ipfmt(downstream_peer)} > #{ipfmt(local)}"
    loop_pid = spawn_link(fn ->
      receive do :ready -> :ok end
      :ok = :inet.setopts(downstream_socket, [:binary, packet: 0, active: true, nodelay: true])
      downstream = %{socket: downstream_socket, amount: 0}
      upstream = %{socket: upstream_socket, amount: 0}

      upstream2 = %{socket: upstream_socket2, amount: 0}
      proxy_loop(downstream, upstream, upstream2)
    end)
    {:ok, loop_pid}
  end

  defp proxy_loop(downstream, upstream, upstream2) do
    receive do
      msg -> handle_receive(msg, downstream, upstream, upstream2)
    end
  end

  defp handle_receive({:tcp, socket, data}, ds = %{socket: socket}, us, us2) do
    IO.inspect data
    IO.inspect byte_size(data)

    {:ok, count} = relay_to(us.socket, data)
    {:ok, count} = relay_to(us2.socket, data)
    proxy_loop(%{ds | amount: ds.amount + count}, us, us2)
  end

  defp handle_receive({:tcp_error, socket, reason}, %{socket: socket}, us, us2) do
    Logger.info "tcp_error downstream #{reason}"
    relay_to(us.socket, <<>>)
  end

  defp handle_receive({:tcp_closed, socket}, ds = %{socket: socket}, us, us2) do
    Logger.info "Downstream socket closed"
    relay_to(us.socket, <<>>)
    :gen_tcp.close(us.socket)
    :gen_tcp.close(us2.socket)
    Logger.info "Total bytes >#{ds.amount} <#{us.amount}"
  end

  defp handle_receive({:tcp, socket, data}, ds, us = %{socket: socket}, us2) do
    IO.inspect data
    {:ok, count} = relay_to(ds.socket, data)
    proxy_loop(ds, %{us | amount: us.amount + count}, us2)
  end

  defp handle_receive({:tcp, socket, data}, ds, us = %{socket: socket}, us2) do
    IO.inspect data
    {:ok, count} = relay_to(ds.socket, data)
    proxy_loop(ds, %{us | amount: us.amount + count}, us2)
  end

  defp handle_receive({:tcp_error, socket, reason}, ds, %{socket: socket}, us2) do
    Logger.info "tcp_error upstream #{reason}"
    relay_to(ds.socket, <<>>)
  end

  defp handle_receive({:tcp_closed, socket}, ds, us = %{socket: socket}, us2) do
    Logger.info "Upstream socket closed"
    relay_to(ds.socket, <<>>)
    :gen_tcp.close(ds.socket)
    Logger.info "Total bytes >#{ds.amount} <#{us.amount}"
  end

  defp handle_receive(msg, ds, us, us2) do
    Logger.error "Invalid message:"
    IO.inspect msg
    proxy_loop(ds, us, us2)
  end

  def relay_to(socket, data) do
    :ok = :gen_tcp.send(socket, data)
    {:ok, byte_size(data)}
  end
end
