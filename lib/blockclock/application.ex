defmodule Blockclock.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  @tmp Application.compile_env(:block_clock, BlockClock.Workers)
#  @tmp Application.compile_env(:block_clock, BlockClock.Event)

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Blockclock.Repo,
      # Start the Telemetry supervisor
      BlockclockWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Blockclock.PubSub},
      # Start the Endpoint (http/https)
      BlockclockWeb.Endpoint,
      # Start a worker by calling: Blockclock.Worker.start_link(arg)
      # {Blockclock.Worker, arg}
      BlockClock.Store.Supervisor,
      BlockClock.Match.Supervisor,

      {BlockClock.Workers.Supervisor, workers_config()}
      #{BlockClock.Event.Supervisor, event_config()}

    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Blockclock.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BlockclockWeb.Endpoint.config_change(changed, removed)
    :ok
  end
  @spec workers_config :: any
  def workers_config() do
    Application.get_env(:block_clock, BlockClock.Workers)
    #Application.compile_env
  end
  #@spec event_config :: any
  #def event_config() do
  #  Application.get_env(:block_clock, BlockClock.Event)
    #Application.compile_env
  #end
end
