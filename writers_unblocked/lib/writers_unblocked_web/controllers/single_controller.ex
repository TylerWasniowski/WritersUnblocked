defmodule WritersUnblockedWeb.SingleController do
  use WritersUnblockedWeb, :controller
  alias WritersUnblocked.Repo
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
        conn
        |> put_flash(:info, "No story with id #{id} found.")
        |> redirect(to: "/")
      [[qtitle, qbody]] ->
        render conn, "index.html", title: qtitle, body: qbody
      _ ->
        IO.inspect qres
        conn
        |> put_flash(:error, "Server internal error.")
        |> redirect(to: "/")
      end
    #end
  end
end
