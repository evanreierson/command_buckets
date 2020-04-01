defmodule CommandBuckets.WriteSide.Router do
  use Commanded.Commands.Router
  alias CommandBuckets.WriteSide.BucketAggregate

  dispatch(BucketAggregate.CreateBucket,
    to: BucketAggregate,
    identity: :bucket_name
  )
end
