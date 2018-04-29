defmodule WritersUnblockedWeb.StoryController do
  use WritersUnblockedWeb, :controller
  require Logger

  def index(conn, params) do
    params
    |> Map.fetch("action")
    |> elem(1)
    |> Logger.info
    
    # data call to fetch title and body of random story, plus do bookeeping with conn
    # x = Data.acquire_any_unfinished_story(conn)
    
    render conn, "index.html"
  end
end
