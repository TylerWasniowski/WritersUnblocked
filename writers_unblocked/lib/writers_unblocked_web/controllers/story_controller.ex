import Ecto.Query, only: [from: 2]

defmodule WritersUnblockedWeb.StoryController do
  use WritersUnblockedWeb, :controller
  alias WritersUnblocked.Repo
  alias WritersUnblocked.Session
  alias Ecto.Adapters.SQL
  require Logger

  def index(conn, params) do
    # Make sure connection has a session
    conn =
      case get_session(conn, :session_id) do
        nil -> put_session(
          conn,
          :session_id,
          %Session{}
          |> Repo.insert
          |> elem(1)
          |> Map.fetch(:id)
          |> elem(1)
        )
        _ -> conn
      end

    # Get previous story
    story =
      case (
        params
        |> Map.fetch("action")
        |> elem(1)
        ) do
          # Continuing existing story? Get story from database
          "continue" ->
            Repo
            |> SQL.query!("SELECT title, body FROM stories WHERE session IS NULL ORDER BY RANDOM() LIMIT 1", [])
            |> Map.fetch(:rows)
            |> elem(1)
            |> List.first
          # New story? Empty title and empty text.
          _ -> ["", ""]
        end
    story_title =
      List.first story
    story_text =
      story
      |> Enum.at(1)

    Logger.debug story_text
    #JON'S CODE HERE


    render conn, "index.html"
  end

  def submit_entry(conn, %{"append-input" => input} = params) do

    IO.puts("params inspection: ")
    IO.inspect(params)

    IO.puts("conn inspection: ")
    IO.inspect(conn)

    cond do
      byte_size(input) == 0 ->
        text conn, "No form data."
      String.printable?(input) ->
        text conn, "You clicked the update story button with form input: " <> input
      true ->
        text conn, "Data contains non-printable chars."
    end

  end
end
