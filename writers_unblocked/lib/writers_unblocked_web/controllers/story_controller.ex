import Ecto.Query, only: [from: 2, where: 2]

defmodule WritersUnblockedWeb.StoryController do
  use WritersUnblockedWeb, :controller
  alias WritersUnblocked.Repo
  alias WritersUnblocked.Session
  alias WritersUnblocked.Story
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
              |> SQL.query!("SELECT id, title, body
              FROM stories
              WHERE session IS NULL ORDER BY RANDOM() LIMIT 1", [])
              |> Map.fetch(:rows)
              |> elem(1)
            ) do
              # No available stories? Making a new story.
              [] -> ["", ""]
              # Rows is a list of lists of cell values, we know we will have at most one row so we take the first.
              [head | _] ->
                # Assigns session id to story
                Repo
                |> SQL.query!("UPDATE stories
                SET session = #{get_session(conn, :session_id)}
                WHERE id = #{List.first(head)}", [])

                head
                |> List.delete_at(0)
            end
          # New story? Empty title and empty text.
          _ -> ["",""]
        end
    story_title =
      story
      |> Enum.at(0)
    story_text =
      story
      |> Enum.at(1)

    render conn, "index.html", title: story_title, body: story_text
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
        story_item =
          Story
          |> Repo.get(get_session(conn, :session_id))

        if (story_item == nil) do # checks if the story is already in the database
          newstory = %WritersUnblocked.Story{title: "Placeholder Title", body: input}
          WritersUnblocked.Repo.insert(newstory)
          text conn, "Added Story to Database. You clicked the update story button with form input: " <> input
        else
          text conn, "Found something: " <> story_item
        end
        text conn, "testing printable"
      true ->
        text conn, "Data contains non-printable chars."
    end

  end
end

#Select random story - Tyler
#Pass into view then into template and display the story in continue story - Jon

#render_to_iodata?


