defmodule Shoeboat.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    {opts, _argv, _errors} = OptionParser.parse(
      System.argv,
      strict: [listen: :integer, host: :string]
    )

    children = [
      worker(Shoeboat.TCPProxy, [
        opts[:listen] || 4040,
        opts[:host] || "127.0.0.1:1433",
        opts[:host2] || "127.0.0.1:9000",
        2,
        :tcp_proxy_clients])
    ]

    opts = [strategy: :one_for_one, name: Shoeboat.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
