import Ecto.Query

defmodule WritersUnblockedWeb.ViewerController do
  use WritersUnblockedWeb, :controller
  alias WritersUnblocked.Repo
  alias WritersUnblocked.Story
  require Logger

  def index(conn, params) do
    query =
      case Map.fetch(params, "id") do
        # View all stories
        :error ->
          from story in Story,
          where: story.finished,
          select: story
        # View single story
        {:ok, id} ->
          from story in Story,
          where: story.id == ^id,
          where: story.finished,
          select: story
      end

    Logger.debug "vote_id: #{get_session(conn, :vote_id)}"
    render conn, "index.html", stories: Repo.all(query), vote_id: get_session(conn, :vote_id)
  end
end
