defmodule WritersUnblockedWeb.StoryController do
  use WritersUnblockedWeb, :controller
  require Logger

  def index(conn, params) do
    params
    |> Map.fetch("action")
    |> elem(1)
    |> Logger.info

    conn
    |> get_session(:session_id)
    |> Logger.debug
    render conn, "index.html"
  end
end
