defmodule WritersUnblockedWeb.HomeController do
  use WritersUnblockedWeb, :controller
  require Logger

  def index(conn, _params) do
      render conn, "index.html"
  end
end
