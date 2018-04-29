defmodule WritersUnblockedWeb.HomeController do
  use WritersUnblockedWeb, :controller
  alias WritersUnblocked.Repo
  alias WritersUnblocked.Session
  require Logger

  def index(conn, _params) do
    if get_session(conn, :session_id) do
      render conn, "index.html"
    else
      %Session{}
      |> Repo.insert

      conn
      |> put_session(:session_id, 255)
      |> render("index.html")
    end
  end
end
