defmodule WritersUnblockedWeb.HomeController do
  use WritersUnblockedWeb, :controller
  alias WritersUnblocked.Repo
  alias WritersUnblocked.Session
  require Logger

  def index(conn, _params) do
    if get_session(conn, :session_id) do
      render conn, "index.html"
    else
      # Make a new session in the database, and save the id
      session_id = %Session{}
      |> Repo.insert
      |> elem(1)
      |> Map.fetch(:id)
      |> elem(1)

      Logger.debug "Created session with id: #{session_id}"

      conn
      |> put_session(:session_id, session_id)
      |> render("index.html")
    end
  end
end
