defmodule WritersUnblockedWeb.StoryController do
  use WritersUnblockedWeb, :controller
  require Logger

  def index(conn, params) do
    params
    |> Map.fetch("action")
    |> elem(1)
    |> Logger.info
    
    render conn, "index.html"
  end
end
