import Ecto.Query, only: [from: 2, where: 2]

defmodule WritersUnblockedWeb.StoryController do
  use WritersUnblockedWeb, :controller
  alias WritersUnblocked.Repo
  alias WritersUnblocked.Story
  alias Ecto.Adapters.SQL
  require Logger

  def index(conn, params) do
    # Make sure connection has a session
    # conn =
      # case get_session(conn, :story_id) do
      #   nil -> put_session(
      #     conn,
      #     :story_id,
      #     %Session{}
      #     |> Repo.insert
      #     |> elem(1)
      #     |> Map.fetch(:id)
      #     |> elem(1)
      #   )
      #   _ -> conn
      # end

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
              WHERE locked = 'false' ORDER BY RANDOM() LIMIT 1", [])
              |> Map.fetch(:rows)
              |> elem(1)
            ) do
              # No available stories? Making a new story.
              [] -> ["", ""]
              # Rows is a list of lists of cell values, we know we will have at most one row so we take the first.
              [head | _] ->
                # Assigns story id to story
                Story
                |> Repo.get(List.first(head))
                |> Story.changeset(%{locked: 'true'})
                |> Repo.update()

                conn =
                  put_session(
                    conn,
                    :story_id,
                    List.first(head)
                  )

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
          # I know you guys are working hard and thank you, but I dont go crazy with the sessions thing.
					# Also everyone should do mix phx.server and test things out in browser before pushing changes.
					# Story
          # |> Repo.get(get_session(conn, :session_id))
          # note the false
          Story |> Repo.all

        if (!get_session(conn, :story_id)) do # checks if the story is already in the database
          newstory = %WritersUnblocked.Story{title: "Placeholder Title", body: input}
          WritersUnblocked.Repo.insert(newstory)
          text conn, "Added Story to Database. You clicked the update story button with form input: " <> input
        else
          story_item =
            Story
            |> Repo.get(get_session(conn, :story_id))

          story_item
          |> Story.changeset(%{body: input})
          |> Repo.update()
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


