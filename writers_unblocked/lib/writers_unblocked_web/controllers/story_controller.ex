import Ecto.Changeset
import Ecto.Query

defmodule WritersUnblockedWeb.StoryController do
  use WritersUnblockedWeb, :controller
  alias WritersUnblocked.Repo
  alias WritersUnblocked.Story
  alias Ecto.Adapters.SQL
  require Logger

  def give_new_story(conn) do
    case get_session(conn, :story_id) do
      nil -> render conn, "index.html", title: "Untitled Story", body: "", create: true, finish: false
      # Story was already assigned.
      _ -> give_continue_story(conn)
    end
  end

  def give_continue_story(conn) do
    conn =
      case get_session(conn, :story_id) do
        nil ->
          case (Repo.one(
            from story in Story,
              where: not story.locked,
              where: not story.finished,
              order_by: [asc: fragment("RANDOM()")],
              limit: 1,
              select: story
          )) do
          # No available story
          nil -> conn
          # There is an available story.
          story ->
            # Locks story
            Story
            |> Repo.get(story.id)
            |> Story.changeset(%{locked: true})
            |> Repo.update()

            story = Repo.get(Story, story.id)
            conn = put_session(conn, :story_id, story.id)

            finish_length = Application.get_env(:writers_unblocked, Story)[:finish_length]
            cond do
              byte_size(story.body) < finish_length ->
                render conn, "index.html", title: story.title, body: story.body, create: false, finish: false
              true ->
                render conn, "index.html", title: story.title, body: story.body, create: false, finish: true
            end
          end

        # Story is already assigned
        _ -> conn
      end

    case get_session(conn, :story_id) do
      nil ->
        conn
        |> put_flash(:info, "No stories available to continue, you can make a new one here.")
        |> give_new_story
      id ->
        story = Repo.get(Story, id)

        finish_length = Application.get_env(:writers_unblocked, Story)[:finish_length]
        cond do
          byte_size(story.body) < finish_length ->
            render conn, "index.html", title: story.title, body: story.body, create: false, finish: false
          true ->
            render conn, "index.html", title: story.title, body: story.body, create: false, finish: true
        end
    end
  end

  def index(conn, %{"action" => action}) do
    case action do
    "new" -> give_new_story(conn)
    _     -> give_continue_story(conn)
    end
  end

  def submit_entry(conn, %{"title" => title, "append-input" => content} = params) do
    Logger.debug "Params of submit_entry:  #{inspect params}"

    max_chars = Application.get_env(:writers_unblocked, Story)[:entry_length]
    cond do
      byte_size(content) == 0 ->
        text conn, "No form data."
      String.length(content) > max_chars ->
        text conn, "Expected less than #{max_chars} characters. Got #{String.length(content)}."
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
            story =
              Story
              |> Repo.get(get_session(conn, :story_id))

            changeset =
              Story.changeset(story,
              %{body: "#{story.body}\n#{content}", locked: false})

            # New title submitted? Update title.
            changeset =
              case capitalize_title(title) do
                "" -> changeset
                title -> merge(changeset, Story.changeset(story, %{title: title}))
              end

            # Finished button clicked and content length is large enough? Set finished to true.
            changeset =
              case Map.fetch(params, "finish-button") do
                :error -> changeset
                _ ->
                  finish_length = Application.get_env(:writers_unblocked, Story)[:finish_length]
                  cond do
                    String.length(story.body) < finish_length -> changeset
                    true -> merge(changeset, Story.changeset(story, %{finished: true}))
                  end
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

  def vote(conn, %{"id" => id}) do
    Logger.debug "Old votes: #{inspect get_session(conn, :votes)}"
    Logger.debug "Voting for: #{id}"

    id = elem(Integer.parse(id), 0)
    votes_per_user = Application.get_env(:writers_unblocked, Vote)[:votes_per_user]
    votes = get_session(conn, :votes)
    conn =
      cond do
        votes == nil -> put_session(conn, :votes, [id])
        length(votes) < votes_per_user -> put_session(conn, :votes, [id] ++ votes)
        true -> conn
      end

    story = Repo.get(Story, id)

    story
    |> Story.changeset(%{votes: story.votes + 1})
    |> Repo.update()

    all_votes_used = length(get_session(conn, :votes)) >= votes_per_user

    json(conn, %{allVotesUsed: all_votes_used})
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

