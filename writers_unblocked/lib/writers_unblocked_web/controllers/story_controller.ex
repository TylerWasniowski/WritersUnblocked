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
          # Continuing existing story? Get story from database.
          "continue" ->
            case (
              Repo
              |> SQL.query!("SELECT title, body FROM stories WHERE session IS NULL ORDER BY RANDOM() LIMIT 1", [])
              |> Map.fetch(:rows)
              |> elem(1)
            ) do
              # No available stories? Making a new story.
              [] -> ["", ""]
              # Rows is a list of lists of cell values, we know we will have at most one row so we take the first.
              [head | _] -> head
            end
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
        aquery = from s in "stories", where: s.title == ^storyid, select: s.body # makes a query statement, similar to SQL
        astory = WritersUnblocked.Repo.all(aquery) # Queries the database, from the "stories" table

        storyitem = List.first(astory) # gets the story text from said item

        if (storyitem == nil) do # checks if the story is already in the database
          newstory = %WritersUnblocked.Story{title: storyid, body: input}
          WritersUnblocked.Repo.insert(newstory)
          text conn, "Added Story to Database. You clicked the update story button with form input: " <> input
        else
          text conn, "Found something: " <> storyitem
        end
        text conn, "testing printable"
      true ->
        text conn, "Data contains non-printable chars."
    end

  end
end
