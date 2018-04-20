defmodule WritersUnblockedWeb.StoryController do
  use WritersUnblockedWeb, :controller
  require Logger

  def index(conn, params) do
    Logger.info elem(Map.fetch(params, "action"), 1)
    render conn, "index.html"
  end
end
