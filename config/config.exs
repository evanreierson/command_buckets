use Mix.Config

config :logger, :console,
  level: :debug,
  format: "[$level] $message\n"

config :command_buckets, event_stores: [CommandBuckets.WriteSide.EventStore]

config :command_buckets, CommandBuckets.WriteSide.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "command_buckets_eventstore_dev",
  hostname: "localhost",
  pool_size: 10
