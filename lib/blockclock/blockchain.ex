defmodule BlockClock.Blockchain do
  @moduledoc """
  The Blockchain context.
  """
  alias BlockclockWeb.EventLive
  alias BlockClock.Blockchain.Block
  alias BlockClock.Store
  alias BlockClock.Match
  @doc """
  Creates a block.
  """
  def fetch_inplay() do
    url = "https://api.b365api.com/v1/bet365/inplay?token=143545-CdihPkbfqly4U3"

    response = HTTPoison.get!(url)
    all= List.flatten(Poison.decode!(response.body)["results"])

  end
  def fetch_fluxx() do
    url = "https://api.b365api.com/v1/bet365/inplay?token=143545-CdihPkbfqly4U3"

    response = HTTPoison.get!(url)
    all= List.flatten(Poison.decode!(response.body)["results"])
    for event <- all do
       zz = event["CT"]
       cc = event["CC"]
      if event["type"] == "EV" && zz =="NCAAB Extra Games\r\n"|| cc=="HB-JAPTCM" do
      aa =  event["ID"]

        end
          end
  end

  def fetch_flux() do
    aa = fetch_fluxx()  |> Enum.filter(fn  v -> v != nil end)

    for event <- aa do

        url ="https://api.b365api.com/v1/bet365/event?token=143545-CdihPkbfqly4U3&FI=#{event}" |> to_string()

  end
  end

  def bhim() do
    aa= fetch_flux()
      for event <- aa do
        response = HTTPoison.get!(event)
        all= Poison.decode!(response.body)["results"]
      end


  end
  def bhimm() do
    aa= List.flatten(bhim())

  end
  def create_event() do
    match = bhimm()

    Match.set_latest_match(match)
    match
  end
  def create_block() do
    block = fetch_inplay()

    Store.set_latest_block(block)
    block
  end

  end
