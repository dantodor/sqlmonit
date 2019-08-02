# TcpServer

**TODO: Add client**

## Installation

Clone the repo. in the project folder run: ```mix compile```

To start the application in elixir interactive shell run: ```iex -S mix```


## Starting The Server

To start the server run:

```elixir
iex> TcpServer.start_server()
{:ok, #PID<0.111.0>} # The PID may differ
```

# Client Side

In another application (in this case another Elixir Interactive Shell) you can create a socket and start communicating with the server.

## :gen_tcp.connect/3

:gen_tcp.connect/3 takes the IP address of the server (localhost, in this case), the Port to communicate to, and options 

```elixir
iex> {:ok, socket} = :gen_tcp.connect({127,0,0,1}, 9000, [:binary, {:active, true}])
{:ok, #Port<0.1284>} ## The PORT may differ
```

## :gen_tcp.send/2

:gen_tcp.send/2 takes the Socket as the first argument and message (Binary, in this case).

```elixir
iex> :gen_tcp.send(socket, "Hello")
:ok
# You Use flush/0 to see the messages in the mailbox of the current iex process
iex> flush()
{:tcp, #Port<0.1284>, "Unhandled Message: Hello"}
:ok
```

There are some other available message types that are being handled by the server:

```elixir
iex> :gen_tcp.send(socket, "value=10")
:ok
iex> flush()
{:tcp, #Port<0.1284>, "Value squared is: 100"}
:ok
```

To close the server run:

```elixir
iex> :gen_tcp.send(socket, "quit")
:ok
iex> flush()
{:tcp_closed, #Port<0.1284>}
iex> :gen_tcp.send(socket, "Are You Alive?")
{:error, :closed}
```
