defmodule BlockclockWeb.PageController do
  use BlockclockWeb, :controller
  def aa() do
    url = "https://api.b365api.com/v1/bet365/inplay?token=52080-Pza6T0oXtec0bF"
    response = HTTPoison.get!(url)
    all= Poison.decode!(response.body)
    req =  all["results"]
  #  Blockchain.create_block(List.first(req))
  end
  def index(socket, _params) do
    url = "https://api.b365api.com/v1/bet365/inplay?token=143545-CdihPkbfqly4U3"

    response = HTTPoison.get!(url)

    req = List.flatten(Poison.decode!(response.body)["results"])

  #  IO.inspect aa
       render(socket, %{req: req})
   # render conn, "indou.html", req: req


  end
end
