defmodule WritersUnblockedWeb.SingleController do
  use WritersUnblockedWeb, :controller
  alias WritersUnblocked.Repo
  # alias WritersUnblocked.Story
  alias Ecto.Adapters.SQL
  require Logger

  def index(conn, %{"story-id" => id }) do
    #case Integer.parse(storyid) do
    #:error -> text conn, "invalid id"
    #_ -> 
      qres = Repo |> SQL.query!("""
                    SELECT title, body
                    FROM stories
                    WHERE id =#{id} AND finished
                    LIMIT 1
                    """, [])
                |> Map.fetch(:rows)
                |> elem(1)
      case qres do
      [] ->
        text conn, "no story with id found"
      [[title, body]] ->
        text conn, "title: " <> title <> ",\nbody: " <> body
      _ ->
        IO.inspect qres
        text conn, "error"
      end
    #end
  end
end
