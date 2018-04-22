defmodule WritersUnblockedWeb.StoryController do
  use WritersUnblockedWeb, :controller
  require Logger

  def on_new(conn, params) do
    render conn, "new.html"
  end


  def on_continue(conn, params) do
    render conn, "continue.html"
  end

end
