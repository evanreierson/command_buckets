defmodule CommandBuckets.Application do
  use Application

  def start(_type, _args) do
    children = [
      CommandBuckets.WriteSide.CommandedApplication
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
