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

  @impl true
  def init(state) do
    updated_state = schedule_worker(state)
    fetch_flux()
    {:ok, updated_state}
  end

  def schedule_worker(%{interval_seconds: interval_seconds} = state) do
    # interval provided in seconds, but Process expects it as millis
    after_ms = interval_seconds * 1_000
    timer_ref = Process.send_after(self(), :run, after_ms)
    %{state | timer_ref: timer_ref}

  end

  @impl true
  def handle_info(:run, state) do
    #fetch_data()

    fetch_flux()
    updated_state = schedule_worker(state)
    #IO.inspect fetch_flux()
    IO.puts "aa"
    {:noreply, updated_state}
  end

  def fetch_data() do
    case HTTPoison.get("https://mempool.space/api/blocks") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Poison.decode!
        |> List.first
        |> Blockchain.create_block
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end
  def aa() do
    url = "https://randomuser.me/api/?fbclid=IwAR180CISiS-yJdnW_bpLgeSK5o_ndkJ4r_kGzy961TJRjeAEXvcnoqfFT4E"
    response = HTTPoison.get!(url)
    all= Poison.decode!(response.body)
    req =  all["results"]["login"]
  #  Blockchain.create_block(List.first(req))
  end
  def fetch_flux() do
    case HTTPoison.get("https://randomuser.me/api/?fbclid=IwAR0I27VMDYj31KsucW2UlDco5-zNz3r3jiQW2UjYEy7CEqIKYHdYJpVVS6U") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        #body
        #|>Poison.decode!
        Blockchain.create_block(List.first(Poison.decode!(body)["results"]))


      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason


    end
  end

end
