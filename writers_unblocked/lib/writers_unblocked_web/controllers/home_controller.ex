defmodule WritersUnblockedWeb.HomeController do
  use WritersUnblockedWeb, :controller
  require Logger

  def index(conn, _params) do
    if (get_session(conn, :session_id)) do
      render conn, "index.html"
    else
      conn
      |> put_session(:session_id, "10")
      |> render("index.html")
    end
  end
end
