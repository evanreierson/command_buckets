defmodule CommandBuckets.WriteSide.BucketAggregate do
  alias __MODULE__

  ### Bucket creation command and event
  defmodule CreateBucket do
    @enforce_keys [:bucket_name]
    defstruct [:bucket_name]
  end

  defmodule BucketCreated do
    @derive Jason.Encoder
    @enforce_keys [:bucket_name]
    defstruct [:bucket_name]
  end

  ### Bucket aggregate
  @enforce_keys [:bucket_name, :bucket_contents]
  defstruct [:bucket_name, :bucket_contents]

  # Matches when an aggregate with the bucket name does not already exist
  # and the provided bucket name is a string
  def execute(
        %BucketAggregate{bucket_name: nil},
        %CreateBucket{bucket_name: bucket_name}
      )
      when is_binary(bucket_name) do
    # Emits an event with the bucket name
    %BucketCreated{bucket_name: bucket_name}
  end

  # Matches when an aggregate with the bucket name does not already exist
  # but the provided bucket name is not a string
  def execute(
        %BucketAggregate{bucket_name: nil},
        %CreateBucket{}
      ) do
    # Returns an error to the caller
    {:error, :bucket_name_must_be_string}
  end

  # Matches when the bucket name already exists
  def execute(
        %BucketAggregate{},
        %CreateBucket{}
      ) do
    # Returns an error to the caller
    {:error, :bucket_already_exists}
  end

  # Updates the aggregate so uniqueness can be checked in execute/2
  def apply(
        %BucketAggregate{} = aggregate,
        %BucketCreated{bucket_name: bucket_name}
      ) do
    %BucketAggregate{aggregate | bucket_name: bucket_name}
  end
end
