defmodule CommandBuckets.WriteSide.BucketAggregate do
  alias __MODULE__

  # Bucket creation command and event
  defmodule CreateBucket do
    @enforce_keys [:bucket_name]
    defstruct [:bucket_name]
  end

  defmodule BucketCreated do
    @derive Jason.Encoder
    @enforce_keys [:bucket_name]
    defstruct [:bucket_name]
  end

  # Set in bucket command and event
  defmodule SetInBucket do
    @enforce_keys [:bucket_name, :key, :value]
    defstruct [:bucket_name, :key, :value]
  end

  defmodule WasSetInBucket do
    # @derive allows :jason to serialize our events for database storage
    @derive Jason.Encoder
    @enforce_keys [:bucket_name, :key, :value]
    defstruct [:bucket_name, :key, :value]
  end

  # Struct to hold each aggregate instance's state
  @enforce_keys [:bucket_name]
  defstruct [:bucket_name]

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
    {:error, "Bucket name must be a string."}
  end

  # Matches when the bucket name already exists
  def execute(
        %BucketAggregate{},
        %CreateBucket{}
      ) do
    # Returns an error to the caller
    {:error, "Bucket names must be unique."}
  end

  # Matches when bucket does not exist
  def execute(
        %BucketAggregate{bucket_name: nil},
        %SetInBucket{}
      ) do
    {:error, "Bucket does not exist."}
  end

  # Matches when bucket exists
  # and both key and value are strings
  def execute(
        %BucketAggregate{},
        %SetInBucket{bucket_name: bucket_name, key: key, value: value}
      )
      when is_binary(key) and is_binary(value) do
    %WasSetInBucket{bucket_name: bucket_name, key: key, value: value}
  end

  # Matches when bucket exists
  # but key or value is not a string
  def execute(
        %BucketAggregate{},
        %SetInBucket{}
      ) do
    {:error, "Both key and value must be strings."}
  end

  # Updates the aggregate so uniqueness can be checked in execute/2
  def apply(
        %BucketAggregate{},
        %BucketCreated{bucket_name: bucket_name}
      ) do
    %BucketAggregate{bucket_name: bucket_name}
  end

  # Doesn't change the aggregate state for a WasPutInBucket event
  def apply(
        %BucketAggregate{} = aggregate_state,
        %WasSetInBucket{}
      ) do
    aggregate_state
  end
end
