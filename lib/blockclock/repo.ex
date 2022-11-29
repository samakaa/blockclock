defmodule Blockclock.Repo do
  use Ecto.Repo,
    otp_app: :blockclock,
    adapter: Ecto.Adapters.Postgres
end
