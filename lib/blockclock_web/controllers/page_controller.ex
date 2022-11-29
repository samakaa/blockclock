defmodule BlockclockWeb.PageController do
  use BlockclockWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
