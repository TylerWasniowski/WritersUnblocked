import Ecto.Query, only: [from: 2]

defmodule WritersUnblockedWeb.ViewerController do
  use WritersUnblockedWeb, :controller
  alias WritersUnblocked.Repo
  alias WritersUnblocked.Story
  require Logger

  def index(conn, _params) do
    render conn, "index.html", stories: Repo.all(from story in Story, select: story)
  end
end
