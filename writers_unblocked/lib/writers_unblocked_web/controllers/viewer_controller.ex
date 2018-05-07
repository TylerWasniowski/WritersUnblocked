import Ecto.Query

defmodule WritersUnblockedWeb.ViewerController do
  use WritersUnblockedWeb, :controller
  alias WritersUnblocked.Repo
  alias WritersUnblocked.Story
  require Logger


  def index(conn, _params) do
    query =
      from story in Story,
      where: story.finished,
      select: story

    Logger.debug "vote_id: #{get_session(conn, :vote_id)}"
    render conn, "index.html", stories: Repo.all(query), vote_id: get_session(conn, :vote_id)
  end
end
