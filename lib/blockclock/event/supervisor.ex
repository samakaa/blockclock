defmodule BlockClock.Event.Supervisor do

  @doc"""
  The Supervisor which keeps track of our `DataWorker` GenServer.
  """

  use Supervisor

  alias BlockClock.Event.DataEvent

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    case Keyword.get([opts], :start_workers, true) do
      # Do not start any children if workers should not be started
      false -> :ignore
      _ ->
        children = [
          # Pepare the worker specs
          {DataEvent, Keyword.get([opts], :data_event)}

        ]

        Supervisor.init(children, strategy: :one_for_one)
    end
  end
end
