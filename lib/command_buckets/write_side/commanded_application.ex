defmodule CommandBuckets.WriteSide.CommandedApplication do
  use Commanded.Application,
    otp_app: :command_buckets,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: CommandBuckets.WriteSide.EventStore
    ]

  router(CommandBuckets.WriteSide.Router)
end
