import Ecto.Changeset

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
                    WHERE NOT locked AND NOT finished
                    ORDER BY RANDOM() LIMIT 1
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
        story = Repo.get(Story, story_id)
        render conn, "index.html", title: story.title, body: story.body
    end
  end

  def submit_entry(conn, %{"title" => title, "append-input" => content} = params) do
    Logger.debug "Params: #{inspect(params)}"

    cond do
      byte_size(content) == 0 ->
        text conn, "No form data."
      String.length(content) < 3 or String.length(content) > 240 ->
        text conn, "Expected between 3 and 240 characters. Got #{String.length(content)}."
      String.printable?(content) ->
        # Inserts/updates story.
        case get_session(conn, :story_id) do
          # No story selected? Create new story.
          nil ->
            case capitalize_title(title) do
              "" -> Repo.insert(%Story{title: "Untitled Story", body: content})
              title -> Repo.insert(%Story{title: title, body: content})
            end

          # Story selected? Append to old story.
          _ ->
            story_item =
              Story
              |> Repo.get(get_session(conn, :story_id))

            changeset =
              Story.changeset(story_item,
              %{body: "#{story_item.body}\n#{content}", locked: false})

            # New title submitted? Update title.
            changeset =
              case capitalize_title(title) do
                "" -> changeset
                title -> merge(changeset, Story.changeset(story_item, %{title: title}))
              end

            # Finished button clicked? Set finished to true.
            changeset =
              case Map.fetch(params, "finish-button") do
                :error -> changeset
                _ -> merge(changeset, Story.changeset(story_item, %{finished: true}))
              end

            Repo.update(changeset)
        end

        # Unlink story and go back to the home page
        conn
        |> delete_session(:story_id)
        |> put_flash(:info, "Your input has been recorded.")
        |> redirect(to: "/") # , # statmsg: "string var xyz") #this apparently doesnt work like render, or the html.eex was wrong
      true ->
        text conn, "Data contains non-printable chars."
    end
  end

  # Automatically capitalize title (made by Jon)
  @nocapset MapSet.new(["a", "an", "the", "of", "and", "on", "or", "to", "by"])
  def capitalize_title(instr) do
    case String.split(instr, " ", trim: true) do
      [] ->
        ""
      [head|rest] ->
        head = String.capitalize(head)
        if Enum.empty?(rest) do
          head
        else
          head <> " " <> (
          Enum.map(rest, fn(s) ->  if MapSet.member?(@nocapset, s), do: s, else: String.capitalize(s) end) |> Enum.join(" ") )
        end
      end
  end
end
