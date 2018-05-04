defmodule WritersUnblockedWeb.StoryController do
  use WritersUnblockedWeb, :controller
  alias WritersUnblocked.Repo
  alias WritersUnblocked.Story
  alias Ecto.Adapters.SQL
  require Logger

  def index(conn, %{"action" => action}) do
    conn =
      case get_session(conn, :story_id) do
        nil ->
          case action do
            # Continuing story? Assign story if available.
            "continue" ->
              case (
                # Select random story id from database.
                Repo
                |> SQL.query!("""
                    SELECT id
                    FROM stories
                    WHERE locked IS NULL OR locked = 'false' ORDER BY RANDOM() LIMIT 1
                    """, [])
                |> Map.fetch(:rows)
                |> elem(1)
              ) do
                # No available stories? Don't assign story.
                [] -> conn
                # There is an available story.
                [story_query | _] ->
                  story_id = List.first(story_query)
                  # Locks story
                  Story
                  |> Repo.get(story_id)
                  |> Story.changeset(%{locked: true})
                  |> Repo.update()

                  put_session(conn, :story_id, story_id)
              end

            # New story? Don't assign story.
            _ -> conn
          end
          # Story already assigned.
          _ -> conn
      end

    Logger.debug "Story id: #{get_session(conn, :story_id)}"

    case get_session(conn, :story_id) do
      # New story? Previous story empty.
      nil -> render conn, "index.html", title: "New Story", body: ""
      # Continuing existing story? Get story from database.
      story_id ->
        story = Story
        |> Repo.get(story_id)
        render conn, "index.html", title: story.title, body: story.body
    end
  end

  def submit_entry(conn, %{"append-input" => input}) do
    number_of_bytes = byte_size(input)
    number_of_characters = String.length(input)
    cond do
      number_of_bytes == 0 ->
        text conn, "No form data."
      number_of_characters < 3 or number_of_characters > 240 ->
        text conn, "Expected between 3 and 240 characters. Got #{number_of_characters}."
      String.printable?(input) ->
        # Inserts/updates story.
        case get_session(conn, :story_id) do
          # No story selected? Create new story.
          nil ->
            %Story{title: "Placeholder Title", body: input}
            |> Repo.insert()

          # Story selected? Append to old story.
          _ ->
            story_item =
              Story
              |> Repo.get(get_session(conn, :story_id))

            story_item
            |> Story.changeset(%{body: "#{story_item.body}\n#{input}", locked: false})
            |> Repo.update()
        end

        # Unlink story and go back to the home page
        conn
        |> delete_session(:story_id)
        |> redirect(to: "/")
      true ->
        text conn, "Data contains non-printable chars."
    end

  end
end
