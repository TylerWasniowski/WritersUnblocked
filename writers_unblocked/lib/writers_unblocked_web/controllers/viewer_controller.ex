import Ecto.Query

defmodule WritersUnblockedWeb.ViewerController do
  use WritersUnblockedWeb, :controller
  alias WritersUnblocked.Repo
  alias WritersUnblocked.Story
  require Logger

  def index(conn, params) do
    number_of_stories = Application.get_env(:writers_unblocked, Viewer)[:number_of_stories]
    query =
      case Map.fetch(params, "id") do
        # View all stories
        :error ->
          from story in Story,
            where: story.finished,
            order_by: [asc: fragment("RANDOM()")],
            limit: ^number_of_stories,
            select: story
        # View single story
        {:ok, id} ->
          from story in Story,
            where: story.id == ^id,
            where: story.finished,
            order_by: [asc: fragment("RANDOM()")],
            limit: ^number_of_stories,
            select: story
      end

    Logger.debug "votes: #{inspect get_session(conn, :votes)}"
    render conn, "index.html", stories: Repo.all(query), votes: get_session(conn, :votes)
  end
end
