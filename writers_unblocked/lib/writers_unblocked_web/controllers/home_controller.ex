defmodule WritersUnblockedWeb.HomeController do
  use WritersUnblockedWeb, :controller\

  def index(conn, _params) do
    render conn, "index.html"
  end
end
