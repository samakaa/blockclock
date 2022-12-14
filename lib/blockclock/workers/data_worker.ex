defmodule BlockClock.Workers.DataWorker do
  use GenServer

  require Logger
  alias BlockClock.Blockchain

  # Client

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, %{
      interval_seconds: Keyword.get([opts], :interval_seconds, 1),
      timer_ref: nil
    })
  end

  # Server (callbacks)

  #@impl true
  def init(state) do
    updated_state = schedule_worker(state)
    fetch_flux()
    fetch_event()
    {:ok, updated_state}
  end

  def schedule_worker(%{interval_seconds: interval_seconds} = state) do
    # interval provided in seconds, but Process expects it as millis
    after_ms = interval_seconds * 10_000
    timer_ref = Process.send_after(self(), :run, after_ms)
    %{state | timer_ref: timer_ref}

  end

  @impl true
  def handle_info(:run, state) do
    fetch_event()
    fetch_flux()
    updated_state = schedule_worker(state)

  #  IO.inspect fetch_flux()
    IO.inspect aa()
    #IO.inspect fetch_flux()
    {:noreply, updated_state}
  end
  def aa() do
    Blockchain.fetch_flux()
  end
  def fetch_event() do
    Blockchain.create_event()
  end

  def fetch_flux() do

       Blockchain.create_block()


  end

end
