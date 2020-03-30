defmodule CommandBuckets.WriteSide.EventStore do
  use EventStore, otp_app: :command_buckets
end
